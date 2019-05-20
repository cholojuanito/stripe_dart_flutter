import '../exceptions.dart';
import '../resources/address.dart';
import '../resources/bank_account.dart';
import '../resources/legal_entity.dart';
import '../resources/tos_acceptance.dart';

import '../api_resource.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

/// [Account]
/// https://stripe.com/docs/api/accounts/object
///
/// This is an object representing a Stripe account.
/// You can retrieve it to see properties on the account like its current e-mail address or if the account is enabled yet to make live charges.
///
/// Some properties, marked below, are available only to platforms that want to create and manage [Express] or [Custom] accounts.
class Account extends ApiResource {
  static String path = 'accounts';

  final String object = 'account';

// Attributes

  /// The id either given by Stripe or created by your program
  String get id => resourceMap['id'];

  /// Optional information related to the business.
  BusinessProfile get businessProfile =>
      BusinessProfile.fromMap(resourceMap['business_profile']);

  /// The business type.
  ///
  /// One of:
  /// * individual
  /// * company
  String get businessType => resourceMap['business_type'];

  /// [Capabilities]
  /// https://stripe.com/docs/api/capabilities/object
  ///
  /// This is an object representing a capability for a Stripe account.
  ///
  /// A hash containing the set of capabilities that was requested for this account and their associated states.
  ///
  /// Keys may the following:
  /// * account
  /// *card_issuing
  /// *card_payments
  /// * cross_border_payouts_recipient
  /// * giropay
  /// * ideal
  /// * klarna
  /// * legacy_payments
  /// * masterpass
  /// * payouts
  /// * platform_payments
  /// * sofort
  /// * visa_checkout.
  ///
  /// Values will be one of the following:
  /// * active
  /// * inactive
  /// * pending
  Capabilities get capabilities =>
      Capabilities.fromMap(resourceMap['capabilities']);

  /// Whether the account can create live charges.
  bool get chargesEnabled => resourceMap['charges_enabled'];

  /// [Custom] accounts only
  ///
  /// Information about the company or business.
  /// **This field is null unless [businessType] is set to company.**
  Company get company => resourceMap['company'];

  /// The account’s country.
  String get country => resourceMap['country'];

  /// [Custom] and [Express] accounts only
  ///
  /// Time at which the object was created. Measured in seconds since the Unix epoch.
  DateTime get created => getDateTimeFromMap('created');

  /// Three-letter ISO currency code representing the default currency for the account.
  /// This must be a currency that [Stripe supports in the account’s country.](https://stripe.com/docs/payouts)
  String get defaultCurrency => resourceMap['default_currency'];

  /// Whether account details have been submitted.
  /// **Standard accounts cannot receive payouts before this is true.**
  bool get detailsSubmitted => resourceMap['details_submitted'];

  /// The primary user’s email address.
  String get email => resourceMap['email'];

  /// External accounts (bank accounts and debit cards) currently attached to this account
  // TODO make ExternalAccount/Collection object OR use BankAccount below
  // ? This might be the externalAccounts
  BankAccountCollection get bankAccounts {
    Map value = resourceMap['bank_accounts'];
    assert(value != null);
    return BankAccountCollection.fromMap(value);
  }

  /// [Custom] accounts only
  ///
  /// Information about the person represented by the account.
  /// **This field is null unless [businessType] is set to individual.**
  Individual get individual => resourceMap['individual'];

  /// Set of key-value pairs that you can attach to an object.
  /// This can be useful for storing additional information about the object in a structured format.
  Map<String, dynamic> get metadata => resourceMap['metadata'];

  /// Whether Stripe can send payouts to this account.
  bool get payoutsEnabled => resourceMap['payouts_enabled'];

  /// Information about the requirements for the account, including what information needs to be collected, and by when.
  Requirements get requirements =>
      Requirements.fromMap(resourceMap['requirements']);

  /// Account options for customizing how the account functions within Stripe.
  //TODO make an AccountSettings class

  /// Details [on the acceptance of the Stripe Services Agreement](https://stripe.com/docs/connect/updating-accounts#tos-acceptance)
  TosAcceptance get tosAcceptance =>
      TosAcceptance.fromMap(resourceMap['tos_acceptance']);

  /// The Stripe account type.
  ///
  /// One of:
  /// * standard
  /// * express
  /// * custom
  String get type => resourceMap['type'];

  Account.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve account details](https://stripe.com/docs/api/accounts/retrieve)
  ///
  /// Retrieves the details of an account.
  ///
  /// **If [accountId] is not provided, the account associated with the API key is returned.**
  static Future<Account> retrieve({String accountId}) async {
    var parameters = [Account.path];
    if (accountId != null) parameters.add(accountId);
    var dataMap = await retrieveResource(parameters);
    return Account.fromMap(dataMap);
  }

  /// [List all connected accounts](https://stripe.com/docs/api/accounts/list)
  ///
  /// Returns a list of accounts connected to your platform via [Connect].
  /// If your app is not a platform, the list is empty.
  static Future<AccountCollection> list(
      {var created,
      String endingBefore,
      int limit,
      String startingAfter}) async {
    var data = {};
    if (created != null) data['created'] = created;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (data == {}) data = null;
    var dataMap = await listResource([Account.path], data: data);
    return AccountCollection.fromMap(dataMap);
  }
}

/// [Create an account](https://stripe.com/docs/api/accounts/create)
///
/// With Connect, you can create Stripe accounts for your users.
/// To do this, you’ll first need to register your platform.
///
/// For Standard accounts, parameters other than country, email, and type are used to prefill the account application that we ask the account holder to complete.
class AccountCreation extends ResourceRequest {
  AccountCreation() {
    setRequiredFields('type');
    setRequiredFields('requested_capabilities');
  }

  /// The type of Stripe account to create.
  ///
  /// **Currently must be 'custom', as only Custom accounts may be created via the API.**
  set type(String type) => setMap('type', type);

  // Account token

  set businessProfile(BusinessProfile profile) =>
      setMap('business_profile', profile.toMap());

  set businessType(String type) => setMap('business_type', type);

  /// The country in which the account holder resides, or in which the business is legally established. This should be an ISO 3166-1 alpha-2 country code.
  ///
  /// For example, if you are in the United States and the business for which you’re creating an account is legally represented in Canada, you would use 'CA' as the country for the account being created.
  set country(String country) => setMap('country', country);

  /// Should only be used if the Account.businessType is set to 'company'
  set company(Company company) => setMap('company', company.toMap());

  set defaultCurrency(String defaultCurrency) =>
      setMap('default_currency', defaultCurrency);

  set email(String email) => setMap('email', email);

  // TODO ExternalAccounts

  /// Should only be used if the Account.businessType is set to 'individual'
  set individual(Individual individual) =>
      setMap('individual', individual.toMap());

  set metadata(Map metadata) => setMap('metadata', metadata);

  /// The set of capabilities you want to unlock for this account **(US only)**.
  /// Each capability will be inactive until you have provided its specific requirements and Stripe has verified them.
  ///
  /// An account may have some of its requested capabilities be active and some be inactive.
  ///
  /// **This will be unset if you POST an empty value.**
  ///
  /// **You must include one of the following when creating a Custom account:**
  /// * 'card_payments'
  /// * 'legacy_payments'
  /// * 'platform_payments'
  set requestedCapabilities(List<dynamic> capabilities) {
    capabilities.cast<String>();
    if (capabilities.contains('card_payments') ||
        capabilities.contains('legacy_payments') ||
        capabilities.contains('platform_payments')) {
      setMap('requested_capabilities', capabilities);
    } else {
      throw MissingRequiredAttributeException(
          'one of the following: card_payments, legacy_payments, platform_payments',
          'requestedCapabilites in AccountCreation');
    }
  }

  // TODO AccountSettings

  set tosAcceptance(TosAcceptance tosAcceptance) =>
      setMap('tos_acceptance', tosAcceptance.toMap());

  Future<Account> create() async {
    var dataMap = await createResource([Account.path], getMap());
    return Account.fromMap(dataMap);
  }
}

/// [Update an account](https://stripe.com/docs/api/accounts/update)
///
/// Updates a connected Express or Custom account by setting the values of the parameters passed.
/// Any parameters not provided are left unchanged.
///
/// **Most parameters can be changed only for Custom accounts. (These are marked Custom Only below.)**
///
/// **Parameters marked Custom and Express are supported by both account types.**
///
/// To update your own account, use the Dashboard.
/// Refer to the Stripe [Connect documentation](https://stripe.com/docs/connect/updating-accounts) to learn more about updating accounts.
class AccountUpdate extends ResourceRequest {
  // TODO account token

  /// Custom and Express
  set businessProfile(BusinessProfile profile) =>
      setMap('business_profile', profile.toMap());

  /// Custom only
  set businessType(String type) => setMap('business_type', type);

  /// Should only be used if the Account.businessType is set to 'company'
  set company(Company company) => setMap('company', company.toMap());

  /// Custom only
  set defaultCurrency(String defaultCurrency) =>
      setMap('default_currency', defaultCurrency);

  /// Custom only
  set email(String email) => setMap('email', email);

  // TODO ExternalAccount

  /// Should only be used if the Account.businessType is set to 'individual'
  set individual(Individual individual) =>
      setMap('individual', individual.toMap());

  /// Custom and Express
  set metadata(Map metadata) => setMap('metadata', metadata);

  /// Custom and Express
  ///
  /// The set of capabilities you want to unlock for this account (US only). Each capability will be inactive until you have provided its specific requirements and Stripe has verified them.
  /// An account may have some of its requested capabilities be active and some be inactive.
  ///
  /// **This will be unset if you POST an empty value.**
  set requestedCapabilities(Capabilities abilities) =>
      setMap('capabilities', abilities.toMap());

  /// Custom and Express
  // TODO AccountSettings

  /// Custom only
  set tosAcceptance(TosAcceptance tosAcceptance) =>
      setMap('tos_acceptance', tosAcceptance);

  Future<Account> update(String accountId) async {
    var dataMap = await updateResource([Account.path, accountId], getMap());
    return Account.fromMap(dataMap);
  }
}

class AccountCollection extends ResourceCollection {
  Account getInstanceFromMap(map) => Account.fromMap(map);

  AccountCollection.fromMap(Map map) : super.fromMap(map);
}

/// Helper classes
class BusinessProfile extends Resource {
  String get mcc => resourceMap['mcc'];

  String get name => resourceMap['name'];

  String get productDescription => resourceMap['product_description'];

  Address get supportAddress => resourceMap['support_address'];

  String get supportEmail => resourceMap['support_email'];

  String get supportPhone => resourceMap['support_phone'];

  String get supportURL => resourceMap['support_url'];

  String get businessURL => resourceMap['url'];

  BusinessProfile.fromMap(Map dataMap) : super.fromMap(dataMap);
}

/// [Capabilities]
/// https://stripe.com/docs/api/capabilities/object
///
/// This is an object representing a capability for a Stripe account.
///
/// A hash containing the set of capabilities that was requested for this account and their associated states.
///
/// Keys may the following:
/// * account
/// *card_issuing
/// *card_payments
/// * cross_border_payouts_recipient
/// * giropay
/// * ideal
/// * klarna
/// * legacy_payments
/// * masterpass
/// * payouts
/// * platform_payments
/// * sofort
/// * visa_checkout.
///
/// Values will be one of the following:
/// * active
/// * inactive
/// * pending

// TODO Expand this following https://stripe.com/docs/api/capabilities/object
class Capabilities extends Resource {
  String get account => resourceMap['account'];

  String get cardIssuing => resourceMap['card_issuing'];

  String get cardPayments => resourceMap['card_payments'];

  String get crossBorderPayoutsRecipient =>
      resourceMap['cross_border_payouts_recipient'];

  String get giropay => resourceMap['giropay'];

  String get ideal => resourceMap['ideal'];

  String get klarna => resourceMap['klarna'];

  String get legacyPayments => resourceMap['legacy_payments'];

  String get masterpass => resourceMap['masterpass'];

  String get payouts => resourceMap['payouts'];

  String get platformPayments => resourceMap['platform_payments'];

  String get sofort => resourceMap['sofort'];

  String get visaCheckout => resourceMap['visa_checkout'];

  Capabilities.fromMap(dataMap) : super.fromMap(dataMap);
}

/// Information about the requirements for the account, including what information needs to be collected, and by when.
class Requirements extends Resource {
  /// The date the fields in [currentlyDue] must be collected by to keep payouts enabled for the account.
  /// These fields might block payouts sooner if the next threshold is reached before these fields are collected.
  DateTime get currentDeadline => getDateTimeFromMap('current_deadline');

  /// The fields that need to be collected to keep the account enabled.
  /// If not collected by the [currentDeadline], these fields appear in [pastDue] as well, and the account is disabled.
  List<String> get currentlyDue =>
      List<String>.from(resourceMap['currently_due']);

  /// If the account is disabled.
  /// This string describes why the account can’t create charges or receive payouts.
  /// Can be one of the following:
  /// * requirements.past_due,
  ///* requirements.pending_verification
  ///* rejected.fraud
  ///* rejected.terms_of_service
  ///* rejected.listed
  ///* rejected.other
  ///* listed
  ///* under_review
  ///* other
  String get disabledReason => resourceMap['disabled_reason'];

  /// The fields that need to be collected assuming all volume thresholds are reached.
  /// As they become required, these fields appear in [currentlyDue] as well, and the [currentDeadline] is set.
  List<String> get eventuallyDue =>
      List<String>.from(resourceMap['eventually_due']);

  /// The fields that weren’t collected by the [currentDeadline]. These fields need to be collected to re-enable the account.
  List<String> get pastDue => List<String>.from(resourceMap['past_due']);

  Requirements.fromMap(Map resourceMap) : super.fromMap(resourceMap);
}
