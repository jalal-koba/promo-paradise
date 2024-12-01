import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:promo/app/Widget/custom_button.dart';
import 'package:promo/app/home/screens/bottom_nav_bar_screen.dart';
import 'package:promo/constant/colors.dart';
import 'package:promo/constant/global_functions.dart';
import 'package:promo/constant/text_style.dart';
import 'package:sizer/sizer.dart';

class PaymentSuccessDialog extends StatelessWidget {
  const PaymentSuccessDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: FractionalOffset.bottomCenter,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: AppColors.offWhite,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
                textAlign: TextAlign.center,
                'Payment completed successfully',
                style: AppTextStyles.defaultStyle(FontWeight.bold, 14.sp)),
            CustomButton(
                height: 4.h,
                width: 50.w,
                onPressed: () {
                  General.packagesPageKey.currentState?.moveToPage(index: 0);
                  GoRouter.of(context).go(BottomNavBarScreen.routeName);
                },
                title: "Back to home")
          ],
        ),
      ),
    );
  }
}
