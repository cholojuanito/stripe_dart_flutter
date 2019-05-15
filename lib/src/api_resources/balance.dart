import '../api_resource.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

import 'card.dart';
import 'charge.dart';

/// [Balance]
/// https://stripe.com/docs/api/balance/balance_object
/// This is an object representing your Stripe balance.
/// You can retrieve it to see the balance currently on your Stripe account.
///
/// You can also retrieve the balance history, which contains a list of transactions that contributed to the balance (charges, payouts, and so forth).
///
/// The available and pending amounts for each currency are broken down further by payment source types.
class Balance extends Resource {
  static String path = 'balance';

  final String object = 'balance';

  // Attributes

  /// Funds that are available to be transferred or paid out, whether automatically by Stripe or explicitly via [Transfer]s or [Payout]s.
  /// The available balance for each currency and payment type can be found in the [source_types] property
  List<Fund> get available {
    List funds = resourceMap['available'];
    assert(funds != null);
    return funds.map((fund) => Fund.fromMap(fund)).toList(growable: false);
  }

  /// Funds held due to negative balances on connected [Custom] accounts.
  /// The connect reserve balance for each currency and payment type can be found in the [source_types] property.
  ///  * Custom (Connect) accounts only
  List<Fund> get connectReserved {
    List funds = resourceMap['connect_reserved'];
    assert(funds != null);
    return funds.map((fund) => Fund.fromMap(fund)).toList(growable: false);
  }

  ///Has the value true if the object exists in live mode or
  ///the value false if the object exists in test mode.
  bool get livemode => resourceMap['livemode'];

  /// Funds that are not yet available in the balance, due to the 7-day rolling pay cycle.
  /// The pending balance for each currency, and for each payment type, can be found in the [source_types] property.
  List<Fund> get pending {
    List funds = resourceMap['pending'];
    assert(funds != null);
    return funds.map((fund) => Fund.fromMap(fund)).toList(growable: false);
  }

  Balance.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve a balance]
  /// https://stripe.com/docs/api/balance/balance_retrieve
  static Future<Balance> retrieve() async {
    var dataMap = await getResource([Balance.path]);
    return Balance.fromMap(dataMap);
  }
}

/// [Balance Transaction]
/// https://stripe.com/docs/api/balance/balance_transaction
class BalanceTransaction extends ApiResource {
  static String path = 'history';

  final String object = 'balance_transaction';

// Attributes

  /// The id either given by Stripe or created by your program
  String get id => resourceMap['id'];

  /// Gross amount of the transaction, in cents.
  int get amount => resourceMap['amount'];

  /// The date the transaction’s net funds will become available in the Stripe balance.
  DateTime get availableOn => getDateTimeFromMap('available_on');

  /// Time at which the object was created. Measured in seconds since the Unix epoch.
  DateTime get created => getDateTimeFromMap('created');

  /// Three-letter ISO currency code, in lowercase. Must be a supported currency.
  /// * See https://stripe.com/docs/currencies for supported currencies
  /// * See https://www.iso.org/iso-4217-currency-codes.html for ISO codes
  String get currency => resourceMap['currency'];

  /// An arbitrary string attached to the object. Often useful for displaying to users.
  String get description => resourceMap['description'];

  ///
  double get exchangeRate => resourceMap['exchange_rate'];

  /// Fees (in cents) paid for this transaction.
  int get fee => resourceMap['fee'];

  /// Detailed breakdown of fees (in cents) paid for this transaction.
  List<FeeDetails> get feeDetails {
    List feeDetails = resourceMap['fee_details'];
    assert(feeDetails != null);
    return feeDetails
        .map((feeDetails) => FeeDetails.fromMap(feeDetails))
        .toList(growable: false);
  }

  /// Net amount of the transaction, in cents.
  int get net => resourceMap['net'];

  /// The id of the Stripe object to which this transaction is related.
  /// Normally it is the [Charge] object
  /// * Expandable
  String get source => this.getIdForExpandable('source');

  Charge get sourceExpand {
    var value = resourceMap['source'];
    if (value == null)
      return null;
    else
      return Charge.fromMap(value);
  }

  /// If the transaction’s net funds are available in the Stripe balance yet.
  /// Will be on of the following:
  /// * available
  /// * pending
  String get status => resourceMap['status'];

  ///  The transaction type
  /// * See https://stripe.com/docs/reporting/balance-transaction-types
  /// * for list of types and what they represent
  String get type => resourceMap['type'];

  BalanceTransaction.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieving a Balance Transaction]
  /// https://stripe.com/docs/api/balance/balance_transaction_retrieve
  static Future<BalanceTransaction> retrieve(String transactionId) async {
    var dataMap = await getResource(
        [Balance.path, BalanceTransaction.path, transactionId]);
    return BalanceTransaction.fromMap(dataMap);
  }

  /// [List All Balance History]
  /// https://stripe.com/docs/api/balance/balance_history
  /// TODO implement missing arguments: `available_on` and `created`
  static Future<BalanceTransactionCollection> list(
      {int limit, String startingAfter, String endingBefore}) async {
    var data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (data == {}) data = null;
    var dataMap =
        await listResource([Balance.path, BalanceTransaction.path], data: data);
    return BalanceTransactionCollection.fromMap(dataMap);
  }
}

class BalanceTransactionCollection extends ResourceCollection {
  Card getInstanceFromMap(map) => Card.fromMap(map);

  BalanceTransactionCollection.fromMap(Map map) : super.fromMap(map);
}

class Fund {
  Map resourceMap;

  /// Balance amount.
  int get amount => resourceMap['amount'];

  /// Three-letter ISO currency code, in lowercase. Must be a supported currency.
  String get currency => resourceMap['currency'];

  // TODO source_types

  Fund.fromMap(this.resourceMap);
}

/// Detailed breakdown of fees (in cents) paid for a transaction.
class FeeDetails {
  Map resourceMap;

  /// Amount of the fee, in cents.
  int get amount => resourceMap['amount'];

  ///
  String get application => resourceMap['application'];

  /// Three-letter ISO currency code, in lowercase. Must be a supported currency.
  String get currency => resourceMap['currency'];

  /// An arbitrary string attached to the object. Often useful for displaying to users.
  String get description => resourceMap['description'];

  /// Will be one of the following:
  /// * application_fee
  /// * stripe_fee
  ///  * tax
  String get type => resourceMap['type'];

  FeeDetails.fromMap(this.resourceMap);
}
