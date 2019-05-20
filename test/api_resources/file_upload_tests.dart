library file_upload_tests;

import 'dart:convert';

import 'package:test/test.dart';

import '../../lib/stripe_dart_flutter.dart';
import '../utils.dart' as utils;

var example = '''
    {
      "id": "file_15uLVh41dfVNZFcq2o857dQ3",
      "object": "file_upload",
      "created": 1429700117,
      "purpose": "dispute_evidence",
      "size": 100,
      "type": "png",
      "url": "url"
    }''';

main(List<String> args) {
  utils.setApiKeyFromArgs(args);

  group('FileUpload offline', () {
    test('fromMap() properly popullates all values', () {
      var map = jsonDecode(example);
      var fileUpload = FileUpload.fromMap(map);
      expect(fileUpload.id, map['id']);
      expect(fileUpload.created,
          DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000));
      expect(fileUpload.purpose, map['purpose']);
      expect(fileUpload.size, map['size']);
      expect(fileUpload.type, map['type']);
      expect(fileUpload.url, map['url']);
    });
  });
}
