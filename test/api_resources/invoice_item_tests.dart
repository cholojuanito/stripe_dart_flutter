library invoice_item_tests;

import 'dart:convert';

import 'package:test/test.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var example = '''
    {
      "object": "invoiceitem",
      "id": "ii_1046ct41dfVNZFcq7D6Z8lys",
      "date": 1401116624,
      "amount": 100,
      "livemode": false,
      "proration": false,
      "currency": "usd",
      "customer": "cus_46ctVjlaQj7Nbr",
      "description": "My First Invoice Item (created for API docs)",
      "metadata": {
      },
      "invoice": null,
      "subscription": null
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('InvoiceItem offline', () {
    test('fromMap() properly popullates all values', () {
      var map = jsonDecode(example);
      var invoiceItem =  InvoiceItem.fromMap(map);
      expect(invoiceItem.id, map['id']);
      expect(invoiceItem.date,
           DateTime.fromMillisecondsSinceEpoch(map['date'] * 1000));
      expect(invoiceItem.amount, map['amount']);
      expect(invoiceItem.livemode, map['livemode']);
      expect(invoiceItem.proration, map['proration']);
      expect(invoiceItem.currency, map['currency']);
      expect(invoiceItem.customer, map['customer']);
      expect(invoiceItem.description, map['description']);
      expect(invoiceItem.metadata, map['metadata']);
      expect(invoiceItem.invoice, map['invoice']);
      expect(invoiceItem.subscription, map['subscription']);
    });
  });

  group('InvoiceItem online', () {
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

      var customer = await  CustomerCreation().create();
      await ( CardCreation()
            ..number = cardNumber
            ..expMonth = cardExpMonth
            ..expYear = cardExpYear
            ..cvc = cvc)
          .create(customer.id);
      var invoiceItem = await ( InvoiceItemCreation()
            ..customer = customer.id
            ..amount = chargeAmount
            ..currency = chargeCurrency)
          .create();
      expect(invoiceItem.amount, chargeAmount);
      expect(invoiceItem.currency, chargeCurrency);
      expect(invoiceItem.customer, customer.id);
    });

    test('Create full', () async {
      // Card fields
      var cardNumber = '4242424242424242',
          cardExpMonth = 12,
          cardExpYear = 2020,
          cvc = 123;

      var cardCreation =  CardCreation()
        ..number = cardNumber
        ..expMonth = cardExpMonth
        ..expYear = cardExpYear
        ..cvc = cvc;

      // Charge fields
      var chargeCurrency = 'usd',

          // Plan fields
          planId = 'test plan id',
          planAmount = 200,
          planCurrency = 'usd',
          planInterval = 'month',
          planName = 'test plan name',

          // Invoiceitem fields
          invoiceItemCurrency = 'usd',
          invoiceItemAmount1 = 200,
          invoiceItemDescription1 = 'test description1',
          invoiceItemMetadata1 = {'foo': 'bar1'},
          invoiceItemAmount2 = 220,
          invoiceItemDescription2 = 'test description2',
          invoiceItemMetadata2 = {'foo': 'bar2'};

      var plan = await ( PlanCreation()
            ..id = planId
            ..amount = planAmount
            ..currency = planCurrency
            ..interval = planInterval
            ..name = planName)
          .create();
      var customer = await  CustomerCreation().create();
      await cardCreation.create(customer.id);
      var subscription = await ( SubscriptionCreation()..plan = plan.id)
          .create(customer.id);
      var invoiceItem = await ( InvoiceItemCreation()
            ..customer = customer.id
            ..amount = invoiceItemAmount1
            ..currency = invoiceItemCurrency
            ..subscription = subscription.id
            ..description = invoiceItemDescription1
            ..metadata = invoiceItemMetadata1)
          .create();
      expect(invoiceItem.amount, invoiceItemAmount1);
      expect(invoiceItem.currency, invoiceItemCurrency);
      expect(invoiceItem.customer, customer.id);
      expect(invoiceItem.subscription, subscription.id);
      expect(invoiceItem.description, invoiceItemDescription1);
      expect(invoiceItem.metadata, invoiceItemMetadata1);
      // seems that expanding currently does not work according to the API specification
      // testing retrieve
      invoiceItem = await InvoiceItem.retrieve(invoiceItem.id);
      expect(invoiceItem.amount, invoiceItemAmount1);
      expect(invoiceItem.currency, chargeCurrency);
      expect(invoiceItem.customer, customer.id);
      expect(invoiceItem.subscription, subscription.id);
      expect(invoiceItem.description, invoiceItemDescription1);
      expect(invoiceItem.metadata, invoiceItemMetadata1);
      // testing InvoiceitemUpdate
      invoiceItem = await ( InvoiceItemUpdate()
            ..amount = invoiceItemAmount2
            ..description = invoiceItemDescription2
            ..metadata = invoiceItemMetadata2)
          .update(invoiceItem.id);
      expect(invoiceItem.amount, invoiceItemAmount2);
      expect(invoiceItem.description, invoiceItemDescription2);
      expect(invoiceItem.metadata, invoiceItemMetadata2);
      // testing delete
      var response = await InvoiceItem.delete(invoiceItem.id);
      expect(response['id'], invoiceItem.id);
      expect(response['deleted'], isTrue);
    });

    test('List parameters', () async {
      // Card fields
      var cardNumber = '4242424242424242',
          cardExpMonth = 12,
          cardExpYear = 2020,
          cvc = 123,

          // Charge fields
          chargeAmount = 100,
          chargeCurrency = 'usd';

      var customer = await  CustomerCreation().create();

      await ( CardCreation()
            ..number = cardNumber
            ..expMonth = cardExpMonth
            ..expYear = cardExpYear
            ..cvc = cvc)
          .create(customer.id);

      for (var i = 0; i < 20; i++) {
        await ( InvoiceItemCreation()
              ..customer = customer.id
              ..amount = chargeAmount
              ..currency = chargeCurrency)
            .create();
      }

      var invoiceItems = await InvoiceItem.list(limit: 10);
      expect(invoiceItems.data.length, 10);
      expect(invoiceItems.hasMore, isTrue);
      invoiceItems = await InvoiceItem.list(
          limit: 10, startingAfter: invoiceItems.data.last.id);
      expect(invoiceItems.data.length, 10);
      expect(invoiceItems.hasMore, isFalse);
      invoiceItems = await InvoiceItem.list(
          limit: 10, endingBefore: invoiceItems.data.first.id);
      expect(invoiceItems.data.length, 10);
      expect(invoiceItems.hasMore, isFalse);
    });
  });
}
