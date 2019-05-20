library application_fee_tests;

import 'dart:convert';

import 'package:test/test.dart';

import '../../lib/stripe_dart_flutter.dart';
import '../utils.dart' as utils;

var example = '''
    {
      "id": "fee_46ctshdXTn0txu",
      "object": "application_fee",
      "created": 1401116624,
      "livemode": false,
      "amount": 100,
      "currency": "usd",
      "refunded": false,
      "amount_refunded": 0,
      "refunds": [
    
      ],
      "balance_transaction": "txn_1044ML41dfVNZFcq7TtjDZeb",
      "account": "acct_103yoB41dfVNZFcq",
      "application": "ca_46ctJf0EUeVbeYGw6K81MlkMuX8kWdAb",
      "charge": "ch_1046aN41dfVNZFcq1TGLAbRm"
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Account offline', () {
    test('fromMap() properly popullates all values', () {
      var map = jsonDecode(example);
      var applicationFee = ApplicationFee.fromMap(map);
      expect(applicationFee.id, map['id']);
      expect(applicationFee.created,
          DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000));
      expect(applicationFee.livemode, map['livemode']);
      expect(applicationFee.amount, map['amount']);
      expect(applicationFee.currency, map['currency']);
      expect(applicationFee.refunded, map['refunded']);
      expect(applicationFee.amountRefunded, map['amount_refunded']);
      expect(applicationFee.refunds, map['refunds']);
      expect(applicationFee.balanceTransaction, map['balance_transaction']);
      expect(applicationFee.account, map['account']);
      expect(applicationFee.application, map['application']);
      expect(applicationFee.charge, map['charge']);
    });
  });
}
