import '../api_resource.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

import 'balance.dart';
import 'charge.dart';

/// [Refunds](https://stripe.com/docs/api#refunds)
class Refund extends ApiResource {
  String get id => resourceMap['id'];

  final String object = 'refund';

  static var path = 'refunds';

  int get amount => resourceMap['amount'];

  DateTime get created => getDateTimeFromMap('created');

  String get currency => resourceMap['currency'];

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

  String get charge => resourceMap['charge'];

  Map<String, String> get metadata => resourceMap['metadata'];

  String get reason => resourceMap['reason'];

  String get receiptNumber => resourceMap['receipt_number'];

  String get description => resourceMap['description'];

  Refund.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve a refund](https://stripe.com/docs/api#retrieve_refund)
  static Future<Refund> retrieve(String chargeId, String refundId,
      {final Map data}) async {
    var dataMap = await retrieveResource(
        [Charge.path, chargeId, Refund.path, refundId],
        data: data);
    return Refund.fromMap(dataMap);
  }

  /// [List all refunds](https://stripe.com/docs/api#list_refunds)
  static Future<RefundCollection> list(String chargeId,
      {int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (data == {}) data = null;
    var dataMap =
        await listResource([Charge.path, chargeId, Refund.path], data: data);
    return RefundCollection.fromMap(dataMap);
  }
}

/// [Create a refund](https://stripe.com/docs/api#create_refund)
class RefundCreation extends ResourceRequest {
  set amount(int amount) => setMap('amount', amount);

  set refundApplicationFee(bool refundApplicationFee) =>
      setMap('refund_application_fee', refundApplicationFee.toString());

  set reason(String reason) => setMap('reason', reason);

  set metadata(Map metadata) => setMap('metadata', metadata);

  Future<Refund> create(String chargeId) async {
    var dataMap =
        await createResource([Charge.path, chargeId, Refund.path], getMap());
    return Refund.fromMap(dataMap);
  }
}

/// [Update a refund](https://stripe.com/docs/api#update_refund)
class RefundUpdate extends ResourceRequest {
  set metadata(Map metadata) => setMap('metadata', metadata);

  Future<Refund> update(String chargeId, String refundId) async {
    var dataMap = await updateResource(
        [Charge.path, chargeId, Refund.path, refundId], getMap());
    return Refund.fromMap(dataMap);
  }
}

class RefundCollection extends ResourceCollection {
  Refund getInstanceFromMap(map) => Refund.fromMap(map);

  RefundCollection.fromMap(Map map) : super.fromMap(map);
}
