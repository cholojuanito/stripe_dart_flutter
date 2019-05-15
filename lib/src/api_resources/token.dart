import '../api_resource.dart';
import '../resource.dart';
import '../service.dart';

import '../resources/bank_account.dart';

import 'account.dart';
import 'card.dart';
import 'customer.dart';

/// [Tokens]
/// https://stripe.com/docs/api/tokens/object
/// Tokenization is the process Stripe uses to collect sensitive card or bank account details, or personally identifiable information (PII), directly from your customers in a secure manner.
/// A token representing this information is returned to your server/platform to use.
/// This ensures that no sensitive card data touches your server, and allows your integration to operate in a PCI-compliant way.
///
/// If you cannot use client-side tokenization, you can also create tokens using the API with either your publishable or secret API key.
/// Keep in mind that if your integration uses this method, you are responsible for any PCI compliance that may be required, and you must keep your secret API key safe. Unlike with client-side tokenization, your customer's information is not sent directly to Stripe, so we cannot determine how it is handled or stored.
///
/// Tokens cannot be stored or used more than once.
/// To store card or bank account information for later use, you can create [Customer] objects or Custom accounts.
/// * Note that Radar, Stripe's integrated solution for automatic fraud protection, supports only integrations that use client-side tokenization.
class Token extends ApiResource {
  static String path = 'tokens';

  final String object = 'token';

  // Attributes

  /// The id either given by Stripe or created by your program
  String get id => resourceMap['id'];

  /// Bank account associated with the token
  /// * This depends on the 'type' field
  BankAccount get bankAccount {
    var value = resourceMap['bank_account'];
    if (value == null)
      return null;
    else
      return BankAccount.fromMap(value);
  }

  /// Card associated with the token
  /// * This depends on the 'type' field
  Card get card {
    var value = resourceMap['card'];
    if (value == null)
      return null;
    else
      return Card.fromMap(value);
  }

  /// IP address of the client that generated the token
  String get clientIp => resourceMap['client_ip'];

  /// Time at which the object was created. Measured in seconds since the Unix epoch
  DateTime get created => getDateTimeFromMap('created');

  /// Has the value [true] if the object exists in live mode or
  /// the value [false] if the object exists in test mode
  bool get livemode => resourceMap['livemode'];

  /// Will be one of the following:
  ///  * account
  ///  * bank_account
  ///  * card
  ///  * pii
  String get type => resourceMap['type'];

  /// Whether this token has already been used (tokens can be used only once)
  bool get used => resourceMap['used'];

  Token.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieving a Token]
  /// https://stripe.com/docs/api/tokens/retrieve
  static Future<Token> retrieve(String tokenId) async {
    var dataMap = await retrieveResource([Token.path, tokenId]);
    return Token.fromMap(dataMap);
  }
}

/// [Creating a Card Token]
/// https://stripe.com/docs/api/tokens/create_card
class CardTokenCreation extends ResourceRequest {
  set card(CardCreation card) => setMap('card', card);

  set customer(CustomerCreation customer) => setMap('customer', customer);

  Future<Token> create() async {
    var dataMap = await createResource([Token.path], getMap());
    return Token.fromMap(dataMap);
  }
}

/// [Creating a Bank Account Token]
/// https://stripe.com/docs/api/tokens/create_bank_account
class BankAccountTokenCreation extends ResourceRequest {
  set bankAccount(BankAccount bankAccount) =>
      setMap('bank_account', bankAccount.toMap());

  /// Only for [Connect] accounts
  /// Also, this can be used only with an OAuth access token or 'Stripe-Account' header
  /// * See https://stripe.com/docs/connect/standard-accounts for OAuth token info
  /// * See https://stripe.com/docs/connect/authentication for 'Stripe-Account' header info
  /// * See https://stripe.com/docs/connect/shared-customers for more info on shared customers
  set customer(Customer customer) => setMap('customer', customer.toMap());

  Future<Token> create() async {
    var dataMap = await createResource([Token.path], getMap());
    return Token.fromMap(dataMap);
  }
}

/// [Creating a PII (personally identifiable information) Token]
/// https://stripe.com/docs/api/tokens/create_pii
class PIITokenCreation extends ResourceRequest {
  PIITokenCreation() {
    setMap('object', 'token');
    setRequiredFields('pii');
  }

  // TODO Make a PII resource
}

/// [Creating a Account Token]
/// https://stripe.com/docs/api/tokens/create_account
/// * Only available for [Connect] accounts
/// See https://stripe.com/docs/connect/account-tokens for more info on account tokens
class AccountTokenCreation extends ResourceRequest {
  AccountTokenCreation() {
    setMap('object', 'token');
    setRequiredFields('account');
  }

  set account(Account account) => setMap('account', account.toMap());

  Future<Token> create() async {
    var dataMap = await createResource([Token.path], getMap());
    return Token.fromMap(dataMap);
  }
}
