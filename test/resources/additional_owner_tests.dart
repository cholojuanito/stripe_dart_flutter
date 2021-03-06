library additional_owner_tests;

import 'dart:convert';

import 'package:test/test.dart';

import '../../lib/stripe_dart_flutter.dart';
import '../utils.dart' as utils;

import 'address_tests.dart' as address;
import 'date_tests.dart' as date;
import 'verification_tests.dart' as verification;

var example = '''
    {
      "address": ${address.example},
      "dob": ${date.example},
      "verification": ${verification.example},
      "first_name": "first_name",
      "last_name": "last_name"
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('AdditionalOwner offline', () {
    test('fromMap() properly popullates all values', () {
      var map = jsonDecode(example);
      var additionalOwner = AdditionalOwner.fromMap(map);
      expect(additionalOwner.address.toMap(),
          Address.fromMap(map['address']).toMap());
      expect(additionalOwner.dateOfBirth.toMap(),
          Date.fromMap(map['dob']).toMap());
      expect(additionalOwner.verification.toMap(),
          Verification.fromMap(map['verification']).toMap());
      expect(additionalOwner.firstName, map['first_name']);
      expect(additionalOwner.lastName, map['last_name']);
    });
  });
}
