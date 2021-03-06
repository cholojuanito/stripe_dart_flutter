import '../api_resource.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

/// [File uploads](https://stripe.com/docs/api/curl#file_uploads)
class FileUpload extends ApiResource {
  String get id => resourceMap['id'];

  final String object = 'file_upload';

  static var path = 'file';

  DateTime get created => getDateTimeFromMap('created');

  String get filename => resourceMap['filename'];

  /// TODO: Add links list

  String get purpose => resourceMap['purpose'];

  int get size => resourceMap['size'];

  String get title => resourceMap['title'];

  String get type => resourceMap['type'];

  String get url => resourceMap['url'];

  FileUpload.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve a file upload](https://stripe.com/docs/api/curl#retrieve_file_upload)
  static Future<FileUpload> retrieve(String fileUploadId) async {
    var dataMap = await retrieveResource([FileUpload.path, fileUploadId]);
    return FileUpload.fromMap(dataMap);
  }

  /// [List all file uploads](https://stripe.com/docs/api/curl#list_file_uploads)
  static Future<FileUploadCollection> list(
      {var created,
      String purpose,
      int limit,
      String startingAfter,
      String endingBefore}) async {
    var data = {};
    if (created != null) data['created'] = created;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (limit != null) data['limit'] = limit;
    if (purpose != null) data['purpose'] = purpose;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (data == {}) data = null;
    var dataMap = await listResource([FileUpload.path], data: data);
    return FileUploadCollection.fromMap(dataMap);
  }
}

/// [Create a file upload](https://stripe.com/docs/api/curl#create_file_upload)
class UploadFileCreation extends ResourceRequest {
  /// TODO: implement

  /// See the docs for different types of purpose codes
  set purpose(String purpose) => setMap('purpose', purpose);

  Future<FileUpload> create() async {
    var dataMap = await createResource([FileUpload.path], getMap());
    return FileUpload.fromMap(dataMap);
  }
}

class FileUploadCollection extends ResourceCollection {
  FileUpload getInstanceFromMap(map) => FileUpload.fromMap(map);

  FileUploadCollection.fromMap(Map map) : super.fromMap(map);
}
