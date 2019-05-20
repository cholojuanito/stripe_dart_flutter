library discount_tests;

import 'dart:convert';

import 'package:test/test.dart';

import '../../lib/stripe_dart_flutter.dart';
import '../utils.dart' as utils;

var example = '''
    {
      "coupon": {
        "id": "25OFF",
        "created": 1400067246,
        "percent_off": 25,
        "amount_off": null,
        "currency": "usd",
        "object": "coupon",
        "livemode": false,
        "duration": "repeating",
        "redeem_by": null,
        "max_redemptions": null,
        "times_redeemed": 0,
        "duration_in_months": 3,
        "valid": true,
        "metadata": {
        }
      },
      "start": 1399314836,
      "object": "discount",
      "customer": "cus_41UmfewrwpkH2c",
      "subscription": null,
      "end": null
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Discount offline', () {
    test('fromMap() properly popullates all values', () {
      var map = jsonDecode(example);
      var discount = Discount.fromMap(map);
      expect(discount.start,
          DateTime.fromMillisecondsSinceEpoch(map['start'] * 1000));
      expect(discount.customer, map['customer']);
      expect(discount.subscription, map['subscription']);
      expect(discount.end, map['end']);
      expect(discount.coupon.id, map['coupon']['id']);
      expect(discount.coupon.created,
          DateTime.fromMillisecondsSinceEpoch(map['coupon']['created'] * 1000));
      expect(discount.coupon.percentOff, map['coupon']['percent_off']);
      expect(discount.coupon.amountOff, map['coupon']['amount_off']);
      expect(discount.coupon.currency, map['coupon']['currency']);
      expect(discount.coupon.livemode, map['coupon']['livemode']);
      expect(discount.coupon.duration, map['coupon']['duration']);
      expect(discount.coupon.redeemBy, map['coupon']['redeem_by']);
      expect(discount.coupon.maxRedemptions, map['coupon']['max_redemptions']);
      expect(discount.coupon.timesRedeemed, map['coupon']['times_redeemed']);
      expect(discount.coupon.durationInMonths,
          map['coupon']['duration_in_months']);
      expect(discount.coupon.valid, map['coupon']['valid']);
      expect(discount.coupon.metadata, map['coupon']['metadata']);
    });
  });

  group('Discount online', () {
    tearDown(() {
      return utils.tearDown();
    });

    test('Delete from Customer', () async {
      // Coupon fields
      var couponId = 'test coupon id',
          couponDuration = 'forever',
          couponPercentOff = 15;

      var coupon = await (CouponCreation()
            ..id = couponId
            ..duration = couponDuration
            ..percentOff = couponPercentOff)
          .create();
      var customer = await (CustomerCreation()..coupon = coupon.id).create();
      expect(customer.discount.coupon.percentOff, couponPercentOff);
      var discount = customer.discount;
      var response = await Discount.deleteForCustomer(customer.id);
      expect(response['deleted'], isTrue);
      expect(response['id'], discount.id);
      customer = await Customer.retrieve(customer.id);
      expect(customer.discount, isNull);
    });

    test('Delete from Subscription', () async {
      var cardNumber = '5555555555554444',
          cardExpMonth = 3,
          cardExpYear = 2020,
          cvc = 123;

      var cardCreation = CardCreation()
        ..number = cardNumber // only the last 4 digits can be tested
        ..expMonth = cardExpMonth
        ..expYear = cardExpYear
        ..cvc = cvc;

      // Plan fields
      var planId = 'test plan id',
          planAmount = 200,
          planCurrency = 'usd',
          planInterval = 'month',
          planName = 'test plan name',

          // Coupon fields
          couponId = 'test coupon id',
          couponDuration = 'forever',
          couponPercentOff = 15;

      var coupon = await (CouponCreation()
            ..id = couponId
            ..duration = couponDuration
            ..percentOff = couponPercentOff)
          .create();
      var plan = await (PlanCreation()
            ..id = planId
            ..amount = planAmount
            ..currency = planCurrency
            ..interval = planInterval
            ..name = planName)
          .create();
      var customer = await CustomerCreation().create();
      await cardCreation.create(customer.id);
      var subscription = await (SubscriptionCreation()
            ..plan = plan.id
            ..coupon = coupon.id)
          .create(customer.id);
      expect(subscription.discount.coupon.percentOff, couponPercentOff);
      var discount = subscription.discount;
      var response =
          await Discount.deleteForSubscription(customer.id, subscription.id);
      expect(response['deleted'], isTrue);
      expect(response['id'], discount.id);
      subscription = await Subscription.retrieve(customer.id, subscription.id);
      expect(subscription.discount, isNull);
    });
  });
}
