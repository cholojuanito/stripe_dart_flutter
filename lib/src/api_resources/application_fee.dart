import '../resource_collection.dart';
import '../service.dart';
import 'account.dart';
import 'balance.dart';
import 'charge.dart';
import 'refund.dart';

import '../api_resource.dart';

/// [Application Fees](https://stripe.com/docs/api/curl#application_fees)
class ApplicationFee extends ApiResource {
  String get id => resourceMap['id'];

  final String object = 'application_fee';

  static var path = 'application_fees';

  bool get livemode => resourceMap['livemode'];

  String get account {
    return this.getIdForExpandable('account');
  }

  Account get accountExpand {
    var value = resourceMap['account'];
    if (value == null)
      return null;
    else
      return Account.fromMap(value);
  }

  int get amount => resourceMap['amount'];

  String get application => resourceMap['application'];

  String get balanceTransaction {
    return this.getIdForExpandable('balance_transaction');
  }

  BalanceTransaction get balanceTransactionExpand {
    var value = resourceMap['balance_transaction'];
    if (value == null)
      return null;
    else
      return BalanceTransaction.fromMap(value);
  }

  String get charge {
    return this.getIdForExpandable('charge');
  }

  Charge get chargeExpand {
    var value = resourceMap['charge'];
    if (value == null)
      return null;
    else
      return Charge.fromMap(value);
  }

  DateTime get created => getDateTimeFromMap('created');

  String get currency => resourceMap['currency'];

  bool get refunded => resourceMap['refunded'];

  List<Refund> get refunds {
    List value = resourceMap['refunds'];
    assert(value != null);
    return value
        .map((refund) => Refund.fromMap(refund))
        .toList(growable: false);
  }

  int get amountRefunded => resourceMap['amount_refunded'];

  ApplicationFee.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieving an Application Fee](https://stripe.com/docs/api/curl#retrieve_application_fee)
  static Future<ApplicationFee> retrieve(String applicationFeeId) async {
    var dataMap =
        await StripeService.get([ApplicationFee.path, applicationFeeId]);
    return ApplicationFee.fromMap(dataMap);
  }

  /// [Refunding an Application Fee](https://stripe.com/docs/api/curl#refund_application_fee)
  static Future<ApplicationFee> refund(String applicationFeeId,
      {int amount}) async {
    var data = {};
    if (amount != null) data['amount'] = amount;
    if (data == {}) data = null;
    var dataMap = await StripeService.post(
        [ApplicationFee.path, applicationFeeId, 'refund'],
        data: data);
    return ApplicationFee.fromMap(dataMap);
  }

  /// [List all Application Fees](https://stripe.com/docs/api/curl#list_application_fees)
  /// TODO: implement missing argument: `created`
  static Future<ApplicationFeeCollection> list(
      {String charge,
      int limit,
      String startingAfter,
      String endingBefore}) async {
    var data = {};
    if (charge != null) data['charge'] = charge;
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap = await StripeService.list([ApplicationFee.path], data: data);
    return ApplicationFeeCollection.fromMap(dataMap);
  }
}

class ApplicationFeeCollection extends ResourceCollection {
  ApplicationFee getInstanceFromMap(map) => ApplicationFee.fromMap(map);

  ApplicationFeeCollection.fromMap(Map map) : super.fromMap(map);
}
