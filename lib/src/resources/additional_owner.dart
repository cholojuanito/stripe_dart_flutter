import '../resource.dart';
import 'address.dart';
import 'date.dart';
import 'verification.dart';

class AdditionalOwner extends Resource {
  Address get address {
    var value = resourceMap['address'];
    if (value == null)
      return null;
    else
      return  Address.fromMap(value);
  }

  Date get dateOfBirth {
    var value = resourceMap['dob'];
    if (value == null)
      return null;
    else
      return  Date.fromMap(value);
  }

  Verification get verification {
    var value = resourceMap['verification'];
    if (value == null)
      return null;
    else
      return  Verification.fromMap(value);
  }

  String get firstName => resourceMap['first_name'];

  String get lastName => resourceMap['last_name'];

  AdditionalOwner.fromMap(Map dataMap) : super.fromMap(dataMap);
}
