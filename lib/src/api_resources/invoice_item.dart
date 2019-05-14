import '../api_resource.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

import 'customer.dart';
import 'invoice.dart';

/// [Invoice items](https://stripe.com/docs/api/curl#invoiceitems)
class InvoiceItem extends ApiResource {
  String get id => resourceMap['id'];

  final String object = 'invoiceitem';

  static var path = 'invoiceitems';

  bool get livemode => resourceMap['livemode'];

  int get amount => resourceMap['amount'];

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

  bool get proration => resourceMap['proration'];

  String get description => resourceMap['description'];

  String get invoice {
    return this.getIdForExpandable('invoice');
  }

  Invoice get invoiceExpand {
    var value = resourceMap['invoice'];
    if (value == null)
      return null;
    else
      return Invoice.fromMap(value);
  }

  Map<String, String> get metadata => resourceMap['metadata'];

  String get subscription => resourceMap['subscription'];

  InvoiceItem.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieving an Invoice Item](https://stripe.com/docs/api/curl#retrieve_invoiceitem)
  static Future<InvoiceItem> retrieve(String invoiceItemId,
      {final Map data}) async {
    var dataMap = await StripeService.retrieve(
        [InvoiceItem.path, invoiceItemId],
        data: data);
    return InvoiceItem.fromMap(dataMap);
  }

  /// [List all Invoice Items](https://stripe.com/docs/api/curl#list_invoiceitems)
  /// TODO: implement missing argument: `created`
  static Future<InvoiceItemCollection> list(
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
    var dataMap = await StripeService.list([InvoiceItem.path], data: data);
    return InvoiceItemCollection.fromMap(dataMap);
  }

  /// [Deleting an Invoice Item](https://stripe.com/docs/api/curl#delete_invoiceitem)
  static Future<Map> delete(String invoiceItemId) =>
      StripeService.delete([InvoiceItem.path, invoiceItemId]);
}

class InvoiceItemCollection extends ResourceCollection {
  InvoiceItem getInstanceFromMap(map) => InvoiceItem.fromMap(map);

  InvoiceItemCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Creating an Invoice Item](https://stripe.com/docs/api/curl#create_invoiceitem)
class InvoiceItemCreation extends ResourceRequest {
  InvoiceItemCreation() {
    setMap('object', 'InvoiceItem');
    setRequiredFields('customer');
    setRequiredFields('amount');
    setRequiredFields('currency');
  }

  // //@required
  set customer(String customer) => setMap('customer', customer);

  // //@required
  set amount(int amount) => setMap('amount', amount);

  // //@required
  set currency(String currency) => setMap('currency', currency);

  set invoice(String invoice) => setMap('invoice', invoice);

  set subscription(String subscription) => setMap('subscription', subscription);

  set description(String description) => setMap('description', description);

  set metadata(Map metadata) => setMap('metadata', metadata);

  Future<InvoiceItem> create() async {
    var dataMap = await StripeService.create([InvoiceItem.path], getMap());
    return InvoiceItem.fromMap(dataMap);
  }
}

/// [Updating an Invoice Item](https://stripe.com/docs/api/curl#update_invoiceitem)
class InvoiceItemUpdate extends ResourceRequest {
  set amount(int amount) => setMap('amount', amount);

  set description(String description) => setMap('description', description);

  set metadata(Map metadata) => setMap('metadata', metadata);

  Future<InvoiceItem> update(String invoiceItemId) async {
    var dataMap =
        await StripeService.update([InvoiceItem.path, invoiceItemId], getMap());
    return InvoiceItem.fromMap(dataMap);
  }
}
