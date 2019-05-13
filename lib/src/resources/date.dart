import '../resource.dart';

class Date extends Resource {
  int get day => resourceMap['day'];

  int get month => resourceMap['month'];

  int get year => resourceMap['year'];

  Date.fromMap(Map dataMap) : super.fromMap(dataMap);
}
