library verification_tests;

import 'dart:convert';

import 'package:test/test.dart';

import '../../lib/stripe_dart_flutter.dart';
import '../utils.dart' as utils;
import '../api_resources/file_upload_tests.dart' as file_upload;

var example = '''
    {
      "status": "pending",
      "details": "Identity document is too unclear to read.",
      "document": ${file_upload.example}
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('Verification offline', () {
    test('fromMap() properly popullates all values', () {
      var map = jsonDecode(example);
      var verification = Verification.fromMap(map);
      expect(verification.status, map['status']);
      expect(verification.details, map['details']);
      expect(verification.documentExpand.toMap(),
          FileUpload.fromMap(map['document']).toMap());
    });
  });
}
