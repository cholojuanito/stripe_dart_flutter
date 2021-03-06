library transfer_schedule_tests;

import 'dart:convert';

import 'package:test/test.dart';

import '../../lib/stripe_dart_flutter.dart';
import '../utils.dart' as utils;

var example = '''
    {
      "delay_days": 2,
      "interval": "manual",
      "monthly_anchor": 1,
      "weekly_anchor": "monday"
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('TransferSchedule offline', () {
    test('fromMap() properly popullates all values', () {
      var map = jsonDecode(example);
      var transferSchedule = TransferSchedule.fromMap(map);
      expect(transferSchedule.delayDays, map['delay_days']);
      expect(transferSchedule.interval, map['interval']);
      expect(transferSchedule.monthlyAnchor, map['monthly_anchor']);
      expect(transferSchedule.weeklyAnchor, map['weekly_anchor']);
    });
  });
}
