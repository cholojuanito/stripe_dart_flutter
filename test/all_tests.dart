import 'package:logging/logging.dart';

// general tests
import 'resource_tests.dart' as resource_tests;
import 'api_resource_tests.dart' as apiResource_tests;
import 'service_tests.dart' as service_tests;

// api resource tests
import 'api_resources/account_tests.dart' as account_tests;
import 'api_resources/application_fee_tests.dart' as application_fee_tests;
import 'api_resources/balance_tests.dart' as balance_tests;
import 'api_resources/balance_transaction_tests.dart'
    as balance_transaction_tests;
import 'api_resources/card_tests.dart' as card_tests;
import 'api_resources/charge_tests.dart' as charge_tests;
import 'api_resources/coupon_tests.dart' as coupon_tests;
import 'api_resources/customer_tests.dart' as customer_tests;
import 'api_resources/discount_tests.dart' as discount_tests;
import 'api_resources/dispute_tests.dart' as dispute_tests;
import 'api_resources/event_tests.dart' as event_tests;
import 'api_resources/file_upload_tests.dart' as file_upload_tests;
import 'api_resources/invoice_item_tests.dart' as invoice_item_tests;
import 'api_resources/invoice_tests.dart' as invoice_tests;
import 'api_resources/plan_tests.dart' as plan_tests;
import 'api_resources/refund_tests.dart' as refund_tests;
import 'api_resources/subscription_tests.dart' as subscription_tests;
import 'api_resources/token_tests.dart' as token_tests;
import 'api_resources/transfer_tests.dart' as transfer_tests;
import 'api_resources/transfer_reversal_tests.dart' as transfer_reversal_tests;

// resource tests
import 'resources/additional_owner_tests.dart' as additional_owner_tests;
import 'resources/address_tests.dart' as address_tests;
import 'resources/bank_account_tests.dart' as bank_account_tests;
import 'resources/date_tests.dart' as date_tests;
import 'resources/legal_entity_tests.dart' as legal_entity_tests;
import 'resources/shipping_tests.dart' as shipping_tests;
import 'resources/tos_acceptance_tests.dart' as tos_acceptance_tests;
import 'resources/transfer_schedule_tests.dart' as transfer_schedule_tests;
import 'resources/verification_tests.dart' as verification_tests;

main(List<String> args) {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((LogRecord record) => print('${record.message}'));

  // general tests
  resource_tests.main();
  apiResource_tests.main();
  service_tests.main();

  // api resource tests
  account_tests.main(args);
  application_fee_tests.main(args);
  balance_tests.main(args);
  balance_transaction_tests.main(args);
  card_tests.main(args);
  charge_tests.main(args);
  coupon_tests.main(args);
  customer_tests.main(args);
  discount_tests.main(args);
  dispute_tests.main(args);
  event_tests.main(args);
  file_upload_tests.main(args);
  invoice_item_tests.main(args);
  invoice_tests.main(args);
  plan_tests.main(args);
  refund_tests.main(args);
  subscription_tests.main(args);
  token_tests.main(args);
  transfer_tests.main(args);
  transfer_reversal_tests.main(args);

  // resource tests
  additional_owner_tests.main(args);
  address_tests.main(args);
  bank_account_tests.main(args);
  date_tests.main(args);
  legal_entity_tests.main(args);
  shipping_tests.main(args);
  tos_acceptance_tests.main(args);
  transfer_schedule_tests.main(args);
  verification_tests.main(args);
}
