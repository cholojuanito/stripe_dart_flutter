part of stripe;

/// [Discounts](https://stripe.com/docs/api/curl#discounts)
class Discount extends Resource {
  String get id => _dataMap['id'];

  final String object = 'discount';

  static var _path = 'discount';

  Coupon get coupon {
    var value = _dataMap['coupon'];
    if (value == null)
      return null;
    else
      return new Coupon.fromMap(value);
  }

  String get customer => _dataMap['customer'];

  DateTime get start => _getDateTimeFromMap('start');

  DateTime get end => _getDateTimeFromMap('end');

  String get subscription => _dataMap['subscription'];

  Discount.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Deleting a Customer-wide Discount](https://stripe.com/docs/api/curl#delete_discount)
  static Future<Map> deleteForCustomer(String customerId) =>
      StripeService.delete([Customer._path, customerId, Discount._path]);

  /// [Deleting a Subscription Discount](https://stripe.com/docs/api/curl#delete_subscription_discount)
  static Future<Map> deleteForSubscription(
      String customerId, String subscriptionId) {
    return StripeService.delete([
      Customer._path,
      customerId,
      Subscription._path,
      subscriptionId,
      Discount._path
    ]);
  }
}
