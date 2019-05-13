import '../resource.dart';
import 'address.dart';

class Shipping extends Resource {
  Address get address {
    var value = resourceMap['address'];
    if (value == null)
      return null;
    else
      return  Address.fromMap(value);
  }

  String get name => resourceMap['name'];

  String get carrier => resourceMap['carrier'];

  String get phone => resourceMap['phone'];

  String get trackingNumber => resourceMap['tracking_number'];

  Shipping.fromMap(Map dataMap) : super.fromMap(dataMap);
}
