import '../resource.dart';

class Address extends Resource {
  String get line1 => resourceMap['line1'];

  String get line2 => resourceMap['line2'];

  String get city => resourceMap['city'];

  String get state => resourceMap['state'];

  String get postalCode => resourceMap['postal_code'];

  String get country => resourceMap['country'];

  Address.fromMap(Map dataMap) : super.fromMap(dataMap);
}
