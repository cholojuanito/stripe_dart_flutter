library invoice_tests;

import 'dart:convert';

import 'package:test/test.dart';

import '../../lib/stripe_dart_flutter.dart';
import '../utils.dart' as utils;

var example = '''
    {
      "date": 1400855490,
      "id": "in_1045Uh41dfVNZFcqMyRp9Tml",
      "period_start": 1400855477,
      "period_end": 1400855490,
      "lines": {
        "data": [
          {
            "id": "sub_46DlDCMkK4GpF4",
            "object": "line_item",
            "type": "subscription",
            "livemode": true,
            "amount": 2000,
            "currency": "usd",
            "proration": false,
            "period": {
              "start": 1403701532,
              "end": 1406293532
            },
            "quantity": 1,
            "plan": {
              "interval": "month",
              "name": "Gold Special",
              "created": 1401023132,
              "amount": 2000,
              "currency": "usd",
              "id": "gold",
              "object": "plan",
              "livemode": false,
              "interval_count": 1,
              "trial_period_days": null,
              "metadata": {
              },
              "statement_descriptor": null
            },
            "description": null,
            "metadata": {
            }
          }
        ],
        "count": 1,
        "object": "list",
        "url": "/v1/invoices/in_1045Uh41dfVNZFcqMyRp9Tml/lines"
      },
      "subtotal": 100,
      "total": 100,
      "customer": "cus_46Dls5hxVhuWPH",
      "object": "invoice",
      "attempted": true,
      "closed": true,
      "paid": true,
      "livemode": false,
      "attempt_count": 0,
      "amount_due": 100,
      "currency": "usd",
      "starting_balance": 0,
      "ending_balance": 0,
      "next_payment_attempt": null,
      "webhooks_delivered_at": 1400855491,
      "charge": "ch_1045Uh41dfVNZFcqAVSZLtiP",
      "discount": null,
      "application_fee": null,
      "subscription": "sub_45Uh2ly6rObFnk",
      "metadata": {
      },
      "description": null
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Invoice offline', () {
    test('fromMap() properly popullates all values', () {
      var map = jsonDecode(example);
      var invoice = Invoice.fromMap(map);
      expect(invoice.date,
          DateTime.fromMillisecondsSinceEpoch(map['date'] * 1000));
      expect(invoice.id, map['id']);
      expect(invoice.periodStart,
          DateTime.fromMillisecondsSinceEpoch(map['period_start'] * 1000));
      expect(invoice.periodEnd,
          DateTime.fromMillisecondsSinceEpoch(map['period_end'] * 1000));
      expect(invoice.lines.data.first.id, map['lines']['data'][0]['id']);
      expect(invoice.lines.data.first.type, map['lines']['data'][0]['type']);
      expect(invoice.lines.data.first.livemode,
          map['lines']['data'][0]['livemode']);
      expect(
          invoice.lines.data.first.amount, map['lines']['data'][0]['amount']);
      expect(invoice.lines.data.first.currency,
          map['lines']['data'][0]['currency']);
      expect(invoice.lines.data.first.proration,
          map['lines']['data'][0]['proration']);
      expect(invoice.lines.data.first.period.start,
          map['lines']['data'][0]['period']['start']);
      expect(invoice.lines.data.first.period.end,
          map['lines']['data'][0]['period']['end']);
      expect(invoice.lines.data.first.quantity,
          map['lines']['data'][0]['quantity']);
      expect(invoice.lines.data.first.plan.interval,
          map['lines']['data'][0]['plan']['interval']);
      expect(invoice.lines.data.first.plan.name,
          map['lines']['data'][0]['plan']['name']);
      expect(
          invoice.lines.data.first.plan.created,
          DateTime.fromMillisecondsSinceEpoch(
              map['lines']['data'][0]['plan']['created'] * 1000));
      expect(invoice.lines.data.first.plan.amount,
          map['lines']['data'][0]['plan']['amount']);
      expect(invoice.lines.data.first.plan.currency,
          map['lines']['data'][0]['plan']['currency']);
      expect(invoice.lines.data.first.plan.id,
          map['lines']['data'][0]['plan']['id']);
      expect(invoice.lines.data.first.plan.livemode,
          map['lines']['data'][0]['plan']['livemode']);
      expect(invoice.lines.data.first.plan.intervalCount,
          map['lines']['data'][0]['plan']['interval_count']);
      expect(invoice.lines.data.first.plan.trialPeriodDays,
          map['lines']['data'][0]['plan']['trialPeriodDays']);
      expect(invoice.lines.data.first.plan.metadata,
          map['lines']['data'][0]['plan']['metadata']);
      expect(invoice.lines.data.first.plan.statementDescriptor,
          map['lines']['data'][0]['plan']['statement_descriptor']);
      expect(invoice.lines.data.first.description,
          map['lines']['data'][0]['description']);
      expect(invoice.lines.data.first.metadata,
          map['lines']['data'][0]['metadata']);
      expect(invoice.lines.url, map['lines']['url']);
      expect(invoice.subtotal, map['subtotal']);
      expect(invoice.total, map['total']);
      expect(invoice.customer, map['customer']);
      expect(invoice.attempted, map['attempted']);
      expect(invoice.closed, map['closed']);
      expect(invoice.livemode, map['livemode']);
      expect(invoice.attemptCount, map['attempt_count']);
      expect(invoice.amountDue, map['amount_due']);
      expect(invoice.currency, map['currency']);
      expect(invoice.startingBalance, map['starting_balance']);
      expect(invoice.endingBalance, map['ending_balance']);
      expect(invoice.nextPaymentAttempt, map['next_payment_attempt']);
      expect(
          invoice.webhooksDeliveredAt,
          DateTime.fromMillisecondsSinceEpoch(
              map['webhooks_delivered_at'] * 1000));
      expect(invoice.charge, map['charge']);
      expect(invoice.discount, map['discount']);
      expect(invoice.applicationFee, map['application_fee']);
      expect(invoice.subscription, map['subscription']);
      expect(invoice.metadata, map['metadata']);
      expect(invoice.description, map['description']);
    });
  });

  group('Invoice online', () {
    tearDown(() {
      return utils.tearDown();
    });

    test('Create minimal', () async {
      var customer = await CustomerCreation().create();
      try {
        await (InvoiceCreation()..customer = customer.id).create();
      } catch (e) {
        // nothing to invoice for a  customer
        expect(e, const TypeMatcher<InvalidRequestErrorException>());
        expect(e.errorMessage, 'Nothing to invoice for customer');
      }
    });

    test('Create full', () async {
      // Card fields
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

          // Charge fields
          cardAmount = 100,
          cardCurrency = 'usd',

          // Invoice fields
          invoiceDescription = 'test description',
          invoiceMetadata = {'foo': 'bar'};

      var plan = await (PlanCreation()
            ..id = planId
            ..amount = planAmount
            ..currency = planCurrency
            ..interval = planInterval
            ..name = planName)
          .create();
      var customer = await CustomerCreation().create();
      await cardCreation.create(customer.id);
      await (ChargeCreation()
            ..amount = cardAmount
            ..currency = cardCurrency
            ..customer = customer.id)
          .create();
      var subscription =
          await (SubscriptionCreation()..plan = plan.id).create(customer.id);
      try {
        await (InvoiceCreation()
              ..customer = customer.id
              ..description = invoiceDescription
              ..metadata = invoiceMetadata
              ..subscription = subscription.id)
            .create();
      } catch (e) {
        // nothing to invoice for a  customer
        expect(e, const TypeMatcher<InvalidRequestErrorException>());
        expect(e.errorMessage, 'Nothing to invoice for subscription');
      }
    });
  });
}
