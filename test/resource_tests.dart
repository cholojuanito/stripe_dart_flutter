library resource_tests;

import 'package:test/test.dart';

import '../lib/stripe.dart' as stripe;

class TestResource extends stripe.Resource {
  bool test = true;
  TestResource.fromMap(map) : super.fromMap(map);
}

main() {
  group('Resource', () {
    test('should not fail if datamap is null', () {
      var map = null;
      var testResource = new TestResource.fromMap(map);
      expect(testResource, new isInstanceOf<TestResource>());
      expect(testResource.test, isTrue);
    });
  });
}
