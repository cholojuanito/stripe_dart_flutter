import '../resource.dart';
import '../service.dart';

import 'coupon.dart';
import 'customer.dart';
import 'subscription.dart';

/// [Discounts](https://stripe.com/docs/api/curl#discounts)
class Discount extends Resource {
  String get id => resourceMap['id'];

  final String object = 'discount';

  static var path = 'discount';

  Coupon get coupon {
    var value = resourceMap['coupon'];
    if (value == null)
      return null;
    else
      return Coupon.fromMap(value);
  }

  String get customer => resourceMap['customer'];

  DateTime get start => getDateTimeFromMap('start');

  DateTime get end => getDateTimeFromMap('end');

  String get subscription => resourceMap['subscription'];

  Discount.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Deleting a Customer-wide Discount](https://stripe.com/docs/api/curl#delete_discount)
  static Future<Map> deleteForCustomer(String customerId) =>
      StripeService.delete([Customer.path, customerId, Discount.path]);

  /// [Deleting a Subscription Discount](https://stripe.com/docs/api/curl#delete_subscription_discount)
  static Future<Map> deleteForSubscription(
      String customerId, String subscriptionId) {
    return StripeService.delete([
      Customer.path,
      customerId,
      Subscription.path,
      subscriptionId,
      Discount.path
    ]);
  }
}
