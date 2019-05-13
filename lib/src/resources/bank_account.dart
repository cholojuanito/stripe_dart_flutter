import '../resource.dart';
import '../resource_collection.dart';

class BankAccount extends Resource {
  String get id => resourceMap['id'];

  final String object = 'bank_account';

  String get country => resourceMap['country'];

  String get currency => resourceMap['currency'];

  bool get defaultForCurrency => resourceMap['default_for_currency'];

  String get last4 => resourceMap['last4'];

  String get status => resourceMap['status'];

  String get bankName => resourceMap['bank_name'];

  String get fingerprint => resourceMap['fingerprint'];

  String get routingNumber => resourceMap['routing_number'];

  String get accountNumber => resourceMap['account_number'];

  BankAccount.fromMap(Map dataMap) : super.fromMap(dataMap);
}

class BankAccountCollection extends ResourceCollection {
  BankAccount getInstanceFromMap(map) => BankAccount.fromMap(map);

  BankAccountCollection.fromMap(Map map) : super.fromMap(map);
}
