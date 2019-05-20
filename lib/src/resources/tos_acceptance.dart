import '../resource.dart';

class TosAcceptance extends Resource {
  DateTime get date => getDateTimeFromMap('date');

  String get ip => resourceMap['ip'];

  String get userAgent => resourceMap['user_agent'];

  TosAcceptance.fromMap(Map dataMap) : super.fromMap(dataMap);
}
