import '../api_resource.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

import 'charge.dart';
import 'customer.dart';
import 'discount.dart';
import 'plan.dart';

/// [Invoices](https://stripe.com/docs/api/curl#invoices)
class Invoice extends ApiResource {
  String get id => resourceMap['id'];

  final String object = 'invoice';

  static var path = 'invoices';

  bool get livemode => resourceMap['livemode'];

  int get amountDue => resourceMap['amount_due'];

  int get attemptCount => resourceMap['attempt_count'];

  bool get attempted => resourceMap['attempted'];

  bool get closed => resourceMap['closed'];

  String get currency => resourceMap['currency'];

  String get customer {
    return this.getIdForExpandable('customer');
  }

  Customer get customerExpand {
    var value = resourceMap['customer'];
    if (value == null)
      return null;
    else
      return Customer.fromMap(value);
  }

  DateTime get date => getDateTimeFromMap('date');

  InvoiceLineItemCollection get lines {
    var value = resourceMap['lines'];
    if (value == null)
      return null;
    else
      return InvoiceLineItemCollection.fromMap(value);
  }

  bool get paid => resourceMap['paid'];

  DateTime get periodEnd => getDateTimeFromMap('period_end');

  DateTime get periodStart => getDateTimeFromMap('period_start');

  int get startingBalance => resourceMap['starting_balance'];

  int get subtotal => resourceMap['subtotal'];

  int get total => resourceMap['total'];

  int get applicationFee => resourceMap['application_fee'];

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

  String get description => resourceMap['description'];

  Discount get discount {
    var value = resourceMap['discount'];
    if (value == null)
      return null;
    else
      return Discount.fromMap(value);
  }

  int get endingBalance => resourceMap['ending_balance'];

  DateTime get nextPaymentAttempt => getDateTimeFromMap('next_payment_attempt');

  String get subscription => resourceMap['subscription'];

  DateTime get webhooksDeliveredAt =>
      getDateTimeFromMap('webhooks_delivered_at');

  Map<String, String> get metadata => resourceMap['metadata'];

  Invoice.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieving an Invoice](https://stripe.com/docs/api/curl#retrieve_invoice)
  static Future<Invoice> retrieve(String invoiceId) async {
    var dataMap = await StripeService.retrieve([Invoice.path, invoiceId]);
    return Invoice.fromMap(dataMap);
  }

  /// [Paying an invoice](https://stripe.com/docs/api/curl#pay_invoice)
  static Future<Invoice> pay(String invoiceId) async {
    var dataMap = await StripeService.post([Invoice.path, invoiceId, 'pay']);
    return Invoice.fromMap(dataMap);
  }

  /// [Retrieving a List of Invoices](https://stripe.com/docs/api/curl#list_customer_invoices)
  /// TODO: implement missing argument: `date`
  static Future<InvoiceCollection> list(
      {String customer,
      int limit,
      String startingAfter,
      String endingBefore}) async {
    var data = {};
    if (customer != null) data['customer'] = customer;
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap = await StripeService.list([Invoice.path], data: data);
    return InvoiceCollection.fromMap(dataMap);
  }

  /// [Retrieving a Customer's Upcoming Invoice](https://stripe.com/docs/api/curl#retrieve_customer_invoice)
  static Future<Invoice> retrieveUpcoming(String customerId,
      {String subscriptionId}) async {
    var data = {};
    data['customer'] = customerId;
    if (subscriptionId != null) data['subscription'] = subscriptionId;
    var dataMap =
        await StripeService.get([Invoice.path, 'upcoming'], data: data);
    return Invoice.fromMap(dataMap);
  }

  /// [Retrieve an invoice's line items](https://stripe.com/docs/api/curl#invoice_lines)
  static Future<InvoiceLineItemCollection> retrieveLineItems(String invoiceId,
      {String customerId,
      int limit,
      String startingAfter,
      String endingBefore,
      String subscriptionId}) async {
    var data = {};
    if (customerId != null) data['customer'] = customerId;
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (subscriptionId != null) data['s'] = subscriptionId;
    if (data == {}) data = null;
    var dataMap = await StripeService.retrieve(
        [Invoice.path, invoiceId, InvoiceLineItem.path]);
    return InvoiceLineItemCollection.fromMap(dataMap);
  }
}

class InvoiceCollection extends ResourceCollection {
  Invoice getInstanceFromMap(map) => Invoice.fromMap(map);

  InvoiceCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Creating an invoice](https://stripe.com/docs/api/curl#create_invoice)
class InvoiceCreation extends ResourceRequest {
  // //@required
  set customer(String customer) => setMap('customer', customer);

  set applicationFee(int applicationFee) =>
      setMap('application_fee', applicationFee);

  set description(String description) => setMap('description', description);

  set metadata(Map metadata) => setMap('metadata', metadata);

  set subscription(String subscription) => setMap('subscription', subscription);

  Future<Invoice> create() async {
    var dataMap = await StripeService.create([Invoice.path], getMap());
    return Invoice.fromMap(dataMap);
  }
}

/// [Updating an invoice](https://stripe.com/docs/api/curl#update_invoice)
class InvoiceUpdate extends ResourceRequest {
  set applicationFee(int applicationFee) =>
      setMap('application_fee', applicationFee);

  set closed(bool closed) => setMap('closed', closed);

  set description(String description) => setMap('description', description);

  set metadata(Map metadata) => setMap('metadata', metadata);

  Future<Invoice> update(String invoiceId) async {
    var dataMap =
        await StripeService.update([Invoice.path, invoiceId], getMap());
    return Invoice.fromMap(dataMap);
  }
}

/// [The invoice_line_item object](https://stripe.com/docs/api/curl#invoice_line_item_object)
class InvoiceLineItem extends Resource {
  String get id => resourceMap['id'];

  final String object = 'line_item';

  static var path = 'lines';

  bool get livemode => resourceMap['livemode'];

  int get amount => resourceMap['amount'];

  String get currency => resourceMap['currency'];

  Period get period {
    var value = resourceMap['period'];
    if (value == null)
      return null;
    else
      return Period.fromMap(value);
  }

  bool get proration => resourceMap['proration'];

  String get type => resourceMap['type'];

  String get description => resourceMap['description'];

  Map<String, String> get metadata => resourceMap['metadata'];

  Plan get plan {
    var value = resourceMap['plan'];
    if (value == null)
      return null;
    else
      return Plan.fromMap(value);
  }

  int get quantity => resourceMap['quantity'];

  InvoiceLineItem.fromMap(Map dataMap) : super.fromMap(dataMap);
}

class InvoiceLineItemCollection extends ResourceCollection {
  InvoiceLineItem getInstanceFromMap(map) => InvoiceLineItem.fromMap(map);

  InvoiceLineItemCollection.fromMap(Map map) : super.fromMap(map);
}

class Period {
  Map resourceMap;

  int get start => resourceMap['start'];

  int get end => resourceMap['end'];

  Period.fromMap(this.resourceMap);
}
