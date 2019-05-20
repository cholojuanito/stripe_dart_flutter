import '../resource.dart';

class TransferSchedule extends Resource {
  int get delayDays => resourceMap['delay_days'];

  String get interval => resourceMap['interval'];

  int get monthlyAnchor => resourceMap['monthly_anchor'];

  String get weeklyAnchor => resourceMap['weekly_anchor'];

  TransferSchedule.fromMap(Map dataMap) : super.fromMap(dataMap);
}
