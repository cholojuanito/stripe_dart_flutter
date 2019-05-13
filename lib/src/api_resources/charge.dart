import '../api_resource.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

import '../resources/shipping.dart';

import 'balance.dart';
import 'card.dart';
import 'customer.dart';
import 'dispute.dart';
import 'invoice.dart';
import 'refund.dart';

/// [Charges](https://stripe.com/docs/api#charges)
class Charge extends ApiResource {
  String get id => resourceMap['id'];

  final String object = 'charge';

  static var path = 'charges';

  bool get livemode => resourceMap['livemode'];

  int get amount => resourceMap['amount'];

  bool get captured => resourceMap['captured'];

  DateTime get created => getDateTimeFromMap('created');

  String get currency => resourceMap['currency'];

  bool get paid => resourceMap['paid'];

  bool get refunded => resourceMap['refunded'];

  RefundCollection get refunds {
    Map value = resourceMap['refunds'];
    assert(value != null);
    return new RefundCollection.fromMap(value);
  }

  Card get source {
    var value = resourceMap['source'];
    if (value == null)
      return null;
    else
      return new Card.fromMap(value);
  }

  String get status => resourceMap['status'];

  int get amountRefunded => resourceMap['amountRefunded'];

  String get balanceTransaction {
    return this.getIdForExpandable('balance_transaction');
  }

  BalanceTransaction get balanceTransactionExpand {
    var value = resourceMap['balance_transaction'];
    if (value == null)
      return null;
    else
      return new BalanceTransaction.fromMap(value);
  }

  String get customer {
    return this.getIdForExpandable('customer');
  }

  Customer get customerExpand {
    var value = resourceMap['customer'];
    if (value == null)
      return null;
    else
      return new Customer.fromMap(value);
  }

  String get description => resourceMap['description'];

  Dispute get dispute {
    var value = resourceMap['dispute'];
    if (value == null)
      return null;
    else
      return new Dispute.fromMap(value);
  }

  String get failureCode => resourceMap['failureCode'];

  String get failureMessage => resourceMap['failureMessage'];

  String get invoice {
    return this.getIdForExpandable('invoice');
  }

  Invoice get invoiceExpand {
    var value = resourceMap['invoice'];
    if (value == null)
      return null;
    else
      return new Invoice.fromMap(value);
  }

  Map<String, String> get metadata => resourceMap['metadata'];

  String get receiptEmail => resourceMap['receipt_email'];

  String get receiptNumber => resourceMap['receipt_number'];

  String get applicationFee => resourceMap['application_fee'];

  String get destination => resourceMap['destination'];

  Map<String, String> get fraudDetails => resourceMap['fraud_details'];

  Shipping get shipping {
    var value = resourceMap['shipping'];
    if (value == null)
      return null;
    else
      return new Shipping.fromMap(value);
  }

  String get statement_descriptor => resourceMap['statement_descriptor'];

  Charge.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve a charge](https://stripe.com/docs/api#retrieve_charge)
  static Future<Charge> retrieve(String chargeId, {final Map data}) async {
    var dataMap =
        await StripeService.retrieve([Charge.path, chargeId], data: data);
    return new Charge.fromMap(dataMap);
  }

  /// [Capture a charge](https://stripe.com/docs/api#capture_charge)
  static Future<Charge> capture(String chargeId,
      {int amount,
      String applicationFee,
      String receiptEmail,
      String statementDescriptor}) async {
    var data = {};
    if (amount != null) data['amount'] = amount;
    if (applicationFee != null) data['application_fee'] = applicationFee;
    if (receiptEmail != null) data['receipt_email'] = receiptEmail;
    if (statementDescriptor != null)
      data['statement_descriptor'] = statementDescriptor;
    var dataMap = await StripeService.post([Charge.path, chargeId, 'capture'],
        data: data);
    return new Charge.fromMap(dataMap);
  }

  /// [List all Charges](https://stripe.com/docs/api#list_charges)
  static Future<ChargeCollection> list(
      {var created,
      String customer,
      int limit,
      String startingAfter,
      String endingBefore}) async {
    var data = {};
    if (created != null) data['created'] = created;
    if (customer != null) data['customer'] = customer;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    var dataMap = await StripeService.list([Charge.path], data: data);
    return new ChargeCollection.fromMap(dataMap);
  }
}

class ChargeCollection extends ResourceCollection {
  Charge getInstanceFromMap(map) => new Charge.fromMap(map);

  ChargeCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Create a charge](https://stripe.com/docs/api#create_charge)
class ChargeCreation extends ResourceRequest {
  // //@required
  set amount(int amount) => setMap('amount', amount);

  // //@required
  set currency(String currency) => setMap('currency', currency);

  set customer(String customer) => setMap('customer', customer);

  set sourceToken(String sourceToken) => setMap('source', sourceToken);

  set source(CardCreation source) => setMap('source', source);

  set description(String description) => setMap('description', description);

  set metadata(Map metadata) => setMap('metadata', metadata);

  set capture(bool capture) => setMap('capture', capture.toString());

  set statementDescriptor(String statementDescriptor) =>
      setMap('statement_descriptor', statementDescriptor);

  set receiptEmail(String receiptEmail) =>
      setMap('receipt_email', receiptEmail);

  set destination(int destination) => setMap('destination', destination);

  set applicationFee(int applicationFee) =>
      setMap('application_fee', applicationFee);

  set shipping(int shipping) => setMap('shipping', shipping);

  Future<Charge> create({String idempotencyKey}) async {
    var dataMap = await StripeService.create([Charge.path], getMap(),
        idempotencyKey: idempotencyKey);
    return new Charge.fromMap(dataMap);
  }
}

/// [Update a charge](https://stripe.com/docs/api#update_charge)
class ChargeUpdate extends ResourceRequest {
  set description(String description) => setMap('description', description);

  set metadata(Map metadata) => setMap('metadata', metadata);

  set receiptEmail(Map receiptEmail) => setMap('receipt_email', receiptEmail);

  set fraudDetails(Map fraudDetails) => setMap('fraud_details', fraudDetails);

  Future<Charge> update(String chargeId) async {
    var dataMap = await StripeService.update([Charge.path, chargeId], getMap());
    return new Charge.fromMap(dataMap);
  }
}
