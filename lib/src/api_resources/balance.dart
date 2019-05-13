import '../api_resource.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

import 'card.dart';
import 'charge.dart';

/// [Balance](https://stripe.com/docs/api/curl#balance)
class Balance extends Resource {
  final String object = 'balance';

  static var path = 'balance';

  bool get livemode => resourceMap['livemode'];

  List<Fund> get available {
    List funds = resourceMap['available'];
    assert(funds != null);
    return funds.map((fund) => Fund.fromMap(fund)).toList(growable: false);
  }

  List<Fund> get pending {
    List funds = resourceMap['pending'];
    assert(funds != null);
    return funds.map((fund) => Fund.fromMap(fund)).toList(growable: false);
  }

  Balance.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve a balance](https://stripe.com/docs/api/curl#retrieve_balance)
  static Future<Balance> retrieve() async {
    var dataMap = await StripeService.get([Balance.path]);
    return Balance.fromMap(dataMap);
  }
}

class BalanceTransaction extends ApiResource {
  String get id => resourceMap['id'];

  final String object = 'balance_transaction';

  static var path = 'history';

  int get amount => resourceMap['amount'];

  DateTime get availableOn => getDateTimeFromMap('available_on');

  DateTime get created => getDateTimeFromMap('created');

  String get currency => resourceMap['currency'];

  int get fee => resourceMap['fee'];

  List<FeeDetails> get feeDetails {
    List feeDetails = resourceMap['fee_details'];
    assert(feeDetails != null);
    return feeDetails
        .map((feeDetails) => FeeDetails.fromMap(feeDetails))
        .toList(growable: false);
  }

  int get net => resourceMap['net'];

  String get status => resourceMap['status'];

  String get type => resourceMap['type'];

  String get description => resourceMap['description'];

  String get source {
    return this.getIdForExpandable('source');
  }

  Charge get sourceExpand {
    var value = resourceMap['source'];
    if (value == null)
      return null;
    else
      return Charge.fromMap(value);
  }

  BalanceTransaction.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieving a Balance Transaction](https://stripe.com/docs/api/curl#retrieve_balance_transaction)
  static Future<BalanceTransaction> retrieve(String transactionId) async {
    var dataMap = await StripeService.get(
        [Balance.path, BalanceTransaction.path, transactionId]);
    return BalanceTransaction.fromMap(dataMap);
  }

  /// [Listing balance history](https://stripe.com/docs/api/curl#balance_history)
  /// TODO: implement missing arguments: `available_on` and `created`
  static Future<BalanceTransactionCollection> list(
      {int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap = await StripeService.list(
        [Balance.path, BalanceTransaction.path],
        data: data);
    return BalanceTransactionCollection.fromMap(dataMap);
  }
}

class BalanceTransactionCollection extends ResourceCollection {
  Card getInstanceFromMap(map) => Card.fromMap(map);

  BalanceTransactionCollection.fromMap(Map map) : super.fromMap(map);
}

class Fund {
  Map resourceMap;

  int get amount => resourceMap['amount'];

  String get currency => resourceMap['currency'];

  Fund.fromMap(this.resourceMap);
}

class FeeDetails {
  Map resourceMap;

  int get amount => resourceMap['amount'];

  String get currency => resourceMap['currency'];

  String get type => resourceMap['type'];

  String get application => resourceMap['application'];

  String get description => resourceMap['description'];

  FeeDetails.fromMap(this.resourceMap);
}
