import '../api_resource.dart';
import '../resource.dart';
import '../resource_collection.dart';
import '../service.dart';

import '../resources/shipping.dart';

import 'balance.dart';
import 'card.dart';
import 'customer.dart';
import 'dispute.dart';
import 'invoice.dart';
import 'refund.dart';

/// [Charges]
/// https://stripe.com/docs/api/charges/object
/// To charge a credit or a debit card, you create a Charge object.
/// You can retrieve and refund individual charges as well as list all charges.
/// Charges are identified by a unique, random ID.
class Charge extends ApiResource {
  static String path = 'charges';

  final String object = 'charge';

// Attributes

  /// The id either given by Stripe or created by your program
  String get id => resourceMap['id'];

  /// A positive integer representing how much to charge in the smallest currency unit (e.g., 100 cents to charge $1.00 or 100 to charge ¥100, a zero-decimal currency).
  /// The minimum amount is $0.50 US or equivalent in charge currency.
  int get amount => resourceMap['amount'];

  /// Amount in cents refunded
  /// (can be less than the amount attribute on the charge if a partial refund was issued).
  int get amountRefunded => resourceMap['amountRefunded'];

  /// Id of the [Connect] application that created the charge.
  /// * See https://stripe.com/docs/connect/direct-charges#collecting-fees for info on collecting fees
  /// For [Connect] accounts only
  /// * Expandable
  String get application => this.getIdForExpandable('application');

  String get applicationExpand {
    var value = resourceMap['application'];
    if (value == null) {
      return null;
    } else {
      // TODO Make this return an Application
      return 'In progress';
    }
  }

  /// The application fee (if any) for the charge.
  /// * See https://stripe.com/docs/connect/direct-charges#collecting-fees for info on collecting fees
  /// For [Connect] accounts only
  /// * Expandable
  String get applicationFee => this.getIdForExpandable('application_fee');

  String get applicationFeeExpand {
    var value = resourceMap['application_fee'];
    if (value == null) {
      return null;
    } else {
      // TODO Make this return an ApplicationFee
      return 'In progress';
    }
  }

  /// The amount of the application fee (if any) for the charge.
  int get applicationFeeAmount => resourceMap['application_fee_amount'];

  /// Id of the balance transaction that describes the impact of this charge on your account balance (not including refunds or disputes).
  String get balanceTransaction =>
      this.getIdForExpandable('balance_transaction');

  BalanceTransaction get balanceTransactionExpand {
    var value = resourceMap['balance_transaction'];
    if (value == null)
      return null;
    else
      return BalanceTransaction.fromMap(value);
  }

  /// Billing information associated with the payment method at the time of the transaction.
  // TODO add BillingDetails object
  String get billingDetails => 'In progress';

  /// If the charge was created without capturing, this boolean represents whether it is still uncaptured or has since been captured.
  bool get captured => resourceMap['captured'];

  /// Time at which the object was created. Measured in seconds since the Unix epoch.
  DateTime get created => getDateTimeFromMap('created');

  /// Three-letter ISO currency code, in lowercase. Must be a supported currency.
  /// * See https://stripe.com/docs/currencies for supported currencies
  /// * See https://www.iso.org/iso-4217-currency-codes.html for ISO codes
  String get currency => resourceMap['currency'];

  /// Id of the customer this charge is for if one exists.
  /// * Expandable
  String get customer => this.getIdForExpandable('customer');

  Customer get customerExpand {
    var value = resourceMap['customer'];
    if (value == null)
      return null;
    else
      return Customer.fromMap(value);
  }

  /// An arbitrary string attached to the object. Often useful for displaying to users.
  String get description => resourceMap['description'];

  /// Id of  the dispute if the charge has been disputed.
  /// * Expandable
  String get dispute => this.getIdForExpandable('dispute');

  Dispute get disputeExpand {
    var value = resourceMap['dispute'];
    if (value == null)
      return null;
    else
      return Dispute.fromMap(value);
  }

  /// Error code explaining reason for charge failure if available
  /// * See https://stripe.com/docs/api/errors for a list of error codes and meanings
  String get failureCode => resourceMap['failureCode'];

  /// Message to user further explaining reason for charge failure if available.
  String get failureMessage => resourceMap['failureMessage'];

  /// Information on fraud assessments for the charge.
  /// Attributes are:
  /// Assessments from Stripe. If set, the value is 'fraudulent'.
  /// fraudDetails['stripe_report']
  ///
  /// Assessments reported by you. If set, possible values of are 'safe' and 'fraudulent'.
  /// fraudDetails['user_report']
  Map<String, String> get fraudDetails => resourceMap['fraud_details'];

  /// Id of the invoice this charge is for if one exists.
  String get invoice => this.getIdForExpandable('invoice');

  Invoice get invoiceExpand {
    var value = resourceMap['invoice'];
    if (value == null)
      return null;
    else
      return Invoice.fromMap(value);
  }

  /// Has the value true if the object exists in live mode or
  /// the value false if the object exists in test mode.
  bool get livemode => resourceMap['livemode'];

  /// Set of key-value pairs that you can attach to an object.
  /// This can be useful for storing additional information about the object in a structured format.
// TODO maybe make the value a dynamic?
  Map<String, String> get metadata => resourceMap['metadata'];

  /// The [Account] (if any) the charge was made on behalf of without triggering an automatic transfer.
  /// * See https://stripe.com/docs/connect/charges-transfers for more on seperate charges or transfers
  /// For [Connect] accounts only
  /// * Expandable
  // TODO implement this?
  // String get onBehalfOf => this.getIdForExpandable('on_behalf_of');

  /// Wil be [true] if the charge succeeded, or was successfully authorized for later capture.
  bool get paid => resourceMap['paid'];

  /// Id of the payment intent associated with this charge, if one exists.
// TODO implement PaymentIntent
  String get paymentIntent => resourceMap['payment_intent'];

  /// Id of the payment method used in this charge.
// TODO implement PaymentMethod
  String get paymentMethod => resourceMap['payment_method'];

  /// Details about the payment method at the time of the transaction.
  // TODO implement PaymentMethodDetails
  String get paymentMethodDetails => resourceMap['payment_method_details'];

  /// This is the email address that the receipt for this charge was sent to.
  String get receiptEmail => resourceMap['receipt_email'];

  /// This is the transaction number that appears on email receipts sent for this charge.
  /// This attribute will be null until a receipt has been sent.
  String get receiptNumber => resourceMap['receipt_number'];

  /// This is the URL to view the receipt for this charge.
  /// The receipt is kept up-to-date to the latest state of the charge, including any refunds.
  /// If the charge is for an [Invoice], the receipt will be stylized as an Invoice receipt.
  String get receiptURL => resourceMap['receipt_url'];

  /// Whether the charge has been fully refunded. If the charge is only partially refunded, this attribute will still be false.
  bool get refunded => resourceMap['refunded'];

  /// A list of refunds that have been applied to the charge.
  RefundCollection get refunds {
    Map value = resourceMap['refunds'];
    assert(value != null);
    return RefundCollection.fromMap(value);
  }

  /// Id of the review associated with this charge if one exists.
  // TODO implement Review
  String get review => this.getIdForExpandable('review');

  String get reviewExpand {
    var value = resourceMap['review'];
    if (value == null)
      return null;
    else
      return 'In progress';
  }

  /// For most Stripe users, the source of every charge is a credit or debit card.
  /// This map is then the card object describing that card.
  Card get source {
    var value = resourceMap['source'];
    if (value == null)
      return null;
    else
      return Card.fromMap(value);
  }

  /// Shipping information for the charge.
  Shipping get shipping {
    var value = resourceMap['shipping'];
    if (value == null)
      return null;
    else
      return Shipping.fromMap(value);
  }

  /// The transfer ID which created this charge.
  /// * Only present if the charge came from another Stripe account
  /// * See https://stripe.com/docs/connect/destination-charges for info on destintation charges
  /// For [Connect] acccounts only
  /// * Expandable
  String get sourceTransfer => this.getIdForExpandable('source_transfer');

  String get sourceTransferExpand {
    // TODO implement this
    return null;
  }

  /// Extra information about a charge.
  /// This will appear on your customer’s credit card statement.
  /// It must contain at least one letter.
  String get statement_descriptor => resourceMap['statement_descriptor'];

  /// The status of the payment is.
  /// Will be one of the following:
  /// * succeeded
  /// * pending
  /// * failed.
  String get status => resourceMap['status'];

  /// Id of the [Transfer] to the destination account
  /// * Only applicable if the charge was created using the 'destination' parameter
  /// * Expandable
  String get transfer => this.getIdForExpandable('transfer');

  String get transferExpand {
    // TODO implement this
    return null;
  }

  /// An optional map including the account to automatically transfer to as part of a destination charge.
  /// * See https://stripe.com/docs/connect/destination-charges for info on destination charges
  /// For [Connect] accounts only.
// Todo implement TransferData

  /// A string that identifies this transaction as part of a group.
  /// * See https://stripe.com/docs/connect/destination-charges for info on destination charges
  /// For [Connect] accounts only.
  // TODO implement TransferGroup

// ! seems to be deprecated
  String get destination => resourceMap['destination'];

  Charge.fromMap(Map dataMap) : super.fromMap(dataMap);

  /// [Retrieve a Charge]
  /// https://stripe.com/docs/api/charges/retrieve
  static Future<Charge> retrieve(String chargeId, {final Map data}) async {
    var dataMap = await retrieveResource([Charge.path, chargeId], data: data);
    return Charge.fromMap(dataMap);
  }

  /// [Capture a Charge]
  /// https://stripe.com/docs/api/charges/capture
  static Future<Charge> capture(String chargeId,
      {int amount,
      String applicationFee,
      String receiptEmail,
      String statementDescriptor}) async {
    var data = {};
    if (amount != null) data['amount'] = amount;
    if (applicationFee != null) data['application_fee'] = applicationFee;
    if (receiptEmail != null) data['receipt_email'] = receiptEmail;
    if (statementDescriptor != null)
      data['statement_descriptor'] = statementDescriptor;
    var dataMap =
        await postResource([Charge.path, chargeId, 'capture'], data: data);
    return Charge.fromMap(dataMap);
  }

  /// [List All Charges]
  /// https://stripe.com/docs/api/charges/list
  static Future<ChargeCollection> list(
      {var created,
      String customer,
      int limit,
      String startingAfter,
      String endingBefore}) async {
    var data = {};
    if (created != null) data['created'] = created;
    if (customer != null) data['customer'] = customer;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    var dataMap = await listResource([Charge.path], data: data);
    return ChargeCollection.fromMap(dataMap);
  }
}

class ChargeCollection extends ResourceCollection {
  Charge getInstanceFromMap(map) => Charge.fromMap(map);

  ChargeCollection.fromMap(Map map) : super.fromMap(map);
}

/// [Create a Charge]
/// https://stripe.com/docs/api/charges/create
class ChargeCreation extends ResourceRequest {
  ChargeCreation() {
    setMap('object', 'charge');
    setRequiredFields('amount');
    setRequiredFields('currency');
  }

  // TODO add:
  // A fee in cents that will be applied to the charge and transferred to the application owner’s Stripe account.
  // The request must be made with an OAuth key or the Stripe-Account header in order to take an application fee.
  // *applicationFeeAmount
  // *metadata
  // *onBehalfOf
  // *source
  // *transferData
  // *transferGroup

  set amount(int amount) => setMap('amount', amount);

  set currency(String currency) => setMap('currency', currency);

  set capture(bool capture) => setMap('capture', capture.toString());

  set customer(String customer) => setMap('customer', customer);

  set description(String description) => setMap('description', description);

  set sourceToken(String sourceToken) => setMap('source', sourceToken);

  set source(CardCreation source) => setMap('source', source);

  set metadata(Map metadata) => setMap('metadata', metadata);

  set receiptEmail(String receiptEmail) =>
      setMap('receipt_email', receiptEmail);

  set shipping(int shipping) => setMap('shipping', shipping);

  set statementDescriptor(String statementDescriptor) =>
      setMap('statement_descriptor', statementDescriptor);

  //! destination might be deprecated
  //set destination(int destination) => setMap('destination', destination);

  // ! applicationFee deprecated but applicationFeeAmount isn't
  // set applicationFee(int applicationFee) =>
  //     setMap('application_fee', applicationFee);

  Future<Charge> create({String idempotencyKey}) async {
    var dataMap = await createResource([Charge.path], getMap(),
        idempotencyKey: idempotencyKey);
    return Charge.fromMap(dataMap);
  }
}

/// [Update a Charge]
/// https://stripe.com/docs/api/charges/update
class ChargeUpdate extends ResourceRequest {
// TODO add:
// * customer
// * metadata
// * shipping
// * transferGroup

  set description(String description) => setMap('description', description);

  set fraudDetails(Map fraudDetails) => setMap('fraud_details', fraudDetails);

  set metadata(Map metadata) => setMap('metadata', metadata);

  set receiptEmail(Map receiptEmail) => setMap('receipt_email', receiptEmail);

  Future<Charge> update(String chargeId) async {
    var dataMap = await updateResource([Charge.path, chargeId], getMap());
    return Charge.fromMap(dataMap);
  }
}
