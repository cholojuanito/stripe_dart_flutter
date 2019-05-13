import '../resource.dart';
import '../api_resources/file_upload.dart';

class Verification extends Resource {
  String get id => resourceMap['id'];

  final String object = 'verification';

  String get status => resourceMap['status'];

  String get details => resourceMap['details'];

  String get document {
    return this.getIdForExpandable('document');
  }

  FileUpload get documentExpand {
    var value = resourceMap['document'];
    if (value == null)
      return null;
    else
      return FileUpload.fromMap(value);
  }

  Verification.fromMap(Map dataMap) : super.fromMap(dataMap);
}
