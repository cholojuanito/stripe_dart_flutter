import '../api_resource.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

/// [Payouts](https://stripe.com/docs/api/curl#payouts)
class Payout extends ApiResource {
  String get id => resourceMap['id'];

  final String object = 'payout';

  static var path = 'payouts';

  int get amount => resourceMap['amount'];

  DateTime get arrivalDate => resourceMap['arrival_date'];

  bool get automatic => resourceMap['automatic'];

  String get balanceTransaction => resourceMap['balance_transaction'];

  DateTime get created => getDateTimeFromMap('created');

  String get currency => resourceMap['currency'];

  String get description => resourceMap['description'];

  String get destination => getIdForExpandable('destination');

  String get failureBalanceTransaction =>
      getIdForExpandable('failure_balance_transaction');

  String get failureCode => resourceMap['failure_code'];

  String get failureMessage => resourceMap['failure_message'];

  bool get livemode => resourceMap['livemode'];

  Map<String, dynamic> get metadata => resourceMap['metadata'];

  String get method => resourceMap['method'];

  String get sourceType => resourceMap['source_type'];

  String get statementDescriptor => resourceMap['statement_descriptor'];

  String get status => resourceMap['status'];

  String get type => resourceMap['type'];

  Payout.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieving a Payout](https://stripe.com/docs/api/curl#retrieve_payout)
  static Future<Payout> retrieve(String id) async {
    var dataMap = await retrieveResource([Payout.path, id]);
    return Payout.fromMap(dataMap);
  }

  /// [Canceling a Payout](https://stripe.com/docs/api/curl#cancel_payout)
  static Future<Payout> cancel(String payoutId) async {
    var dataMap = await postResource([Payout.path, payoutId, 'cancel']);
    return Payout.fromMap(dataMap);
  }

  /// [List all Payouts](https://stripe.com/docs/api/curl#list_payouts)
  static Future<PayoutCollection> list(
      {int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap = await listResource([Payout.path], data: data);
    return PayoutCollection.fromMap(dataMap);
  }
}

class PayoutCollection extends ResourceCollection {
  Payout getInstanceFromMap(map) => Payout.fromMap(map);

  PayoutCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Creating Payouts](https://stripe.com/docs/api/curl#create_payout)
class PayoutCreation extends ResourceRequest {
  PayoutCreation() {
    setMap('object', 'Payout');
    setRequiredFields('id');
    setRequiredFields('amount');
    setRequiredFields('currency');
    setRequiredFields('name');
  }

  // //@required
  set id(String id) => setMap('id', id);

  // //@required
  set amount(int amount) => setMap('amount', amount);

  set description(String description) => setMap('description', description);

  set destination(String destination) => setMap('destination', destination);

  set method(String method) => setMap('method', method);

  set metadata(Map metadata) => setMap('metadata', metadata);

  set sourceType(String sourceType) => setMap('source_type', sourceType);

  set statementDescriptor(String statementDescriptor) =>
      setMap('statement_descriptor', statementDescriptor);

  Future<Payout> create() async {
    var dataMap = await createResource([Payout.path], getMap());
    return Payout.fromMap(dataMap);
  }
}

/// [Updating a Payout](https://stripe.com/docs/api/curl#update_payout)
class PayoutUpdate extends ResourceRequest {
  set payout(String id) => setMap('id', id);

  set metadata(Map metadata) => setMap('metadata', metadata);

  Future<Payout> update(String payoutId) async {
    var dataMap = await updateResource([Payout.path, payoutId], getMap());
    return Payout.fromMap(dataMap);
  }
}
