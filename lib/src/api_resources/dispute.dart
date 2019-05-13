import '../api_resource.dart';
import '../resource.dart';
import '../service.dart';

import 'balance.dart';
import 'charge.dart';
import 'customer.dart';

/// [Disputes](https://stripe.com/docs/api/curl#disputes)
class Dispute extends ApiResource {
  final String object = 'dispute';

  static var path = 'dispute';

  bool get livemode => resourceMap['livemode'];

  int get amount => resourceMap['amount'];

  String get charge {
    return this.getIdForExpandable('charge');
  }

  Charge get ChargeExpand {
    var value = resourceMap['charge'];
    if (value == null)
      return null;
    else
      return  Charge.fromMap(value);
  }

  DateTime get created => getDateTimeFromMap('created');

  String get currency => resourceMap['currency'];

  String get reason => resourceMap['reason'];

  String get status => resourceMap['status'];

  String get balanceTransaction {
    return this.getIdForExpandable('balance_transaction');
  }

  BalanceTransaction get balanceTransactionExpand {
    var value = resourceMap['balance_transaction'];
    if (value == null)
      return null;
    else
      return  BalanceTransaction.fromMap(value);
  }

  String get evidence => resourceMap['evidence'];

  DateTime get evidenceDueBy => getDateTimeFromMap('evidence_due_by');

  bool get isProtected => resourceMap['is_protected'];

  Dispute.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Closing a dispute](https://stripe.com/docs/api/curl#close_dispute)
  static Future close(String chargeId) =>
      StripeService.post([Charge.path, chargeId, Dispute.path, 'close']);
}

/// [Updating a dispute](https://stripe.com/docs/api/curl#update_dispute)
class DisputeUpdate extends ResourceRequest {
  set evidence(String evidence) => setMap('evidence', evidence);

  Future<Customer> update(String chargeId) async {
    var dataMap = await StripeService.update(
        [Charge.path, chargeId, Dispute.path], getMap());
    return  Customer.fromMap(dataMap);
  }
}
