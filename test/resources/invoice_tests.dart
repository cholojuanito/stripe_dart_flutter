library invoice_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;


var exampleInvoice = """
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
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Invoice offline', () {

    test('fromMap() properly popullates all values', () {

      var map = JSON.decode(exampleInvoice);
      var invoice = new Invoice.fromMap(map);
      expect(invoice.date, new DateTime.fromMillisecondsSinceEpoch(map['date'] * 1000));
      expect(invoice.id, map['id']);
      expect(invoice.periodStart, new DateTime.fromMillisecondsSinceEpoch(map['period_start'] * 1000));
      expect(invoice.periodEnd, new DateTime.fromMillisecondsSinceEpoch(map['period_end'] * 1000));
      expect(invoice.lines.data.first.id, map['lines']['data'][0]['id']);
      expect(invoice.lines.data.first.type, map['lines']['data'][0]['type']);
      expect(invoice.lines.data.first.livemode, map['lines']['data'][0]['livemode']);
      expect(invoice.lines.data.first.amount, map['lines']['data'][0]['amount']);
      expect(invoice.lines.data.first.currency, map['lines']['data'][0]['currency']);
      expect(invoice.lines.data.first.proration, map['lines']['data'][0]['proration']);
      expect(invoice.lines.data.first.period.start, map['lines']['data'][0]['period']['start']);
      expect(invoice.lines.data.first.period.end, map['lines']['data'][0]['period']['end']);
      expect(invoice.lines.data.first.quantity, map['lines']['data'][0]['quantity']);
      expect(invoice.lines.data.first.plan.interval, map['lines']['data'][0]['plan']['interval']);
      expect(invoice.lines.data.first.plan.name, map['lines']['data'][0]['plan']['name']);
      expect(invoice.lines.data.first.plan.created, new DateTime.fromMillisecondsSinceEpoch(map['lines']['data'][0]['plan']['created'] * 1000));
      expect(invoice.lines.data.first.plan.amount, map['lines']['data'][0]['plan']['amount']);
      expect(invoice.lines.data.first.plan.currency, map['lines']['data'][0]['plan']['currency']);
      expect(invoice.lines.data.first.plan.id, map['lines']['data'][0]['plan']['id']);
      expect(invoice.lines.data.first.plan.livemode, map['lines']['data'][0]['plan']['livemode']);
      expect(invoice.lines.data.first.plan.intervalCount, map['lines']['data'][0]['plan']['interval_count']);
      expect(invoice.lines.data.first.plan.trialPeriodDays, map['lines']['data'][0]['plan']['trialPeriodDays']);
      expect(invoice.lines.data.first.plan.metadata, map['lines']['data'][0]['plan']['metadata']);
      expect(invoice.lines.data.first.plan.statementDescriptor, map['lines']['data'][0]['plan']['statement_descriptor']);
      expect(invoice.lines.data.first.description, map['lines']['data'][0]['description']);
      expect(invoice.lines.data.first.metadata, map['lines']['data'][0]['metadata']);
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
      expect(invoice.webhooksDeliveredAt, new DateTime.fromMillisecondsSinceEpoch(map['webhooks_delivered_at'] * 1000));
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

    test('InvoiceCreation minimal', () async {

      Customer customer = await new CustomerCreation().create();
      try {
        await (new InvoiceCreation()
            ..customer = customer.id
        ).create();
      } catch (e) {
        // nothing to invoice for a new customer
        expect(e, new isInstanceOf<InvalidRequestErrorException>());
        expect(e.errorMessage, 'Nothing to invoice for customer');
      }

    });

    test('InvoiceCreation full', () async {

      // Card fields
      String testCardNumber = '5555555555554444';
      int testCardExpMonth = 3;
      int testCardExpYear = 2016;

      CardCreation testCardCreation = new CardCreation()
          ..number = testCardNumber // only the last 4 digits can be tested
          ..expMonth = testCardExpMonth
          ..expYear = testCardExpYear;

      // Plan fields
      String testPlanId = 'test plan id';
      int testPlanAmount = 200;
      String testPlanCurrency = 'usd';
      String testPlanInterval = 'month';
      String testPlanName = 'test plan name';

      // Charge fields
      int testChargeAmount = 100;
      String testChargeCurrency = 'usd';

      // Invoice fields
      String testInvoiceDescription = 'test description';
      Map testInvoiceMetadata = {'foo': 'bar'};

      Plan plan = await (new PlanCreation()
          ..id = testPlanId
          ..amount = testPlanAmount
          ..currency = testPlanCurrency
          ..interval = testPlanInterval
          ..name = testPlanName
      ).create();
      Customer customer = await new CustomerCreation().create();
      await testCardCreation.create(customer.id);
      await (new ChargeCreation()
          ..amount = testChargeAmount
          ..currency = testChargeCurrency
          ..customer = customer.id
      ).create();
      Subscription subscription = await (new SubscriptionCreation()
          ..plan = plan.id
      ).create(customer.id);
      try {
        await (new InvoiceCreation()
            ..customer = customer.id
            ..description = testInvoiceDescription
            ..metadata = testInvoiceMetadata
            ..subscription = subscription.id
        ).create();
      } catch (e) {
        // nothing to invoice for a new customer
        expect(e, new isInstanceOf<InvalidRequestErrorException>());
        expect(e.errorMessage, 'Nothing to invoice for subscription');
      }

    });

  });

}