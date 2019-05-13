import '../api_resource.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

import 'balance.dart';
import 'transfer.dart';

/// [Transfer Reversals](https://stripe.com/docs/api#transfer_reversals)
class TransferReversal extends ApiResource {
  String get id => resourceMap['id'];

  final String object = 'transfer_reversal';

  static var path = 'reversals';

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
      return  BalanceTransaction.fromMap(value);
  }

  Map get metadata => resourceMap['metadata'];

  String get transfer {
    return this.getIdForExpandable('transfer');
  }

  Transfer get transferExpand {
    var value = resourceMap['transfer'];
    if (value == null)
      return null;
    else
      return  Transfer.fromMap(value);
  }

  TransferReversal.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve a reversal](https://stripe.com/docs/api#retrieve_transfer_reversal)
  static Future<Transfer> retrieve(String transferId, String reversalId,
      {final Map data}) async {
    var dataMap = await StripeService.retrieve(
        [Transfer.path, transferId, TransferReversal.path, reversalId],
        data: data);
    return  Transfer.fromMap(dataMap);
  }

  /// [List all reversals](https://stripe.com/docs/api#list_transfer_reversals)
  static Future<TransferReversalCollection> list(String transferId,
      {int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap = await StripeService.list(
        [Transfer.path, transferId, TransferReversal.path],
        data: data);
    return  TransferReversalCollection.fromMap(dataMap);
  }
}

class TransferReversalCollection extends ResourceCollection {
  TransferReversal getInstanceFromMap(map) =>  TransferReversal.fromMap(map);

  TransferReversalCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Create a transfer reversal](https://stripe.com/docs/api#create_transfer_reversal)
class TransferReversalCreation extends ResourceRequest {
  set amount(int amount) => setMap('amount', amount);

  set refundApplicationFee(bool refundApplicationFee) =>
      setMap('refund_application_fee', refundApplicationFee);

  set metadata(Map metadata) => setMap('metadata', metadata);

  set description(String description) => setMap('description', description);

  Future<TransferReversal> create(String transferId) async {
    var dataMap = await StripeService.create(
        [Transfer.path, transferId, TransferReversal.path], getMap());
    return  TransferReversal.fromMap(dataMap);
  }
}

/// [Update a reversal](https://stripe.com/docs/api#update_transfer_reversal)
class TransferReversalUpdate extends ResourceRequest {
  set metadata(Map metadata) => setMap('metadata', metadata);

  set description(String description) => setMap('description', description);

  Future<TransferReversal> update(String transferId, String reversalId) async {
    var dataMap = await StripeService.create(
        [Transfer.path, transferId, TransferReversal.path, reversalId],
        getMap());
    return  TransferReversal.fromMap(dataMap);
  }
}
