part of stripe;

class CardCollection extends ResourceCollection {

  Card _getInstanceFromMap(map) => new Card.fromMap(map);

  CardCollection.fromMap(Map map) : super.fromMap(map);

}