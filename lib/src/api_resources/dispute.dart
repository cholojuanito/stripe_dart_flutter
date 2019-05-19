import '../api_resource.dart';
import '../resource.dart';
import '../service.dart';

import 'balance.dart';
import 'charge.dart';
import 'customer.dart';

/// [Disputes](https://stripe.com/docs/api/curl#disputes)
class Dispute extends ApiResource {
  String get id => resourceMap['id'];

  static var path = 'dispute';

  final String object = 'dispute';

  int get amount => resourceMap['amount'];

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

  DateTime get created => getDateTimeFromMap('created');

  String get currency => resourceMap['currency'];

  Charge get ChargeExpand {
    var value = resourceMap['charge'];
    if (value == null)
      return null;
    else
      return Charge.fromMap(value);
  }

  String get evidence => resourceMap['evidence'];

  DateTime get evidenceDueBy => getDateTimeFromMap('evidence_due_by');

  bool get isChargeRefundable => resourceMap['is_charge_refundable'];

  bool get livemode => resourceMap['livemode'];

  Map<String, String> get metadata => resourceMap['metadata'];

  String get reason => resourceMap['reason'];

  String get status => resourceMap['status'];

  bool get isProtected => resourceMap['is_protected'];

  Dispute.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Closing a dispute](https://stripe.com/docs/api/curl#close_dispute)
  static Future close(String chargeId) =>
      postResource([Charge.path, chargeId, Dispute.path, 'close']);

  /// [Retrieving a Dispute]
  /// https://stripe.com/docs/api/disputes/retrieve
  static Future<BalanceTransaction> retrieve(String transactionId) async {
    var dataMap = await getResource(
        [Balance.path, BalanceTransaction.path, transactionId]);
    return BalanceTransaction.fromMap(dataMap);
  }

  /// [List All Balance History]
  /// https://stripe.com/docs/api/disputes/list
  /// TODO: Implement Created
  static Future<BalanceTransactionCollection> list({
    int limit,
    String startingAfter,
    String endingBefore,
  }) async {
    var data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap =
        await listResource([Balance.path, BalanceTransaction.path], data: data);
    return BalanceTransactionCollection.fromMap(dataMap);
  }
}

/// [Updating a dispute](https://stripe.com/docs/api/curl#update_dispute)
class DisputeUpdate extends ResourceRequest {
  set evidence(String evidence) => setMap('evidence', evidence);

  Future<Dispute> update(String disputeID) async {
    var dataMap =
        await updateResource([Dispute.path, disputeID, Dispute.path], getMap());
    return Dispute.fromMap(dataMap);
  }
}
