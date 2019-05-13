import '../api_resource.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

import '../resources/bank_account.dart';

import 'account.dart';
import 'balance.dart';
import 'card.dart';
import 'charge.dart';
import 'transfer_reversal.dart';

/// [Transfers](https://stripe.com/docs/api#transfers)
class Transfer extends ApiResource {
  String get id => resourceMap['id'];

  final String object = 'transfer';

  static var path = 'transfers';

  bool get livemode => resourceMap['livemode'];

  int get amount => resourceMap['amount'];

  DateTime get created => getDateTimeFromMap('created');

  String get currency => resourceMap['currency'];

  DateTime get date => getDateTimeFromMap('date');

  TransferReversalCollection get reversals {
    var value = resourceMap['reversals'];
    if (value == null)
      return null;
    else
      return  TransferReversalCollection.fromMap(value);
  }

  bool get reversed => resourceMap['reversed'];

  String get status => resourceMap['status'];

  String get type => resourceMap['type'];

  int get amountReversed => resourceMap['amount_reversed'];

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

  String get description => resourceMap['description'];

  String get failureCode => resourceMap['failure_code'];

  String get failureMessage => resourceMap['failure_message'];

  Map get metadata => resourceMap['metadata'];

  String get applicationFee => resourceMap['application_fee'];

  String get destination {
    return this.getIdForExpandable('destination');
  }

  dynamic get destinationExpand {
    var value = resourceMap['destination'];
    if (!(value is Map) || !(value.containsKey('object'))) return null;
    String object = value['object'];
    switch (object) {
      case 'card':
        return  Card.fromMap(value);
      case 'account':
        return  Account.fromMap(value);
      case 'bank_account':
        return  BankAccount.fromMap(value);
      default:
        return null;
    }
  }

  String get destinationPayment {
    return this.getIdForExpandable('destination_payment');
  }

  Charge get destinationPaymentExpand {
    var value = resourceMap['destination_payment'];
    if (value == null)
      return null;
    else
      return  Charge.fromMap(value);
  }

  String get sourceTransaction {
    return this.getIdForExpandable('source_transaction');
  }

  dynamic get sourceTransactionExpand {
    var value = resourceMap['source_transaction'];
    if (!(value is Map) || !(value.containsKey('object'))) return null;
    String object = value['object'];
    switch (object) {
      case 'charge':
        return  Charge.fromMap(value);
      default:
        return null;
    }
  }

  String get statementDescriptor => resourceMap['statement_descriptor'];

  Transfer.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve a transfer](https://stripe.com/docs/api#retrieve_transfer)
  static Future<Transfer> retrieve(String transferId, {final Map data}) async {
    var dataMap =
        await StripeService.retrieve([Transfer.path, transferId], data: data);
    return  Transfer.fromMap(dataMap);
  }

  /// [Canceling a Transfer](https://stripe.com/docs/api/curl#cancel_transfer)
  static Future<Transfer> cancel(String transferId) async {
    var dataMap =
        await StripeService.post([Transfer.path, transferId, 'cancel']);
    return  Transfer.fromMap(dataMap);
  }

  /// [List all transfers](https://stripe.com/docs/api#list_transfers)
  static Future<TransferCollection> list(
      {var created,
      var date,
      int limit,
      String startingAfter,
      String endingBefore,
      String recipient,
      String status}) async {
    var data = {};
    if (created != null) data['created'] = created;
    if (date != null) data['date'] = date;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (limit != null) data['limit'] = limit;
    if (recipient != null) data['recipient'] = recipient;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (status != null) data['status'] = status;
    if (data == {}) data = null;
    var dataMap = await StripeService.list([Transfer.path], data: data);
    return  TransferCollection.fromMap(dataMap);
  }
}

class TransferCollection extends ResourceCollection {
  Transfer getInstanceFromMap(map) =>  Transfer.fromMap(map);

  TransferCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Create a transfer](https://stripe.com/docs/api#create_transfer)
class TransferCreation extends ResourceRequest {
  // //@required
  set amount(int amount) => setMap('amount', amount);

  // //@required
  set currency(String currency) => setMap('currency', currency);

  // //@required
  set destination(String destination) => setMap('destination', destination);

  set sourceTransaction(String sourceTransaction) =>
      setMap('source_transaction', sourceTransaction);

  set description(String description) => setMap('description', description);

  set statementDescriptor(String statementDescriptor) =>
      setMap('statement_descriptor', statementDescriptor);

  set metadata(Map metadata) => setMap('metadata', metadata);

  Future<Transfer> create() async {
    var dataMap = await StripeService.create([Transfer.path], getMap());
    return  Transfer.fromMap(dataMap);
  }
}

/// [Update a transfer](https://stripe.com/docs/api#update_transfer)
class TransferUpdate extends ResourceRequest {
  set description(String description) => setMap('description', description);

  set metadata(Map metadata) => setMap('metadata', metadata);

  Future<Transfer> update(String transferId) async {
    var dataMap =
        await StripeService.create([Transfer.path, transferId], getMap());
    return  Transfer.fromMap(dataMap);
  }
}
