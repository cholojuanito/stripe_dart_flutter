import 'package:stripe/src/exceptions.dart';

import '../api_resource.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

import 'customer.dart';

/// Interface representing a Stripe source (e.g. CardCreation, CardCreationWithToken)
abstract class SourceCreation {}

/// [Card](https://stripe.com/docs/api/curl#cards)
class Card extends ApiResource {
  String get id => resourceMap['id'];

  final String object = 'card';

  static var path = 'cards';

  int get expMonth => resourceMap['exp_month'];

  int get expYear => resourceMap['exp_year'];

  String get fingerprint => resourceMap['fingerprint'];

  String get last4 => resourceMap['last4'];

  String get brand => resourceMap['brand'];

  String get addressCity => resourceMap['address_city'];

  String get addressCountry => resourceMap['address_country'];

  String get addressLine1 => resourceMap['address_line1'];

  String get addressLine1Check => resourceMap['address_line1_check'];

  String get addressLine2 => resourceMap['address_line2'];

  String get addressState => resourceMap['address_state'];

  String get addressZip => resourceMap['address_zip'];

  String get addressZipCheck => resourceMap['address_zip_check'];

  String get country => resourceMap['country'];

  String get customer {
    return this.getIdForExpandable('customer');
  }

  Customer get customerExpand {
    var value = resourceMap['customer'];
    if (value == null)
      return null;
    else
      return Customer.fromMap(value);
  }

  String get cvcCheck => resourceMap['cvc_check'];

  String get name => resourceMap['name'];

  Card.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieving a customer's card](https://stripe.com/docs/api/curl#retrieve_card)
  static Future<Card> retrieve(String customerId, String cardId,
      {final Map data}) async {
    var dataMap = await StripeService.retrieve(
        [Customer.path, customerId, Card.path, cardId],
        data: data);
    return Card.fromMap(dataMap);
  }

  /// [Listing cards](https://stripe.com/docs/api/curl#list_cards)
  static Future<CardCollection> list(String customerId,
      {int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap = await StripeService.list(
        [Customer.path, customerId, Card.path],
        data: data);
    return CardCollection.fromMap(dataMap);
  }

  /// [Deleting cards](https://stripe.com/docs/api/curl#delete_card)
  static Future<Map> delete(String customerId, String cardId) =>
      StripeService.delete([Customer.path, customerId, Card.path, cardId]);
}

class CardCollection extends ResourceCollection {
  Card getInstanceFromMap(map) => Card.fromMap(map);

  CardCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Creating a  card](https://stripe.com/docs/api/curl#create_card)
class CardCreation extends ResourceRequest implements SourceCreation {
  CardCreation() {
    setMap('object', 'card');
    setRequiredSet('number');
    setRequiredSet('exp_month');
    setRequiredSet('exp_year');
    setRequiredSet('cvc');
  }

  //@required
  set number(String number) => setMap('number', number);

  //@required
  set expMonth(int expMonth) => setMap('exp_month', expMonth);

  //@required
  set expYear(int expYear) => setMap('exp_year', expYear);

  //@required
  set cvc(int cvc) => setMap('cvc', cvc);

  set name(String name) => setMap('name', name);

  set addressLine1(String addressLine1) =>
      setMap('address_line1', addressLine1);

  set addressLine2(String addressLine2) =>
      setMap('address_line2', addressLine2);

  set addressCity(String addressCity) => setMap('address_city', addressCity);

  set addressZip(String addressZip) => setMap('address_zip', addressZip);

  set addressState(String addressState) =>
      setMap('address_state', addressState);

  set addressCountry(String addressCountry) =>
      setMap('address_country', addressCountry);

  Future<Card> create(String customerId) async {
    var dataMap = await StripeService.create(
        [Customer.path, customerId, Card.path], {'card': getMap()});
    return Card.fromMap(dataMap);
  }

  // @override
  // getMap() {
  //   // TODO: implement getMap
  //   if (map[setter] == null) {
  //     error(setter, "CardCreation");
  //   }

  //   return super.getMap();
  // }

}

/// [Creating a  card](https://stripe.com/docs/api/curl#create_card)
class CardCreationWithToken extends ResourceRequest implements SourceCreation {
  //@required
  set token(String token) {
    setMap('token', token);
  }

  getMap() {
    return super.getMap()['token'];
  }

  Future<Card> create(String customerId) async {
    var dataMap = await StripeService.create(
        [Customer.path, customerId, Card.path], {'source': getMap()});
    return Card.fromMap(dataMap);
  }
}

/// [Updating a card](https://stripe.com/docs/api/curl#update_card)
class CardUpdate extends ResourceRequest {
  set addressCity(String addressCity) => setMap('address_city', addressCity);

  set addressCountry(String addressCountry) =>
      setMap('address_country', addressCountry);

  set addressLine1(String addressLine1) =>
      setMap('address_line1', addressLine1);

  set addressLine2(String addressLine2) =>
      setMap('address_line2', addressLine2);

  set addressState(String addressState) =>
      setMap('address_state', addressState);

  set addressZip(String addressZip) => setMap('address_zip', addressZip);

  set expMonth(int expMonth) => setMap('exp_month', expMonth);

  set expYear(int expYear) => setMap('exp_year', expYear);

  set name(String name) => setMap('name', name);

  Future<Card> update(String customerId, String cardId) async {
    var dataMap = await StripeService.update(
        [Customer.path, customerId, Card.path, cardId], getMap());
    return Card.fromMap(dataMap);
  }
}
