import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promo/app/Validation/Model/vouchers.dart';
import 'package:promo/constant/colors.dart';
import 'package:promo/constant/text_style.dart';
import 'package:promo/localization/AppLocalization.dart';
import 'package:sizer/sizer.dart';

class VouchersDetailsCard extends StatelessWidget {
  final UserPackage package;
  final int index;

  const VouchersDetailsCard({
    super.key,
    required this.package,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: 200 + (index % 5) * 100),
      child: Container(
        height: 14.h,
        padding: EdgeInsets.all(2.w),
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(color: AppColors.grey, width: 0.5),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    package.package.name,
                    style: AppTextStyles.defaultStyle(
                      FontWeight.w600,
                      11.sp,
                      color: AppColors.blue,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "The date of purchase :".tr(context),
                          style: AppTextStyles.defaultStyle(
                            FontWeight.w400,
                            10.sp,
                          ),
                        ),
                        TextSpan(
                          text: DateFormat('dd / MM / yyyy')
                              .format(package.package.createdAt),
                          style: AppTextStyles.defaultStyle(
                            FontWeight.w400,
                            9.sp,
                            color: AppColors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
        
                ],
              ),
            ),
            SizedBox(width: 2.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  '${package.package.price}',
                  style: AppTextStyles.defaultStyle(
                    FontWeight.w600,
                    12.sp,
                    color: AppColors.blue,
                  ),
                ),
                Text(
                  '${package.totalVouchers} ${'Coupons'.tr(context)}',
                  style: AppTextStyles.defaultStyle(
                    FontWeight.w600,
                    10.sp,
                    color: Colors.green[300],
                  ),
                ),
                SizedBox(height: 1.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "used".tr(context),
                        style: AppTextStyles.defaultStyle(
                          FontWeight.w400,
                          10.sp,
                          color: Colors.red,
                        ),
                      ),
                      TextSpan(
                        text:
                            " ${package.totalUsage} / ${package.totalVouchers}",
                        style: AppTextStyles.defaultStyle(
                          FontWeight.w400,
                          9.sp,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
