library service_tests;

import 'package:test/test.dart';

import '../lib/stripe_dart_flutter.dart';

main() {
  group('', () {
    group('helper functions', () {
      test('encodeMap()', () {
        var encoded = encodeMap({'test': 'val&ue', 'test 2': '/'});
        expect(encoded, 'test=val%26ue&test%202=%2F');
      });
    });
  });
}
