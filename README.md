# Stripe Dart/Flutter

Stripe API implemented in Dart, for use in Flutter and Web applications

Most of the model class documentation have been taken from the
[Stripe API Docs](https://stripe.com/docs/api). And each model should have the URL to that specific object as well as almost the exact wording that the Stripe docs have


# Getting Started

## To use this package you will need:

1. A Stripe account that uses at least API version `2019-03-14` and access to the public/secret API keys for that account
2. An app (Flutter) or server that is running Dart code or makes use of a `pubspec.yaml` file

## Config

Aftering importing the 
You can set your API key via the top-level function, `setApiKey()`. Like so:

`setApiKey('sk_test_YOUR_API_KEY')`

**For your account security**, we recommend that you put your API keys in separate file **that is not committed to your code repo**, such as a JSON file.

*Remember: When in production use the `sk_live` key, when testing use the `sk_test` key*

## Usage

**This example will change in the future once `Tokens` are fully supported and tested**

```dart
import "package:stripe_dart_flutter/stripe.dart";

main() async {

    setApiKey('YOUR_API_KEY_READ_FROM_A_FILE');

    // Make an AccountCreation object. Only certain models will have a Creation or Update counterpart. The others should use the fromMap constructor
  var accountCreate = AccountCreation()
    ..type = 'custom'
    ..businessType = 'company'
    ..defaultCurrency = 'usd'
    ..email = 'demo@test.net'
    ..metadata = {'user_type': 'advertiser'}
    ..requestedCapabilities = ['card_payments', 'platform_payments']
    ..tosAcceptance = TosAcceptance.fromMap(
            // Make a map that contains the TosAcceptance attributes
    ); 
    ... // Add all the fields available while still following the Stripe API guidelines

    // Send to the Stripe API via the create method
    Account createdAccount = await accountCreate.create();

    // Make an AccountUpdate object
    var accountUpdate = AccountUpdate()
        ..individual = Individual.fromMap(jsonDecode(updateIndividualExample))
        ..email = 'updatedemail@test.net';

    // Send to the Stripe API via the update method
    Account updatedAccount = await accountUpdate.update(createdAccountId);

}
```

## Testing your app

To learn more about testing your mobile or web app [check out Stripe's docs](https://stripe.com/docs/testing) for test card numbers or tokens.

# Unit Tests

The majority of the unit tests rely on connecting to a real Stripe Account in
testmode. Therefore all tests expect your API **Test** Secret Key as the first script argument and your account must be set to **US**. Test coverage is limited for now (some tests would require `livemode` and or OAuth).

# Authors

## Current Authors
* Tanner Davis ([Cholojuanito](https://github.com/cholojuanito)) - *Repo owner and repo update author*
* Brandon Derbidge ([bderbidge](https://github.com/bderbidge)) - *Repo update author*

## Previous Authors
This repo is a fork from the original [Stirpe Dart API repo](https://gitlab.com/exitlive/stripe-dart) which was originally created by: 
* Matias Meno
* Matrin Flucka

 A big shoutout to them for the great work and time they put into their repo. We are sad they were not able to continue maintaining their repo.

# Versioning

* **Github:** We will name each new release the same way that Stripe versions their API. Stripe versions their API by using the date that version become available.      *i.e. We first built this repo based on the 2019-03-14 (March 14, 2019) API version, thus the first stable release will be named `2019-03-24`*

* **Dart pub package:** We will follow the [Dart pubspec versioning standards](https://dart.dev/tools/pub/pubspec#version) for the packages that are published to [pub.dev](pub.dev). But we will make notes in the [CHANGELOG](CHANGELOG) indicating which Stripe API version a particular package version corresponds to (see above about Github).

# License

See the [License file](LICENSE) for more info

