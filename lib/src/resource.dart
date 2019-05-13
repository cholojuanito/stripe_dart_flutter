import 'exceptions.dart';

/// All objects sent through the Stripe REST API are [Resource]s, but only
/// [ApiResource]s can be created, deleted, etc...
///
/// Instances of this Class can only be retrieved through the use of another
/// [ApiResource].
abstract class Resource {
  final Map resourceMap;

  /// Creates this resource from a JSON string.
  Resource.fromMap(this.resourceMap);

  /// Whenever a value has to be transformed when retrieved (like a DateTime),
  /// it is cached in this map to avoid duplicating objects.
  Map _cachedDataMap = {};

  /// Returns a DateTime from given dataMap key, and caches the value for future
  /// use.
  DateTime getDateTimeFromMap(String key) {
    var cachedValue;
    if ((cachedValue = _cachedDataMap[key]) != null) return cachedValue;
    if (resourceMap[key] == null) return null;
    int value = resourceMap[key];
    cachedValue = new DateTime.fromMillisecondsSinceEpoch(value * 1000);
    _cachedDataMap[key] = cachedValue;
    return cachedValue;
  }

  Map toMap() {
    return resourceMap;
  }

  String getIdForExpandable(String key) {
    var value = resourceMap[key];
    if (value is String)
      return value;
    else if (value is Map && value.containsKey('id'))
      return value['id'];
    else
      return null;
  }
}

/// The base class for request resources (eg: [CustomerCreation],
/// [CustomerUpdate], etc...)
abstract class ResourceRequest {
  /// Holds all values that have been set/changed.
  /// You should not access this map directly, but use [setMap] and [getMap].
  Map<String, dynamic> resourceReqMap = {};

  setMap(String key, dynamic value) {
    // TODO write a better exception
    if (resourceReqMap.containsKey(key))
      throw new BadRequestException('You can not set the same key twice.');
    resourceReqMap[key] = value;
  }

  /// Returns the [resourceReqMap] and checks that all [required] fields are set.
  getMap() {
    resourceReqMap.forEach((k, v) {
      if (v is ResourceRequest) resourceReqMap[k] = v.getMap();
    });
    return resourceReqMap;
  }

  String _underscore(String camelized) {
    return camelized.replaceAllMapped(new RegExp(r'([A-Z])'),
        (Match match) => '_${match.group(1).toLowerCase()}');
  }

  String toString() {
    return resourceReqMap.toString();
  }
}
