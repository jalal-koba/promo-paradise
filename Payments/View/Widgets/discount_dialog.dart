import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:promo/app/Payments/Cubit/payment_states.dart';
import 'package:promo/app/Payments/View/Screens/pay_using_paypal.dart';
import 'package:promo/app/Payments/View/Screens/payment_screen.dart';
import 'package:promo/app/Profile/Cubit/profile_cubit.dart';
import 'package:promo/app/Widget/custom_button.dart';
import 'package:promo/constant/colors.dart';
import 'package:promo/constant/text_style.dart';
import 'package:sizer/sizer.dart';

class DiscountDialog extends StatelessWidget {
  const DiscountDialog({
    super.key,
    required this.paymentType,
    required this.widget,
    required this.state,
  });

  final String paymentType;
  final PaymentScreen widget;
  final CheckCouponSuccessState state;
   

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.offWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Discount percentage : %${state.discountPercentage}',
              style: AppTextStyles.defaultStyle(FontWeight.bold, 12.sp),
            ),
            Text(
              'Price :  ${state.price}',
              style: AppTextStyles.defaultStyle(FontWeight.bold, 12.sp),
            ),
            Text(
              'Price after discount :  ${state.priceAfterDiscount}',
              style: AppTextStyles.defaultStyle(FontWeight.bold, 12.sp),
            ),
            SizedBox(  height: 2.h),
            Align(
              alignment: Alignment.center,
              child: CustomButton(
                  width: 50.w,
                  height: 5.h,
                  onPressed: () {
                    GoRouter.of(context).pop();
                    if (paymentType == "stripe") {
                      widget.paymentCubit.createPaymentIntent(
                          packageId: widget.package.id,
                          userId: context.read<ProfileCubit>().userId,
                          coupon: state.coupon);
                    } else {
                      GoRouter.of(context).push(PayUsingPaypal.routeName,
                          extra: {
                            "package": widget.package,
                            "coupon": state.coupon
                          });
                    }
                  },
                  title: "Next"),
            )
          ],
        ),
      ),
    );
  }
}
