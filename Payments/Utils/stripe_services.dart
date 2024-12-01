import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeServices {
  static init() {
    Stripe.publishableKey =
        "pk_test_51LBCQZCIVpuPdTYcsaRbytf68tRCp5QvSxo2xE99eM6pJ3VtSwDczVQwrJgzi3t4ThA2jkrr1NtC78li9GMV7to0005NJMS514";
  }

  static Future<void> initPaymentSheet({required String clientSecret}) async {
    try {
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              billingDetails: const BillingDetails(
                  address: Address(
                      city: null,
                      country: "CA",
                      line1: null,
                      line2: null,
                      postalCode: null,
                      state: null)),
              paymentIntentClientSecret: clientSecret,
              merchantDisplayName: "Buy a Package",
              style: ThemeMode.system));
    } on Exception catch (e) {
      throw Exception(
          "Filed to intiallize sheet ffffffffffffff ${e.toString()}");
    }
  }

  static Future<void> presentPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }
}
