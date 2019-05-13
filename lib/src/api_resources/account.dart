import '../resources/bank_account.dart';
import '../resources/legal_entity.dart';
import '../resources/tos_acceptance.dart';
import '../resources/transfer_schedule.dart';
import '../resources/verification.dart';

import '../api_resource.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

/// [Account](https://stripe.com/docs/api/curl#account)
class Account extends ApiResource {
  String get id => resourceMap['id'];

  final String object = 'account';

  static String pathSingle = 'account';

  static String pathMultiple = 'accounts';

  bool get chargesEnabled => resourceMap['charges_enabled'];

  String get country => resourceMap['country'];

  List<String> get currenciesSupported => resourceMap['currencies_supported'];

  String get defaultCurrency => resourceMap['default_currency'];

  bool get detailsSubmitted => resourceMap['details_submitted'];

  bool get transfersEnabled => resourceMap['transfers_enabled'];

  String get displayName => resourceMap['display_name'];

  String get email => resourceMap['email'];

  String get statementDescriptor => resourceMap['statement_descriptor'];

  String get timezone => resourceMap['timezone'];

  String get businessName => resourceMap['business_name'];

  String get businessUrl => resourceMap['business_url'];

  Map<String, String> get metadata => resourceMap['metadata'];

  String get supportPhone => resourceMap['support_phone'];

  bool get managed => resourceMap['managed'];

  BankAccountCollection get bankAccounts {
    Map value = resourceMap['bank_accounts'];
    assert(value != null);
    return  BankAccountCollection.fromMap(value);
  }

  bool get debitNegativeBalances => resourceMap['debit_negative_balances'];

  LegalEntity get legalEntity {
    var value = resourceMap['legal_entity'];
    if (value == null)
      return null;
    else
      return  LegalEntity.fromMap(value);
  }

  String get productDescription => resourceMap['product_description'];

  TosAcceptance get tosAcceptance {
    var value = resourceMap['tos_acceptance'];
    if (value == null)
      return null;
    else
      return  TosAcceptance.fromMap(value);
  }

  TransferSchedule get transferSchedule {
    var value = resourceMap['transfer_schedule'];
    if (value == null)
      return null;
    else
      return  TransferSchedule.fromMap(value);
  }

  Verification get verification {
    var value = resourceMap['verification'];
    if (value == null)
      return null;
    else
      return  Verification.fromMap(value);
  }

  Map get keys => resourceMap['keys'];

  Account.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve account details](https://stripe.com/docs/api/curl#retrieve_account)
  static Future<Account> retrieve({String accountId}) async {
    var parameters = [Account.pathSingle];
    if (accountId != null) parameters.add(accountId);
    var dataMap = await StripeService.retrieve(parameters);
    return  Account.fromMap(dataMap);
  }

  /// [List all connected accounts](https://stripe.com/docs/api/curl#list_accounts)
  static Future<AccountCollection> list(
      {int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (data == {}) data = null;
    var dataMap = await StripeService.list([Account.pathMultiple], data: data);
    return  AccountCollection.fromMap(dataMap);
  }
}

/// [Create an account](https://stripe.com/docs/api/curl#create_account)
class AccountCreation extends ResourceRequest {
  set managed(String managed) => setMap('managed', managed);

  set country(String country) => setMap('country', country);

  set email(String email) => setMap('email', email);

  set businessName(String businessName) =>
      setMap('business_name', businessName);

  set businessUrl(String businessUrl) => setMap('business_url', businessUrl);

  set supportPhone(String supportPhone) =>
      setMap('support_phone', supportPhone);

  set bankAccount(BankAccount bankAccount) =>
      setMap('bank_account', bankAccount);

  set debitNegativeBalances(bool debitNegativeBalances) =>
      setMap('debit_negative_balances', debitNegativeBalances);

  set defaultCurrency(String defaultCurrency) =>
      setMap('default_currency', defaultCurrency);

  set legalEntity(LegalEntity legalEntity) =>
      setMap('legal_entity', legalEntity);

  set productDescription(String productDescription) =>
      setMap('product_description', productDescription);

  set statementDescriptor(String statementDescriptor) =>
      setMap('statement_descriptor', statementDescriptor);

  set tosAcceptance(TosAcceptance tosAcceptance) =>
      setMap('tos_acceptance', tosAcceptance);

  set transferSchedule(TransferSchedule transferSchedule) =>
      setMap('transfer_schedule', transferSchedule);

  set metadata(Map metadata) => setMap('metadata', metadata);

  Future<Account> create() async {
    var dataMap = await StripeService.create([Account.pathMultiple], getMap());
    return  Account.fromMap(dataMap);
  }
}

/// [Update an account](https://stripe.com/docs/api/curl#update_account)
class AccountUpdate extends ResourceRequest {
  set businessName(String businessName) =>
      setMap('business_name', businessName);

  set businessUrl(String businessUrl) => setMap('business_url', businessUrl);

  set supportPhone(String supportPhone) =>
      setMap('support_phone', supportPhone);

  set bankAccount(BankAccount bankAccount) =>
      setMap('bank_account', bankAccount.toMap());

  set debitNegativeBalances(bool debitNegativeBalances) =>
      setMap('debit_negative_balances', debitNegativeBalances);

  set defaultCurrency(String defaultCurrency) =>
      setMap('default_currency', defaultCurrency);

  set email(String email) => setMap('email', email);

  set legalEntity(LegalEntity legalEntity) =>
      setMap('legal_entity', legalEntity);

  set productDescription(String productDescription) =>
      setMap('product_description', productDescription);

  set statementDescriptor(String statementDescriptor) =>
      setMap('statement_descriptor', statementDescriptor);

  set tosAcceptance(TosAcceptance tosAcceptance) =>
      setMap('tos_acceptance', tosAcceptance);

  set transferSchedule(TransferSchedule transferSchedule) =>
      setMap('transfer_schedule', transferSchedule);

  set metadata(Map metadata) => setMap('metadata', metadata);

  Future<Account> update(String accountId) async {
    var dataMap =
        await StripeService.update([Account.pathMultiple, accountId], getMap());
    return  Account.fromMap(dataMap);
  }
}

class AccountCollection extends ResourceCollection {
  Account getInstanceFromMap(map) =>  Account.fromMap(map);

  AccountCollection.fromMap(Map map) : super.fromMap(map);
}
