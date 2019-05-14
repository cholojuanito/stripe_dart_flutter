import '../api_resource.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

import 'card.dart';
import 'customer.dart';
import 'discount.dart';
import 'plan.dart';

/// [Subscriptions](https://stripe.com/docs/api/curl#subscriptions)
class Subscription extends ApiResource {
  String get id => resourceMap['id'];

  final String object = 'subscription';

  static var path = 'subscriptions';

  bool get cancelAtPeriodEnd => resourceMap['cancel_at_period_end'];

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

  Plan get plan {
    var value = resourceMap['plan'];
    if (value == null)
      return null;
    else
      return Plan.fromMap(value);
  }

  int get quantity => resourceMap['quantity'];

  DateTime get start => getDateTimeFromMap('start');

  String get status => resourceMap['status'];

  int get applicationFeePercent => resourceMap['application_fee_percent'];

  DateTime get canceledAt => getDateTimeFromMap('canceled_at');

  DateTime get currentPeriodEnd => getDateTimeFromMap('current_period_end');

  DateTime get currentPeriodStart => getDateTimeFromMap('current_period_start');

  Discount get discount {
    var value = resourceMap['discount'];
    if (value == null)
      return null;
    else
      return Discount.fromMap(value);
  }

  DateTime get endedAt => getDateTimeFromMap('ended_at');

  Map<String, String> get metadata => resourceMap['metadata'];

  DateTime get trialEnd => getDateTimeFromMap('trial_end');

  DateTime get trialStart => getDateTimeFromMap('trial_start');

  Subscription.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieving a customer's subscription](https://stripe.com/docs/api/curl#retrieve_subscription)
  static Future<Subscription> retrieve(String customerId, String subscriptionId,
      {final Map data}) async {
    var dataMap = await StripeService.retrieve(
        [Customer.path, customerId, Subscription.path, subscriptionId],
        data: data);
    return Subscription.fromMap(dataMap);
  }

  /// [Canceling a Customer's Subscription](https://stripe.com/docs/api/curl#cancel_subscription)
  static Future<Subscription> cancel(String customerId, String subscriptionId,
      {bool atPeriodEnd, final Map data}) async {
    var data = {};
    if (atPeriodEnd != null) data['at_period_end'] = atPeriodEnd;
    if (data == {}) data = null;
    var dataMap = await StripeService.delete(
        [Customer.path, customerId, Subscription.path, subscriptionId],
        data: data);
    return Subscription.fromMap(dataMap);
  }

  /// [Listing subscriptions](https://stripe.com/docs/api/curl#list_subscriptions)
  static Future<SubscriptionCollection> list(String customerId,
      {int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap = await StripeService.list(
        [Customer.path, customerId, Subscription.path],
        data: data);
    return SubscriptionCollection.fromMap(dataMap);
  }
}

class SubscriptionCollection extends ResourceCollection {
  Subscription getInstanceFromMap(map) => Subscription.fromMap(map);

  SubscriptionCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Creating a  subscription](https://stripe.com/docs/api/curl#create_subscription)
class SubscriptionCreation extends ResourceRequest {
  SubscriptionCreation() {
    setMap('object', 'Subscription');
    setRequiredSet('plan');
  }

  // //@required
  set plan(String plan) => setMap('plan', plan);

  set coupon(String coupon) => setMap('coupon', coupon);

  set trialEnd(int trialEnd) => setMap('trial_end', trialEnd);

  set card(CardCreation card) => setMap('card', card);

  set quantity(int quantity) => setMap('quantity', quantity);

  set applicationFeePercent(int applicationFeePercent) =>
      setMap('application_fee_percent', applicationFeePercent);

  set metadata(Map metadata) => setMap('metadata', metadata);

  Future<Subscription> create(String customerId) async {
    var dataMap = await StripeService.create(
        [Customer.path, customerId, Subscription.path], getMap());
    return Subscription.fromMap(dataMap);
  }
}

/// [Updating a Subscription](https://stripe.com/docs/api/curl#update_subscription)
class SubscriptionUpdate extends ResourceRequest {
  set plan(String plan) => setMap('plan', plan);

  set coupon(String coupon) => setMap('coupon', coupon);

  set prorate(bool prorate) => setMap('prorate', prorate);

  set trialEnd(int trialEnd) => setMap('trial_end', trialEnd);

  set card(CardCreation card) => setMap('card', card);

  set quantity(int quantity) => setMap('quantity', quantity);

  set applicationFeePercent(int applicationFeePercent) =>
      setMap('application_fee_percent', applicationFeePercent);

  set metadata(Map metadata) => setMap('metadata', metadata);

  Future<Subscription> update(String customerId, String subscriptionId) async {
    var dataMap = await StripeService.create(
        [Customer.path, customerId, Subscription.path, subscriptionId],
        getMap());
    return Subscription.fromMap(dataMap);
  }
}
