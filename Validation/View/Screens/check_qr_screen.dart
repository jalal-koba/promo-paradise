import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:promo/app/Validation/View/Widgets/check_qr.dart';
import 'package:promo/app/Widget/custom_app_bar.dart';
import 'package:promo/constant/colors.dart';
import 'package:sizer/sizer.dart';

class CheckQrScreen extends StatelessWidget {
  const CheckQrScreen({super.key});
  static const String routeName = "/check-qr-screen";
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 300), () {
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: AppColors.lightBlue));
    });
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 8.h),
        child: const SafeArea(
          child: CustomAppBar(
            "Use offer",
          ),
        ),
      ),
      body: const CheckQr(
        isHome: false,
      ),
    );
  }
}
