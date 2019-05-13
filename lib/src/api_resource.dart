import 'resource.dart';
import 'exceptions.dart';

/// ApiResources are the main resources of the Stripe API
/// Many of them provide functions to e.g. create, retrieve or delete
/// Every ApiResource has a unique [name]
abstract class ApiResource extends Resource {
  String object;

  /// Creates this api resource from a JSON string.
  ApiResource.fromMap(dataMap) : super.fromMap(dataMap) {
    assert(object != null);
    if (resourceMap == null)
      throw InvalidDataReceivedException('The dataMap must not be null');
    if (resourceMap['object'] != object)
      throw InvalidDataReceivedException(
          'The data received was not for object ${object}');
  }
}
