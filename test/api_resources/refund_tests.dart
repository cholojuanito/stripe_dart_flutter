library refund_tests;

import 'dart:convert';

import 'package:test/test.dart';

import '../../lib/stripe_dart_flutter.dart';
import '../utils.dart' as utils;

var example = '''
    {
      "id": "re_15tboK41dfVNZFcqGjeMiXGv",
      "object": "refund",
      "amount": 10,
      "created": 1429524448,
      "currency": "usd",
      "balance_transaction": "txn_15tboK41dfVNZFcqCs5n6DLf"
    }''';

var collectionExample = '''
    {
      "object": "list",
      "total_count": 1,
      "has_more": false,
      "url": "/v1/charges/ch_15tbwd41dfVNZFcq48lWk5V2/refunds",
      "data": [${example}]
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Refund offline', () {
    test('fromMap() properly popullates all values', () {
      var map = jsonDecode(example);
      var refund = Refund.fromMap(map);
      expect(refund.id, map['id']);
      expect(refund.amount, map['amount']);
      expect(refund.created,
          DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000));
      expect(refund.currency, map['currency']);
      expect(refund.balanceTransaction, map['balance_transaction']);
    });
  });

  group('Refund online', () {
    tearDown(() {
      return utils.tearDown();
    });

    test('Create minimal', () async {
      // Card fields
      var cardNumber = '4242424242424242',
          cardExpMonth = 12,
          cardExpYear = 2020,
          cvc = 123,

          // Charge fields
          chargeAmount = 100,
          chargeCurrency = 'usd';

      var customer = await CustomerCreation().create();
      await (CardCreation()
            ..number = cardNumber
            ..expMonth = cardExpMonth
            ..expYear = cardExpYear
            ..cvc = cvc)
          .create(customer.id);
      var charge = await (ChargeCreation()
            ..amount = chargeAmount
            ..currency = chargeCurrency
            ..customer = customer.id)
          .create();
      var refund = await RefundCreation().create(charge.id);
      expect(refund.amount, chargeAmount);
      expect(refund.currency, chargeCurrency);
      expect(refund.charge, charge.id);
    });

    test('Create full', () async {
      // Card fields
      var cardNumber = '4242424242424242',
          cardExpMonth = 12,
          cardExpYear = 2020,
          cvc = 123,

          // Charge fields
          chargeAmount = 100,
          chargeCurrency = 'eur',

          // Refund fields
          refundAmount = 50,
          refundReason = 'fraudulent',
          refundMetadata1 = {'foo': 'bar1'},
          refundMetadata2 = {'foo': 'bar2'};

      var customer = await CustomerCreation().create();
      await (CardCreation()
            ..number = cardNumber
            ..expMonth = cardExpMonth
            ..expYear = cardExpYear
            ..cvc = cvc)
          .create(customer.id);
      var charge = await (ChargeCreation()
            ..amount = chargeAmount
            ..currency = chargeCurrency
            ..customer = customer.id)
          .create();
      var refund = await (RefundCreation()
            ..amount = refundAmount
            ..reason = refundReason
            ..metadata = refundMetadata1)
          .create(charge.id);
      expect(refund.amount, refundAmount);
      expect(refund.reason, refundReason);
      expect(refund.metadata, refundMetadata1);
      // testing the expand functionality of retrieve
      refund = await Refund.retrieve(charge.id, refund.id, data: {
        'expand': ['balance_transaction']
      });
      expect(
          refund.balanceTransactionExpand.amount, closeTo(-refundAmount, 10));
      expect(refund.balanceTransactionExpand.currency, chargeCurrency);
      expect(refund.balanceTransactionExpand.type, 'refund');
      expect(refund.balanceTransactionExpand.source, refund.id);
      // testing the ChargeUpdate
      refund = await (RefundUpdate()..metadata = refundMetadata2)
          .update(charge.id, refund.id);
      expect(refund.metadata, refundMetadata2);
    });

    test('List parameters', () async {
      var cardNumber = '4242424242424242',
          cardExpMonth = 12,
          cardExpYear = 2020,
          cvc = 123,

          // Charge fields
          chargeAmount = 100,
          chargeCurrency = 'usd';

      var customer = await CustomerCreation().create();
      await (CardCreation()
            ..number = cardNumber
            ..expMonth = cardExpMonth
            ..expYear = cardExpYear
            ..cvc = cvc)
          .create(customer.id);
      var charge = await (ChargeCreation()
            ..amount = chargeAmount
            ..currency = chargeCurrency
            ..customer = customer.id)
          .create();

      for (var i = 0; i < 20; i++) {
        await (RefundCreation()..amount = 5).create(charge.id);
      }
      var charges = await Refund.list(charge.id, limit: 10);
      expect(charges.data.length, 10);
      expect(charges.hasMore, isTrue);
      charges = await Refund.list(charge.id,
          limit: 10, startingAfter: charges.data.last.id);
      expect(charges.data.length, 10);
      expect(charges.hasMore, isFalse);
      charges = await Refund.list(charge.id,
          limit: 10, endingBefore: charges.data.first.id);
      expect(charges.data.length, 10);
      expect(charges.hasMore, isFalse);
    });
  });
}
