import '../api_resource.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

import 'card.dart';
import 'discount.dart';
import 'subscription.dart';

/// [Customers](https://stripe.com/docs/api#customers)
class Customer extends ApiResource {
  String get id => resourceMap['id'];

  final String object = 'customer';

  static var path = 'customers';

  bool get livemode => resourceMap['livemode'];

  DateTime get created => getDateTimeFromMap('created');

  int get accountBalance => resourceMap['account_balance'];

  String get currency => resourceMap['currency'];

  String get defaultSource {
    return this.getIdForExpandable('default_source');
  }

  Card get defaultSourceExpand {
    var value = resourceMap['default_source'];
    if (value == null)
      return null;
    else
      return Card.fromMap(value);
  }

  bool get delinquent => resourceMap['delinquent'];

  String get description => resourceMap['description'];

  Discount get discount {
    var value = resourceMap['discount'];
    if (value == null)
      return null;
    else
      return Discount.fromMap(value);
  }

  String get email => resourceMap['email'];

  Map<String, String> get metadata => resourceMap['metadata'];

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

  Customer.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve a customer](https://stripe.com/docs/api#retrieve_customer)
  static Future<Customer> retrieve(String customerId, {final Map data}) async {
    var dataMap =
        await StripeService.retrieve([Customer.path, customerId], data: data);
    return Customer.fromMap(dataMap);
  }

  /// [List all Customers](https://stripe.com/docs/api#list_customers)
  static Future<CustomerCollection> list(
      {var created,
      int limit,
      String startingAfter,
      String endingBefore}) async {
    var data = {};
    if (created != null) data['created'] = created;
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap = await StripeService.list([Customer.path], data: data);
    return CustomerCollection.fromMap(dataMap);
  }

  /// [Delete a customer](https://stripe.com/docs/api#delete_customer)
  static Future<Map> delete(String customerId) =>
      StripeService.delete([Customer.path, customerId]);
}

class CustomerCollection extends ResourceCollection {
  Customer getInstanceFromMap(map) => Customer.fromMap(map);

  CustomerCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Create a customer](https://stripe.com/docs/api#create_customer)
class CustomerCreation extends ResourceRequest {
  set accountBalance(int accountBalance) =>
      setMap('account_balance', accountBalance);

  set coupon(String coupon) => setMap('coupon', coupon);

  set description(String description) => setMap('description', description);

  set email(String email) => setMap('email', email);

  set metadata(Map metadata) => setMap('metadata', metadata);

  set plan(String plan) => setMap('plan', plan);

  set quantity(int quantity) => setMap('quantity', quantity);

  set source(SourceCreation source) => setMap('source', source);

  set trialEnd(int trialEnd) => setMap('trial_end', trialEnd);

  Future<Customer> create({String idempotencyKey}) async {
    var dataMap = await StripeService.create([Customer.path], getMap(),
        idempotencyKey: idempotencyKey);
    return Customer.fromMap(dataMap);
  }
}

/// [Update a customer](https://stripe.com/docs/api#update_customer)
class CustomerUpdate extends ResourceRequest {
  set accountBalance(int accountBalance) =>
      setMap('account_balance', accountBalance);

  set coupon(String coupon) => setMap('coupon', coupon);

  set description(String description) => setMap('description', description);

  set email(String email) => setMap('email', email);

  set metadata(Map metadata) => setMap('metadata', metadata);

  set sourceToken(String sourceToken) => setMap('source', sourceToken);

  set source(SourceCreation source) => setMap('source', source);

  set defaultSource(String sourceId) => setMap('default_source', sourceId);

  Future<Customer> update(String customerId) async {
    var dataMap =
        await StripeService.update([Customer.path, customerId], getMap());
    return Customer.fromMap(dataMap);
  }
}
