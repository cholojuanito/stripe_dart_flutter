library account_tests;

import 'dart:convert';

import 'package:stripe/stripe.dart' as prefix0;
import 'package:test/test.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

import '../resources/bank_account_tests.dart' as bank_account;
import '../resources/legal_entity_tests.dart' as legal_entity;
import '../resources/tos_acceptance_tests.dart' as tos_acceptance;
import '../resources/transfer_schedule_tests.dart' as transfer_schedule;
import '../resources/verification_tests.dart' as verification;

var example = '''
    {
      "id": "acct_102yoB41dfVNZF549",
      "object": "account",
      "business_profile": {
        "mcc": "5734",
        "name": null,
        "product_description": "A test account for our software. We are making a marketplace for property owners and service providers",
        "support_address": null,
        "support_email": null,
        "support_phone": "+18018745732",
        "support_url": null,
        "url": "https://www.linkedin.com/company/propowner"
      },
      "business_type": "individual",
      "capabilities": {
        "card_payments": "active",
        "platform_payments": "pending"
      },
      "charges_enabled": true,
      "country": "US",
      "default_currency": "usd",
      "details_submitted": true,
      "email": "test@test.com",
      "metadata": ${utils.metadataExample},
      "requested_capabilities": ["platform_payments", "card_payments"],
      "settings": {},
      "tos_acceptance": ${tos_acceptance.example},
      "type": "custom"
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  try {
    group('Account offline', () {
      test('fromMap() properly populates all values', () {
        var map = jsonDecode(example);
        var account = Account.fromMap(map);
        expect(account.id, map['id']);
        expect(account.type, map['type']);
        expect(account.businessProfile.toMap(), map['business_profile']);
        expect(account.capabilities.toMap(), map['capabilities']);
        expect(account.country, map['country']);
        expect(account.defaultCurrency, map['default_currency']);
        expect(account.email, map['email']);
        // TODO add missing tests
        expect(account.metadata, map['metadata']);
        expect(account.tosAcceptance.toMap(),
            TosAcceptance.fromMap(map['tos_acceptance']).toMap());
      });
    });

    group('Account online', () {
      test('Create minimal', () async {
        var accountCreate = AccountCreation();
        accountCreate.type = 'custom';
        accountCreate.requestedCapabilities = [
          'platform_payments',
          'card_payments'
        ];
        var account = await accountCreate.create();
        expect(account.id, const TypeMatcher<String>());

        print(account);
      });

      String createdAccountId;
      test('Create full', () async {
        var map = jsonDecode(example);
        var accountMap = Account.fromMap(map);
        var accountCreate = AccountCreation()
          ..type = accountMap.type
          ..businessProfile = accountMap.businessProfile
          ..businessType = accountMap.businessType
          ..country = accountMap.country
          ..defaultCurrency = accountMap.defaultCurrency
          ..email = accountMap.email
          ..metadata = accountMap.metadata
          ..requestedCapabilities = map['requested_capabilities']
          ..tosAcceptance = accountMap.tosAcceptance;

        var createdAccount = await accountCreate.create();
        expect(createdAccount.id.substring(0, 3), 'acc');
        createdAccountId = createdAccount.id;
      });

      test('Retrieve Account', () async {
        var account = await Account.retrieve(accountId: createdAccountId);
        expect(account.id.substring(0, 3), 'acc');
        expect(account.id, createdAccountId);
        // other tests will depend on your stripe account
      });
    });
  } catch (e) {
    print(e);
  }
}
