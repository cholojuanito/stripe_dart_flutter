import '../api_resource.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

/// [Plans](https://stripe.com/docs/api/curl#plans)
class Plan extends ApiResource {
  String get id => resourceMap['id'];

  final String object = 'plan';

  static var path = 'plans';

  bool get livemode => resourceMap['livemode'];

  int get amount => resourceMap['amount'];

  DateTime get created => getDateTimeFromMap('created');

  String get currency => resourceMap['currency'];

  String get interval => resourceMap['interval'];

  int get intervalCount => resourceMap['interval_count'];

  String get name => resourceMap['name'];

  Map<String, String> get metadata => resourceMap['metadata'];

  int get trialPeriodDays => resourceMap['trial_period_days'];

  String get statementDescriptor => resourceMap['statement_descriptor'];

  Plan.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieving a Plan](https://stripe.com/docs/api/curl#retrieve_plan)
  static Future<Plan> retrieve(String id) async {
    var dataMap = await retrieveResource([Plan.path, id]);
    return Plan.fromMap(dataMap);
  }

  /// [List all Plans](https://stripe.com/docs/api/curl#list_plans)
  static Future<PlanCollection> list(
      {int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap = await listResource([Plan.path], data: data);
    return PlanCollection.fromMap(dataMap);
  }

  /// [Deleting a plan](https://stripe.com/docs/api/curl#delete_plan)
  static Future<Map> delete(String id) => deleteResource([Plan.path, id]);
}

class PlanCollection extends ResourceCollection {
  Plan getInstanceFromMap(map) => Plan.fromMap(map);

  PlanCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Creating plans](https://stripe.com/docs/api/curl#create_plan)
class PlanCreation extends ResourceRequest {
  PlanCreation() {
    setMap('object', 'Plan');
    setRequiredFields('id');
    setRequiredFields('amount');
    setRequiredFields('currency');
    setRequiredFields('interval');
    setRequiredFields('name');
  }

  // //@required
  set id(String id) => setMap('id', id);

  // //@required
  set amount(int amount) => setMap('amount', amount);

  // //@required
  set currency(String currency) => setMap('currency', currency);

  // //@required
  set interval(String interval) => setMap('interval', interval);

  set intervalCount(int intervalCount) =>
      setMap('interval_count', intervalCount);

  // //@required
  set name(String name) => setMap('name', name);

  set trialPeriodDays(int trialPeriodDays) =>
      setMap('trial_period_days', trialPeriodDays);

  set metadata(Map metadata) => setMap('metadata', metadata);

  set statementDescriptor(String statementDescriptor) =>
      setMap('statement_descriptor', statementDescriptor);

  Future<Plan> create() async {
    var dataMap = await createResource([Plan.path], getMap());
    return Plan.fromMap(dataMap);
  }
}

/// [Updating a plan](https://stripe.com/docs/api/curl#update_plan)
class PlanUpdate extends ResourceRequest {
  set name(String name) => setMap('name', name);

  set metadata(Map metadata) => setMap('metadata', metadata);

  set statementDescriptor(String statementDescriptor) =>
      setMap('statement_descriptor', statementDescriptor);

  Future<Plan> update(String planId) async {
    var dataMap = await updateResource([Plan.path, planId], getMap());
    return Plan.fromMap(dataMap);
  }
}
