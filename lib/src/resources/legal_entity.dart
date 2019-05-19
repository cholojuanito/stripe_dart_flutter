import '../resource.dart';
import 'address.dart';
import 'date.dart';
import 'verification.dart';

/// Base class for [Individual] and [Company].
///
/// This class is simply here to make it so I don't have to duplicate code.
///
/// The only attributes that [Individual] and [Company] share
/// are addresses and phone number.
///
/// **This class should not be used to create an [Account].**
/// You should instead *use either [Individual] or [Company]* depending on
/// what Account.businessType is set to.
class LegalEntity extends Resource {
  /// The primary address of the  [Individual] or [Company].
  Address get address => Address.fromMap(resourceMap['address']);
  // TODO add address_kana and address_kanji

  /// The phone number of the [Individual] or [Company].
  ///
  /// Used for verification if they are a [Company].
  String get phone => resourceMap['phone'];

  // ! Deprecated
  // List<AdditionalOwner> get additionalOwners {
  //   var list = [];
  //   if (!resourceMap.containsKey('additional_owners') ||
  //       !(resourceMap['additional_owners'] is List)) return null;
  //   for (Map value in resourceMap['additional_owners']) {
  //     list.add(AdditionalOwner.fromMap(value));
  //   }
  //   return list;
  // }

  LegalEntity.fromMap(Map dataMap) : super.fromMap(dataMap);
}

/// A [Company] that is tied to an [Account]
///
/// Contains information about the company or business.
/// **This will be null for an [Account] unless Account.businessType is set to 'company'.**
class Company extends LegalEntity {
  // Attributes

  /// Whether the company’s directors have been provided.
  ///
  /// This will be true if you’ve manually indicated that all directors are provided via the directors_provided parameter using [the Persons API](https://stripe.com/docs/api/persons).
  bool get directorsProvided => resourceMap['directors_provided'];

  /// The company’s legal name.
  String get name => resourceMap['name'];
// TODO add kana and kanji support

  /// Whether the company’s owners have been provided.
  ///
  /// This will be true if you’ve manually indicated that all owners are provided via the owners_provided parameter using [the Persons API](https://stripe.com/docs/api/persons) ,
  /// or if Stripe determined that all owners were provided. Stripe determines ownership requirements using both
  /// the number of owners provided and their total percent ownership (calculated by adding the percent_ownership of each owner together).
  bool get ownersProvided => resourceMap['owners_provided'];

  /// Whether the company’s business ID number was provided.
  bool get taxIdProvided => resourceMap['tax_id_provided'];

  /// **Germany-based companies only**
  ///
  /// The jurisdiction in which the [taxId] is registered.
  String get taxIdRegistrar => resourceMap['tax_id_registrar'];

  /// Whether the company’s business VAT number was provided.
  bool get vatidProvided => resourceMap['vat_id_provided'];

  Company.fromMap(Map dataMap) : super.fromMap(dataMap);
}

/// An [Individual] that is tied to an [Account]
///
/// Contains information about the person represented by the account.
/// **This will be null for an [Acccount] unless Account.businessType is set to 'individual'.**
class Individual extends LegalEntity {
  final String object = 'person';

// Attributes

  /// The id either given by Stripe or created by your program
  String get id => resourceMap['id'];

  /// The id of account the individual is associated with.
  String get accountId => resourceMap['account'];

  /// Time at which the object was created. Measured in seconds since the Unix epoch.
  DateTime get created => resourceMap['created'];

  /// The individual’s date of birth.
  Date get dateOfBirth => Date.fromMap(resourceMap['dob']);

  /// The individual’s email address.
  String get email => resourceMap['email'];

  /// The individual’s first name.
  String get firstName => resourceMap['first_name'];
  // TODO add kana and kanji

  /// The individual’s gender
  ///
  /// **(International regulations require either “male” or “female”).**
  String get gender => resourceMap['gender'];

  /// The government-issued ID number of the individual, as appropriate for the representative’s country.
  /// (Examples are a Social Security Number in the U.S., or a Social Insurance Number in Canada).
  ///
  /// Instead of the number itself, you can also provide a PII token created with Stripe.js.
  ///
  /// **This will be unset if you POST an empty value.**
  // TODO maybe split this into an IndividualCreation class?
  String get idNumber => resourceMap['id_number'];

  /// Whether the individual’s personal ID number was provided.
  bool get idNumberProvided => resourceMap['id_number_provided'];

  /// The individual’s last name.
  String get lastName => resourceMap['last_name'];
// TODO add kana and kanji

  /// The individual’s maiden name.
  String get maidenName => resourceMap['maiden_name'];

  /// Set of key-value pairs that you can attach to an object.
  /// This can be useful for storing additional information about the object in a structured format.
  Map<String, dynamic> get metadata => resourceMap['metadata'];

  // TODO implement AccountRelationship

  // TODO implement Requirements

  /// The last four digits of the individual’s Social Security Number (U.S. only).
  ///
  /// This will be unset if you POST an empty value.
// TODO maybe split this into an IndividualCreation class?
  String get ssnLast4 => resourceMap['ssn_last_4'];

  /// Whether the individual’s last 4 SSN digits was provided.
  bool get ssnLast4Provided => resourceMap['ssn_last_4_provided'];

// The individual’s verification status.
  Verification get verification =>
      Verification.fromMap(resourceMap['verification']);

  Individual.fromMap(Map dataMap) : super.fromMap(dataMap);
}
