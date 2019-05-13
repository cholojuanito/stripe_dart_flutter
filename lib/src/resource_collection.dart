import 'api_resource.dart';

/// An abstract collection class that helps retrieving multiple elements of the
/// same resource.
abstract class ResourceCollection<T> extends ApiResource {
  final String object = 'list';

  List<T> get data {
    var data;
    if ((data = resourceMap['data']) == null)
      return null;
    else {
      var list =  List<T>();
      for (var map in data) {
        list.add(getInstanceFromMap(map));
      }
      return list;
    }
  }

  T getInstanceFromMap(map);

  String get url => resourceMap['url'];

  bool get hasMore => resourceMap['has_more'];

  ResourceCollection.fromMap(Map dataMap) : super.fromMap(dataMap);
}
