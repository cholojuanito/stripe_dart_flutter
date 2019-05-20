import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';

import 'exceptions.dart';

/// Group of top level functions that can be used to communicate with the Stripe API

final Logger logger = Logger('StripeService');
const String _HTTPS = 'https';
const String _GET = 'GET';
const String _POST = 'POST';
const String _DELETE = 'DELETE';
const String _host = 'api.stripe.com';
const String _apiVersionPath = 'v1';

// Request Header Constants
const String _authHeaderKey = 'Authorization';
const String _idempotencyHeaderKey = 'Idempotency-Key';
const String _stripeVersionHeaderKey = 'Stripe-Version';
// This needs to be updated if Stripe changes their API and those changes are reflected in this repo.
const String _stripeVersion = '2019-03-14';

/// The Api key used to communicate with Stripe
/// Use your test secret key for running in test mode
String _apiKey;

void setApiKey(String apiKey) {
  _apiKey = apiKey;
}

/// Useful for testing.
HttpClient _getClient() => HttpClient();

/// Makes a post request to the Stripe API to given path and parameters.
Future<Map> createResource(final List<String> pathParts, final Map data,
    {String hostOverride, String idempotencyKey}) {
  var hostToUse = (hostOverride == null) ? _host : hostOverride;
  return _request(_POST, pathParts,
      data: data, hostOverride: hostToUse, idempotencyKey: idempotencyKey);
}

/// Makes a delete request to the Stripe API
Future<Map> deleteResource(final List<String> pathParts, {final Map data}) =>
    _request(_DELETE, pathParts, data: data);

/// Makes a get request to the Stripe API for a single resource item
/// [data] is used for expanding resources
Future<Map> retrieveResource(final List<String> pathParts,
    {final Map data, String hostOverride}) {
  var hostToUse = (hostOverride == null) ? _host : hostOverride;
  return _request(_GET, pathParts, data: data, hostOverride: hostToUse);
}

/// Makes a get request to the Stripe API to update an existing resource
Future<Map> updateResource(final List<String> pathParts, final Map data) =>
    _request(_POST, pathParts, data: data);

/// Makes a request to the Stripe API for all items of a resource
/// [data] is used for pagination
Future<Map> listResource(final List<String> pathParts,
    {final Map data, String hostOverride}) {
  var hostToUse = (hostOverride == null) ? _host : hostOverride;
  return _request(_GET, pathParts, data: data, hostOverride: hostToUse);
}

/// Makes a request a get request to the Stripe API
Future<Map> getResource(final List<String> pathParts, {final Map data}) {
  return _request(_GET, pathParts, data: data);
}

/// Makes a request a post request to the Stripe API
Future<Map> postResource(final List<String> pathParts, {final Map data}) {
  return _request(_POST, pathParts, data: data);
}

Future<Map> _request(final String method, final List<String> pathParts,
    {final Map data, String hostOverride, String idempotencyKey}) async {
  pathParts.insert(0, _apiVersionPath);
  var path = '/' + pathParts.map(Uri.encodeComponent).join('/');
  Uri uri;
  var hostToUse = (hostOverride == null) ? _host : hostOverride;

  if (method == _GET && data != null) {
    uri = Uri(
        scheme: _HTTPS,
        host: hostToUse,
        path: path,
        query: encodeMap(data),
        userInfo: '${_apiKey}:');
  } else {
    uri = Uri(
      scheme: _HTTPS,
      host: hostToUse,
      path: path,
      userInfo: '${_apiKey}:',
    );
  }
  logger.finest('Sending ${method} request to API ${uri}');
  int responseStatusCode;
  var request = await _getClient().openUrl(method, uri);

  // Set headers
  request.headers.add(_authHeaderKey, 'Bearer $_apiKey');
  request.headers.add(_stripeVersionHeaderKey, _stripeVersion);
  if (idempotencyKey != null) {
    request.headers.add(_idempotencyHeaderKey, idempotencyKey);
  }

  if (method == _POST && data != null) {
    // Now convert the params to a list of UTF8 encoded bytes of a uri encoded
    // string and add them to the request
    var encodedData = utf8.encode(encodeMap(data));
    request.headers.add('Content-Type', 'application/x-www-form-urlencoded');
    request.headers.add('Content-Length', encodedData.length);
    request.add(encodedData);
  }

  // Send request off and handle response
  HttpClientResponse response = await request.close();
  responseStatusCode = response.statusCode;
  var bodyData = await response.transform(utf8.decoder).toList();
  var body = bodyData.join('');
  Map responseMap;
  try {
    responseMap = jsonDecode(body);
  } on Error {
    throw InvalidRequestErrorException(
        'The JSON returned was unparsable (${body}).');
  }

  // Handle and log any errors
  if (responseStatusCode != 200) {
    if (responseMap['error'] == null) {
      throw InvalidRequestErrorException(
          'The status code returned was ${responseStatusCode} but no error was provided.');
    }
    Map error = responseMap['error'];
    switch (error['type']) {
      case 'invalid_request_error':
        throw InvalidRequestErrorException(error['message']);
        break;
      case 'api_error':
        throw ApiErrorException(error['message']);
        break;
      case 'card_error':
        throw CardErrorException(
            error['message'], error['code'], error['param']);
        break;
      default:
        throw InvalidRequestErrorException(
            'The status code returned was ${responseStatusCode} but no error type was provided.');
    }
  }
  return responseMap;
}

void recursiveEncodeMap(final Map data, final String k,
    final List<String> output, List<String> prevKeys) {
  var hasProps = false;
  prevKeys.add(k);
  for (String kk in data[k].keys) {
    hasProps = true;
    if (data[k][kk] is Map) {
      recursiveEncodeMap(data[k], kk, output, prevKeys);
    } else {
      String str = prevKeys[0];
      for (var i = 1; i < prevKeys.length; i++) {
        str += '[${prevKeys[i]}]';
      }
      str += '[$kk]';
      output.add(Uri.encodeComponent(str) +
          '=' +
          Uri.encodeComponent(data[k][kk].toString()));
    }
  }
  if (!hasProps) {
    output.add(Uri.encodeComponent(k) + '=');
  }

  prevKeys.removeLast();
  return;
}

/// Takes a map, and returns a properly escaped Uri String.
String encodeMap(final Map data) {
  List<String> output = [];
  List<String> prevKeys = [];
  for (String k in data.keys) {
    if (data[k] is Map) {
      recursiveEncodeMap(data, k, output, prevKeys);
    } else if (data[k] is List) {
      for (String v in data[k]) {
        output
            .add(Uri.encodeComponent('${k}[]') + '=' + Uri.encodeComponent(v));
      }
    } else if (data[k] is int) {
      output.add(Uri.encodeComponent(k) + '=' + data[k].toString());
    } else {
      output.add(Uri.encodeComponent(k) + '=' + Uri.encodeComponent(data[k]));
    }
  }
  return output.join('&');
}
