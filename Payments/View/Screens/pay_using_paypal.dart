import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promo/app/Institutions/models/package.dart';
import 'package:promo/app/Payments/View/Widgets/payment_success_dialog.dart';
import 'package:promo/app/Profile/Cubit/profile_cubit.dart';
import 'package:promo/app/Widget/app_loading.dart';
import 'package:promo/app/Widget/custom_app_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayUsingPaypal extends StatefulWidget {
  const PayUsingPaypal({super.key, required this.package, this.couponCode});
  final Package package;
  final String? couponCode;
  static const String routeName = "/pay-using-paypal";

  @override
  State<PayUsingPaypal> createState() => _PayUsingPaypalState();
}

class _PayUsingPaypalState extends State<PayUsingPaypal> {
  late final WebViewController controller;
  bool isLoading = true;
  late String url;
  @override
  void initState() {
    url =
        '__Private__?package_id=${widget.package.id}&user_id=${context.read<ProfileCubit>().userId}${widget.couponCode != null ? "&coupon=${widget.couponCode}" : ""}}';

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100 && isLoading) {
              // to  setstate only once
              setState(() {
                isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            if (url.startsWith(
                "https://promo-back.icrcompany.net/api/v1/payment/paypal/capture-order")) {
              Future.delayed(
                  const Duration(
                    milliseconds: 1500,
                  ), () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => const PaymentSuccessDialog(),
                );
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 10.h),
        child: const SafeArea(child: CustomAppBar("Pay using PayPal")),
      ),
      body: isLoading
          ? const AppLoading()
          : WebViewWidget(controller: controller),
    );
  }
}
