 
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:promo/app/Widget/cached_image.dart';
import 'package:promo/app/Widget/custom_button.dart';
import 'package:promo/app/home/screens/bottom_nav_bar_screen.dart';
import 'package:promo/constant/colors.dart';
import 'package:promo/constant/global_functions.dart';
import 'package:promo/constant/text_style.dart';
import 'package:promo/localization/AppLocalization.dart';
import 'package:sizer/sizer.dart';

class QRCard extends StatelessWidget {
  const QRCard({
    super.key,
    required this.qrUrl,
    required this.totalActiveVouchers,
  });

  final String qrUrl;
  final int totalActiveVouchers;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      margin: EdgeInsets.all(2.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey, width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: <Widget>[
          CachedImage(
            image: qrUrl,
            width: 38.w,
            height: 38.w,
            radius: BorderRadius.circular(0),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  'Total Active Vouchers'.tr(context),
                  style: AppTextStyles.defaultStyle(FontWeight.bold, 12.sp),
                ),
                Text(
                  totalActiveVouchers.toString(),
                  style: AppTextStyles.defaultStyle(
                    FontWeight.bold,
                    14.sp,
                    color: AppColors.blue,
                  ),
                ),
                CustomButton(
                  onPressed: () {
                    General.packagesPageKey.currentState?.moveToPage(index: 3);
                    GoRouter.of(context).go(BottomNavBarScreen.routeName);
                  },
                  title: "Upgrade".tr(context),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
