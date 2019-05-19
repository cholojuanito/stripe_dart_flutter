import '../api_resource.dart';
import '../exceptions.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

import '../resources/address.dart';
import '../resources/shipping.dart';

import 'card.dart';
import 'discount.dart';
import 'subscription.dart';

/// [Customers]
/// https://stripe.com/docs/api/customers/object
/// [Customer] objects allow you to perform recurring charges, and to track multiple charges, that are associated with the same customer. The API allows you to create, delete, and update your customers.
/// You can retrieve individual customers as well as a list of all your customers.
class Customer extends ApiResource {
  static String path = 'customers';

  final String object = 'customer';

  // Attributes

  /// The id either given by Stripe or created by your program
  String get id => resourceMap['id'];

  /// Current balance, if any, being stored on the customer’s account.
  /// If negative, the customer has credit to apply to the next invoice.
  /// If positive, the customer has an amount owed that will be added to the next invoice.
  /// The balance does not refer to any unpaid invoices; it solely takes into account amounts that have yet to be successfully applied to any invoice.
  /// This balance is only taken into account as invoices are finalized.
  /// Note that the balance does not include unpaid invoices.
  int get accountBalance => resourceMap['account_balance'];

  /// The customer’s address.
  Address get address {
    var value = resourceMap['address'];
    if (value == null)
      return null;
    else
      return Address.fromMap(value);
  }

  /// Time at which the object was created. Measured in seconds since the Unix epoch.
  DateTime get created => getDateTimeFromMap('created');

  /// Three-letter ISO code for the currency the customer can be charged in for recurring billing purposes.
  /// * See https://stripe.com/docs/currencies for currency options
  String get currency => resourceMap['currency'];

  /// Id of the default payment source for the customer.
  /// * Expandable
  String get defaultSource => this.getIdForExpandable('default_source');

  Card get defaultSourceExpand {
    var value = resourceMap['default_source'];
    if (value == null)
      return null;
    else
      return Card.fromMap(value);
  }

  /// When the customer’s latest invoice is billed by charging automatically, delinquent is true if the invoice’s latest charge is failed.
  ///
  /// When the customer’s latest invoice is billed by sending an invoice, delinquent is true if the invoice is not paid by its due date.
  bool get delinquent => resourceMap['delinquent'];

  /// An arbitrary string attached to the object. Often useful for displaying to users.
  String get description => resourceMap['description'];

  /// Describes the current discount active on the customer's account, if there is one.
  Discount get discount {
    var value = resourceMap['discount'];
    if (value == null)
      return null;
    else
      return Discount.fromMap(value);
  }

  /// The customer’s email address.
  String get email => resourceMap['email'];

  /// The prefix for the customer used to generate unique invoice numbers.
  String get invoicePrefix => resourceMap['invoicePrefix'];

  /// The customer’s default invoice settings.
  // TODO implement InvoiceSettings

  /// Has the value true if the object exists in live mode or the value false if the object exists in test mode.
  bool get livemode => resourceMap['livemode'];

  /// Set of key-value pairs that you can attach to an object.
  /// This can be useful for storing additional information about the object in a structured format.
  Map<String, String> get metadata => resourceMap['metadata'];

  /// The customer’s full name or business name.
  String get name => resourceMap['name'];

  /// The customer’s phone number.
  String get phone => resourceMap['phone'];

  /// The customer’s preferred locales (languages), ordered by preference.
  List<String> get preferredLocales => resourceMap['preferred_locales'];

  /// Mailing and shipping address for the customer. Appears on invoices emailed to this customer.
  Shipping get shipping {
    var value = resourceMap['shipping'];
    if (value == null)
      return null;
    else
      return Shipping.fromMap(value);
  }

  /// The customer’s payment sources, if any.
  CardCollection get sources {
    var value = resourceMap['sources'];
    if (value == null)
      return null;
    else
      return CardCollection.fromMap(value);
  }

  SubscriptionCollection get subscriptions {
    var value = resourceMap['subscriptions'];
    if (value == null)
      return null;
    else
      return SubscriptionCollection.fromMap(value);
  }

  /// Describes the customer’s tax exemption status.
  /// One of:
  /// *none
  /// * exempt
  /// * reverse.
  /// When set to reverse, invoice and receipt PDFs include the text “Reverse charge”.
  String get taxExempt => resourceMap['tax_exempt'];

  /// The customer’s tax IDs.
  ///
  /// Attributes are:
  ///
  /// * Object. taxIds['object']
  /// String representing the object’s type.
  /// Objects of the same type share the same value. **Always a List.**
  ///
  /// * Data.  taxIds['data']
  /// This is the List of CustomerTaxId objects
  ///
  ///  * Create it like this:
  /// `CustomerTaxIdCollection custTaxIds = CustomerTaxIdCollection.fromMap(taxIds['data'].asMap);`
  ///
  /// * Has More. taxIds['has_more']
  /// True if this list has another page of items after this one that can be fetched.
  ///
  /// * URL. taxIds['url]
  /// The URL where this list can be accessed.
  CustomerTaxIdCollection get taxIds {
    Map value = resourceMap['tax_ids'];
    assert(value != null);
    return CustomerTaxIdCollection.fromMap(value);
  }

  Customer.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve a Customer]
  /// https://stripe.com/docs/api/customers/retrieve
  static Future<Customer> retrieve(String customerId, {final Map data}) async {
    var dataMap =
        await retrieveResource([Customer.path, customerId], data: data);
    return Customer.fromMap(dataMap);
  }

  /// [List all Customers]
  /// https://stripe.com/docs/api/customers/list
  static Future<CustomerCollection> list(
      {var created,
      int limit,
      String email,
      String startingAfter,
      String endingBefore}) async {
    var data = {};
    if (created != null) data['created'] = created;
    if (limit != null) data['limit'] = limit;
    if (email != null) data['email'] = email;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap = await listResource([Customer.path], data: data);
    return CustomerCollection.fromMap(dataMap);
  }

  /// [Delete a Customer]
  /// https://stripe.com/docs/api/customers/delete
  ///
  /// Permanently deletes a customer. It cannot be undone.
  /// Also immediately cancels any active subscriptions on the customer.
  ///
  /// Unlike other objects, **deleted customers can still be retrieved through the API**, in order to be able to track the history of customers while still removing their credit card details
  ///  and preventing any further operations to be performed (such as adding a new subscription).
  static Future<Map> delete(String customerId) =>
      deleteResource([Customer.path, customerId]);
}

class CustomerCollection extends ResourceCollection {
  Customer getInstanceFromMap(map) => Customer.fromMap(map);

  CustomerCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Create a Customer]
/// https://stripe.com/docs/api/customers/create
class CustomerCreation extends ResourceRequest {
  set accountBalance(int accountBalance) =>
      setMap('account_balance', accountBalance);

  set address(Address address) => setMap('address', address.toMap());

  set coupon(String coupon) => setMap('coupon', coupon);

  set description(String description) => setMap('description', description);

  set email(String email) => setMap('email', email);

  set invoicePrefix(String invoicePrefix) =>
      setMap('invoice_prefix', invoicePrefix);

// TODO implement InvoiceSettings first
  // set invoiceSettings() => setMap('invoice_settings', value);

  set metadata(Map metadata) => setMap('metadata', metadata);

  set name(String name) => setMap('name', name);

// TODO implement PaymentMethod first
  // set paymentMethod() => setMap('payment_method', value);

  set phone(String phone) => setMap('phone', phone);

  set preferredLocales(List<String> locales) =>
      setMap('preferred_locales', locales);

  set shipping(Shipping shippingInfo) =>
      setMap('shipping', shippingInfo.toMap());

  /// Passing a source this way will create a new source object, make it the customer default source, and delete the old customer default if one exists.
  ///
  /// If you want to add an additional source, instead use the card creation API to add the card and then the customer update API to set it as the default.
  ///
  /// Whenever you attach a card to a customer, Stripe will automatically validate the card.
  set source(SourceCreation source) => setMap('source', source);

  set taxExempt(String exemption) => setMap('tax_exempt', exemption);

  set taxIdData(List<CustomerTaxIdCreation> taxIds) {
    Map taxIdMap;
  }

  // ! seems to be deprecated
  set plan(String plan) => setMap('plan', plan);

// ! deprecated
  set quantity(int quantity) => setMap('quantity', quantity);

  // ! deprecated
  set trialEnd(int trialEnd) => setMap('trial_end', trialEnd);

  Future<Customer> create({String idempotencyKey}) async {
    var dataMap = await createResource([Customer.path], getMap(),
        idempotencyKey: idempotencyKey);
    return Customer.fromMap(dataMap);
  }
}

/// [Update a customer](https://stripe.com/docs/api#update_customer)
class CustomerUpdate extends ResourceRequest {
  CustomerUpdate() {
    setRequiredFields('customer');
  }

  set customer(Customer customer) => setMap('customer', customer.toMap());

  set accountBalance(int accountBalance) =>
      setMap('account_balance', accountBalance);

  set address(Address address) => setMap('address', address.toMap());

  set coupon(String coupon) => setMap('coupon', coupon);

  set defaultSource(String sourceId) => setMap('default_source', sourceId);

  set description(String description) => setMap('description', description);

  set email(String email) => setMap('email', email);

  set invoicePrefix(String prefix) => setMap('invoice_prefix', prefix);

  // TODO implement InvoiceSettings
  // set invoiceSettings() => setMap('invoice_settings', value);

  set metadata(Map metadata) => setMap('metadata', metadata);

  set name(String name) => setMap('name', name);

  set phone(String phone) => setMap('phone', phone);

  set preferredLocales(List<String> locales) =>
      setMap('preferred_locales', locales);

  set shipping(Shipping shippingInfo) =>
      setMap('shipping', shippingInfo.toMap());

// ! Not sure about this one
  set sourceToken(String sourceToken) => setMap('source', sourceToken);

  set source(SourceCreation source) => setMap('source', source);

  set taxExempt(String exemption) => setMap('tax_exempt', exemption);

  Future<Customer> update(String customerId) async {
    var dataMap = await updateResource([Customer.path, customerId], getMap());
    return Customer.fromMap(dataMap);
  }
}

/// [Customer Tax Id]
/// https://stripe.com/docs/api/customer_tax_ids/object
///
/// You can add one or multiple tax IDs to a customer.
/// A customer's tax IDs are displayed on invoices and credit notes issued for the customer.
class CustomerTaxId extends ApiResource {
  static String path = 'tax_ids';

  final String object = 'tax_id';

  /// Two-letter ISO code representing the country of the tax ID.
  String get country => resourceMap['country'];

  /// Time at which the object was created. Measured in seconds since the Unix epoch.
  DateTime get created => getDateTimeFromMap('created');

  /// Id of the customer this charge is for if one exists.
  /// * Expandable
  String get customer => this.getIdForExpandable('customer');

  Customer get customerExpand {
    var value = resourceMap['customer'];
    if (value == null)
      return null;
    else
      return Customer.fromMap(value);
  }

  /// Has the value true if the object exists in live mode or
  /// the value false if the object exists in test mode.
  bool get livemode => resourceMap['livemode'];

  /// Type of the tax Id.
  /// One of:
  /// * eu_vat
  /// * nz_gst
  /// * au_abn
  /// * unknown
  String get type => resourceMap['type'];

  /// Value of the tax ID.
  String get value => resourceMap['value'];

  /// Tax ID verification information.
  ///
  /// Attributes are:
  ///
  /// * Verification status. verification['status']
  ///
  /// * Verified address.
  /// verification['verified_address']
  ///
  /// * Verified name.
  /// verification['verified_name']
  ///
  /// Verification status will be one of:
  /// * pending
  /// * unavailable
  /// * unverified
  /// * verified
  Map<String, String> get verification => resourceMap['verification'];

  CustomerTaxId.fromMap(dataMap) : super.fromMap(dataMap);

  /// [Retrieve a Customer's Tax Id]
  /// https://stripe.com/docs/api/customer_tax_ids/retrieve
  static Future<CustomerTaxId> retrieve(String taxId, String customerId,
      {final Map data}) async {
    var dataMap = await retrieveResource(
        [Customer.path, customerId, CustomerTaxId.path, taxId],
        data: data);
    return CustomerTaxId.fromMap(dataMap);
  }

  /// [List All a Customer's Tax Ids]
  /// https://stripe.com/docs/api/customer_tax_ids/list
  static Future<CustomerTaxIdCollection> list(String customerId,
      {int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap = await listResource(
        [Customer.path, customerId, CustomerTaxId.path],
        data: data);
    return CustomerTaxIdCollection.fromMap(dataMap);
  }

  /// [Delete a Customer Tax Id]
  /// https://stripe.com/docs/api/customer_tax_ids/delete
  static Future<Map> delete(String taxId, String customerId) =>
      deleteResource([Customer.path, customerId, CustomerTaxId.path, taxId]);
}

class CustomerTaxIdCollection extends ResourceCollection {
  CustomerTaxId getInstanceFromMap(map) => CustomerTaxId.fromMap(map);

  CustomerTaxIdCollection.fromMap(Map map) : super.fromMap(map);
}

class CustomerTaxIdCreation extends ResourceRequest {
  CustomerTaxIdCreation() {
    setRequiredFields('customer');
    setRequiredFields('type');
    setRequiredFields('value');
  }

  set customer(String customerId) => setMap('customer', customerId);

  Future<CustomerTaxId> create(String customerId, String type, String value,
      {String idempotencyKey}) async {
    var dataMap = await createResource(
        [Customer.path, customerId, CustomerTaxId.path], getMap(),
        idempotencyKey: idempotencyKey);
    return CustomerTaxId.fromMap(dataMap);
  }
}
