library card_tests;

import 'dart:convert';

import 'package:test/test.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var example = '''
    {
      "id": "card_103yOK2eZvKYlo2CNWdHfG5K",
      "object": "card",
      "last4": "4242",
      "brand": "Visa",
      "exp_month": 1,
      "exp_year": 2050,
      "fingerprint": "Xt5EWLLDS7FJjR1c",
      "customer": null,
      "country": "US",
      "name": null,
      "address_line1": null,
      "address_line2": null,
      "address_city": null,
      "address_state": null,
      "address_zip": null,
      "address_country": null,
      "cvc_check": "pass",
      "address_line1_check": null,
      "address_zip_check": null
    }''';

var collectionExample = '''
    {
      "object": "list",
      "total_count": 1,
      "has_more": false,
      "url": "/v1/customers/cus_65o6CvzZy0OcMf/sources",
      "data": [${example}]
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Card offline', () {
    test('fromMap() properly popullates all values', () {
      var map = jsonDecode(example);
      var card = Card.fromMap(map);
      expect(card.id, map['id']);
      expect(card.last4, map['last4']);
      expect(card.brand, map['brand']);
      expect(card.expMonth, map['exp_month']);
      expect(card.expYear, map['exp_year']);
      expect(card.fingerprint, map['fingerprint']);
      expect(card.customer, map['customer']);
      expect(card.addressLine1, map['address_line1']);
      expect(card.addressLine2, map['address_line2']);
      expect(card.addressCity, map['address_city']);
      expect(card.addressState, map['address_state']);
      expect(card.addressZip, map['address_zip']);
      expect(card.addressCountry, map['address_country']);
      expect(card.cvcCheck, map['cvc_check']);
      expect(card.addressLine1Check, map['address_line1_check']);
      expect(card.addressZipCheck, map['address_zip_check']);
    });
  });

  group('Card online', () {
    tearDown(() {
      return utils.tearDown();
    });

    test('Create minimal', () async {
      var number = '4242424242424242', expMonth = 12, expYear = 2020, cvc = 123;

      var customer = await CustomerCreation().create();
      expect(customer.id, const TypeMatcher<String>());
      var card = await (CardCreation()
            ..number = number
            ..expMonth = expMonth
            ..expYear = expYear
            ..cvc = cvc)
          .create(customer.id);
      expect(card.id, const TypeMatcher<String>());
      expect(card.last4, number.substring(number.length - 4));
      expect(card.expMonth, expMonth);
      expect(card.expYear, expYear);
    });

    test('Create full', () async {
      var cardNumber = '4242424242424242',
          cardExpMonth1 = 12,
          cardExpYear1 = 2020,
          cardCvc = 123,
          cardName1 = 'Anita Bath',
          cardAddressLine1A = 'Teststreet 2/39A',
          cardAddressLine2A = 'line 2',
          cardAddressCity1 = 'Vienna',
          cardAddressZip1 = '1050',
          cardAddressState1 = 'Vienna',
          cardAddressCountry1 = 'Austria',

          // for update tests
          cardAddressCity2 = 'Laguna Beach',
          cardAddressCountry2 = 'USA',
          cardAddressLine1B = 'Addresslinestreet 12/42A',
          cardAddressLine2B = 'additional address line',
          cardAddressState2 = 'California',
          cardAddressZip2 = '92651',
          cardExpMonth2 = 3,
          cardExpYear2 = 2020,
          cardName2 = 'Agatha Bath';

      var customer = await CustomerCreation().create();
      expect(customer.id, const TypeMatcher<String>());
      var card = await (CardCreation()
            ..number = cardNumber
            ..expMonth = cardExpMonth1
            ..expYear = cardExpYear1
            ..cvc = cardCvc
            ..name = cardName1
            ..addressLine1 = cardAddressLine1A
            ..addressLine2 = cardAddressLine2A
            ..addressCity = cardAddressCity1
            ..addressZip = cardAddressZip1
            ..addressState = cardAddressState1
            ..addressCountry = cardAddressCountry1)
          .create(customer.id);
      expect(card.id, const TypeMatcher<String>());
      expect(card.last4, cardNumber.substring(cardNumber.length - 4));
      expect(card.expMonth, cardExpMonth1);
      expect(card.expYear, cardExpYear1);
      expect(card.cvcCheck, 'pass');
      expect(card.name, cardName1);
      expect(card.addressLine1, cardAddressLine1A);
      expect(card.addressLine1Check, 'pass');
      expect(card.addressLine2, cardAddressLine2A);
      expect(card.addressCity, cardAddressCity1);
      expect(card.addressZip, cardAddressZip1);
      expect(card.addressZipCheck, 'pass');
      expect(card.addressState, cardAddressState1);
      expect(card.addressCountry, cardAddressCountry1);
      // testing the expand functionality of retrieve
      card = await Card.retrieve(customer.id, card.id, data: {
        'expand': ['customer']
      });
      expect(card.customer, customer.id);
      expect(card.customerExpand.id, customer.id);
      // testing the CardUpdate
      card = await (CardUpdate()
            ..addressCity = cardAddressCity2
            ..addressCountry = cardAddressCountry2
            ..addressLine1 = cardAddressLine1B
            ..addressLine2 = cardAddressLine2B
            ..addressState = cardAddressState2
            ..addressZip = cardAddressZip2
            ..expMonth = cardExpMonth2
            ..expYear = cardExpYear2
            ..name = cardName2)
          .update(customer.id, card.id);
      expect(card.expMonth, cardExpMonth2);
      expect(card.expYear, cardExpYear2);
      expect(card.name, cardName2);
      expect(card.addressLine1, cardAddressLine1B);
      expect(card.addressLine1Check, 'pass');
      expect(card.addressLine2, cardAddressLine2B);
      expect(card.addressCity, cardAddressCity2);
      expect(card.addressZip, cardAddressZip2);
      expect(card.addressZipCheck, 'pass');
      expect(card.addressState, cardAddressState2);
      expect(card.addressCountry, cardAddressCountry2);
    });

    test('Delete', () async {
      var number = '4242424242424242', expMonth = 12, expYear = 2020, cvc = 123;

      var customer = await CustomerCreation().create();
      expect(customer.id, const TypeMatcher<String>());
      var card = await (CardCreation()
            ..number = number
            ..expMonth = expMonth
            ..expYear = expYear
            ..cvc = cvc)
          .create(customer.id);
      var response = await Card.delete(customer.id, card.id);
      expect(response['deleted'], isTrue);
      expect(response['id'], card.id);
    });

    test('List parameters', () async {
      var number = '4242424242424242', expMonth = 12, expYear = 2020, cvc = 123;
      Customer customer = await CustomerCreation().create();
      for (var i = 0; i < 20; i++) {
        await (CardCreation()
              ..number = number
              ..expMonth = expMonth
              ..expYear = expYear
              ..cvc = cvc)
            .create(customer.id);
      }
      var cards = await Card.list(customer.id, limit: 10);
      expect(cards.data.length, 10);
      expect(cards.hasMore, isTrue);
      cards = await Card.list(customer.id,
          limit: 10, startingAfter: cards.data.last.id);
      expect(cards.data.length, 10);
      expect(cards.hasMore, isFalse);
      cards = await Card.list(customer.id,
          limit: 10, endingBefore: cards.data.first.id);
      expect(cards.data.length, 10);
      expect(cards.hasMore, isFalse);
    });
  });
}
