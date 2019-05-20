import '../api_resource.dart';
import '../resource_collection.dart';
import '../service.dart';

/// [Event](https://stripe.com/docs/api/curl#events)
class Event extends ApiResource {
  String get id => resourceMap['id'];

  final String object = 'event';

  static var path = 'events';

  bool get livemode => resourceMap['livemode'];

  DateTime get created => getDateTimeFromMap('created');

  EventData get data {
    var value = resourceMap['data'];
    if (value == null)
      return null;
    else
      return EventData.fromMap(value);
  }

  int get pendingWebhooks => resourceMap['pending_webhooks'];

  String get type => resourceMap['type'];

  String get request => resourceMap['request'];

  Event.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve an event](https://stripe.com/docs/api/curl#retrieve_event)
  static Future<Event> retrieve(String eventId) async {
    var dataMap = await retrieveResource([Event.path, eventId]);
    return Event.fromMap(dataMap);
  }

  /// [List all events](https://stripe.com/docs/api/curl#list_events)
  /// TODO: implement missing argument: `created`
  static Future<EventCollection> list(
      {int limit,
      String startingAfter,
      String endingBefore,
      String type}) async {
    var data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (type != null) data['type'] = type;
    if (data == {}) data = null;
    var dataMap = await listResource([Event.path], data: data);
    return EventCollection.fromMap(dataMap);
  }
}

class EventCollection extends ResourceCollection {
  Event getInstanceFromMap(map) => Event.fromMap(map);

  EventCollection.fromMap(Map map) : super.fromMap(map);
}

class EventData {
  Map resourceMap;

  Map get object => resourceMap['object'];

  Map get previousAttribute => resourceMap['previous_attribute'];

  EventData.fromMap(this.resourceMap);
}
