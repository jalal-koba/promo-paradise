import 'package:flutter/material.dart';
import 'package:promo/app/Institutions/models/package.dart';
import 'package:promo/app/Packages/View/Screen/package_details_screen.dart';
import 'package:promo/constant/app_assets.dart';
import 'package:promo/constant/colors.dart';
import 'package:promo/constant/text_style.dart';
import 'package:sizer/sizer.dart';

class PaymentInfoCard extends StatelessWidget {
  const PaymentInfoCard({
    super.key,
    required this.package,
  });

  final Package package;

  @override
  Widget build(BuildContext context) {
    return CardWithShadow(
        height: 25.h,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    package.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.defaultStyle(FontWeight.w600, 12.sp),
                  ),
                  Text(
                    'It is renewed annually, including value added tax',
                    style: AppTextStyles.defaultStyle(
                      FontWeight.w300,
                      10.sp,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Price:',
                        style:
                            AppTextStyles.defaultStyle(FontWeight.bold, 12.sp),
                      ),
                      SizedBox(width: 5.w, height: 0.0),
                      Text(
                        "${package.newPrice}",
                        style: AppTextStyles.defaultStyle(
                            FontWeight.bold, 16.sp,
                            color: AppColors.blue),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Image.asset(
              AppAssets.cart,
              width: 30.w,
            ),
          ],
        ));
  }
}
