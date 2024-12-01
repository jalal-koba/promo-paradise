import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:promo/app/offers/models/offer_response.dart';
import 'package:promo/constant/colors.dart';
import 'package:promo/constant/text_style.dart';
import 'package:promo/localization/AppLocalization.dart';
import 'package:sizer/sizer.dart';

class VouchersUsingHistoryCard extends StatelessWidget {
  final OfferResponse vouchersUsingHistory;

  final int index;

  const VouchersUsingHistoryCard({
    super.key,
    required this.vouchersUsingHistory,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final document = parse(vouchersUsingHistory.offer.description ?? '');
    final description = parse(document.body!.text).documentElement!.text;

    return FadeInUp(
      duration: Duration(milliseconds: 200 + (index % 5) * 100),
      child: Container(
        height: 17.h,
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
                    vouchersUsingHistory.offer.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.defaultStyle(
                      FontWeight.w600,
                      11.sp,
                      color: AppColors.blue,
                    ),
                  ),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.defaultStyle(
                      FontWeight.w400,
                      10.sp,
                    ),
                  ),
                  Text(
                    "${vouchersUsingHistory.offer.price}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.defaultStyle(
                      FontWeight.bold,
                      color: Colors.green,
                      12.sp,
                    ),
                  ),
                  Text(
                    "Saving ${vouchersUsingHistory.offer.discountPercentage?.percentage} %",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.defaultStyle(
                      FontWeight.w600,
                      10.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Coupons Available'.tr(context),
                  style: AppTextStyles.defaultStyle(
                    FontWeight.w600,
                    10.sp,
                    color: AppColors.blue,
                  ),
                ),
                // SizedBox(  height: 1.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Used at: ",
                        style: AppTextStyles.defaultStyle(
                          FontWeight.w400,
                          10.sp,
                        ),
                      ),
                      TextSpan(
                        text: DateFormat('dd / MM / yyyy')
                            .format(vouchersUsingHistory.offer.createdAt!),
                        style: AppTextStyles.defaultStyle(
                          FontWeight.w400,
                          9.sp,
                          color: AppColors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'used: ${vouchersUsingHistory.totalUsage}',
                  style: AppTextStyles.defaultStyle(
                    FontWeight.w400,
                    10.sp,
                  ),
                ),
                Text(
                  'left: ${int.parse(vouchersUsingHistory.totalVouchers.toString()) - vouchersUsingHistory.totalUsage!}',
                  style: AppTextStyles.defaultStyle(
                    FontWeight.w400,
                    10.sp,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
