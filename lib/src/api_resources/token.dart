import '../api_resource.dart';
import '../resource.dart';
import '../service.dart';

import '../resources/bank_account.dart';

import 'card.dart';
import 'customer.dart';

/// [Tokens](https://stripe.com/docs/api/curl#tokens)
class Token extends ApiResource {
  String get id => resourceMap['id'];

  final String object = 'token';

  static var path = 'tokens';

  bool get livemode => resourceMap['livemode'];

  DateTime get created => getDateTimeFromMap('created');

  String get type => resourceMap['type'];

  bool get used => resourceMap['used'];

  BankAccount get bankAccount {
    var value = resourceMap['bank_account'];
    if (value == null)
      return null;
    else
      return BankAccount.fromMap(value);
  }

  Card get card {
    var value = resourceMap['card'];
    if (value == null)
      return null;
    else
      return Card.fromMap(value);
  }

  Token.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieving a Token](https://stripe.com/docs/api/curl#retrieve_token)
  static Future<Token> retrieve(String tokenId) async {
    var dataMap = await StripeService.retrieve([Token.path, tokenId]);
    return Token.fromMap(dataMap);
  }
}

/// [Creating a Card Token](https://stripe.com/docs/api/curl#create_card_token)
class CardTokenCreation extends ResourceRequest {
  set card(CardCreation card) => setMap('card', card);

  set customer(CustomerCreation customer) => setMap('customer', customer);

  Future<Token> create() async {
    var dataMap = await StripeService.create([Token.path], getMap());
    return Token.fromMap(dataMap);
  }
}

/// [Creating a Bank Account Token](https://stripe.com/docs/api/curl#create_bank_account_token)
class BankAccountTokenCreation extends ResourceRequest {
  set bankAccount(BankAccount bankAccount) =>
      setMap('bank_account', bankAccount.toMap());

  Future<Token> create() async {
    var dataMap = await StripeService.create([Token.path], getMap());
    return Token.fromMap(dataMap);
  }
}
