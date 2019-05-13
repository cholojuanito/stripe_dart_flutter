import '../resource.dart';
import 'additional_owner.dart';
import 'address.dart';
import 'date.dart';
import 'verification.dart';

class LegalEntity extends Resource {
  Address get address {
    var value = resourceMap['address'];
    if (value == null)
      return null;
    else
      return new Address.fromMap(value);
  }

  Date get dateOfBirth {
    var value = resourceMap['dob'];
    if (value == null)
      return null;
    else
      return new Date.fromMap(value);
  }

  Address get personalAddress {
    var value = resourceMap['personal_address'];
    if (value == null)
      return null;
    else
      return new Address.fromMap(value);
  }

  Verification get verification {
    var value = resourceMap['verification'];
    if (value == null)
      return null;
    else
      return new Verification.fromMap(value);
  }

  List<AdditionalOwner> get additionalOwners {
    var list = [];
    if (!resourceMap.containsKey('additional_owners') ||
        !(resourceMap['additional_owners'] is List)) return null;
    for (Map value in resourceMap['additional_owners']) {
      list.add(new AdditionalOwner.fromMap(value));
    }
    return list;
  }

  String get businessName => resourceMap['business_name'];

  String get firstName => resourceMap['first_name'];

  String get lastName => resourceMap['last_name'];

  String get type => resourceMap['type'];

  LegalEntity.fromMap(Map dataMap) : super.fromMap(dataMap);
}
