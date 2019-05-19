import '../api_resource.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

/// [Coupons](https://stripe.com/docs/api/curl#coupons)
class Coupon extends ApiResource {
  String get id => resourceMap['id'];

  final String object = 'coupon';

  static var path = 'coupons';

  bool get livemode => resourceMap['livemode'];

  DateTime get created => getDateTimeFromMap('created');

  String get duration => resourceMap['duration'];

  int get amountOff => resourceMap['amount_off'];

  String get currency => resourceMap['currency'];

  int get durationInMonths => resourceMap['duration_in_months'];

  int get maxRedemptions => resourceMap['max_redemptions'];

  Map<String, String> get metadata => resourceMap['metadata'];

  int get percentOff => resourceMap['percent_off'];

  int get redeemBy => resourceMap['redeem_by'];

  int get timesRedeemed => resourceMap['times_redeemed'];

  bool get valid => resourceMap['valid'];

  Coupon.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieving a Coupon](https://stripe.com/docs/api/curl#retrieve_coupon)
  static Future<Coupon> retrieve(String id) async {
    var dataMap = await retrieveResource([Coupon.path, id]);
    return Coupon.fromMap(dataMap);
  }

  /// [List all Coupons](https://stripe.com/docs/api/curl#list_coupons)
  static Future<CouponCollection> list(
      {int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap = await listResource([Coupon.path], data: data);
    return CouponCollection.fromMap(dataMap);
  }

  /// [Deleting a coupon](https://stripe.com/docs/api/curl#delete_coupon)
  static Future<Map> delete(String id) => deleteResource([Coupon.path, id]);
}

class CouponCollection extends ResourceCollection {
  Coupon getInstanceFromMap(map) => Coupon.fromMap(map);

  CouponCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Creating coupons](https://stripe.com/docs/api/curl#create_coupon)
class CouponCreation extends ResourceRequest {
  CouponCreation() {
    setMap('object', 'card');
    setRequiredFields('duration');
  }

  set id(String id) => setMap('id', id);

  // //@required
  set duration(String duration) => setMap('duration', duration);

  set amountOff(int amountOff) => setMap('amount_off', amountOff);

  set currency(String currency) => setMap('currency', currency);

  set durationInMonths(int durationInMonths) =>
      setMap('duration_in_months', durationInMonths);

  set maxRedemptions(int maxRedemptions) =>
      setMap('max_redemptions', maxRedemptions);

  set metadata(Map metadata) => setMap('metadata', metadata);

  set percentOff(int percentOff) => setMap('percent_off', percentOff);

  set redeemBy(int redeemBy) => setMap('redeem_by', redeemBy);

  Future<Coupon> create() async {
    var dataMap = await createResource([Coupon.path], getMap());
    return Coupon.fromMap(dataMap);
  }
}
