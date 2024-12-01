import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:promo/app/Auth/View/Widgets/need_to_login.dart';
import 'package:promo/app/Institutions/models/package.dart';
import 'package:promo/app/Payments/Cubit/payment_cubit.dart';
import 'package:promo/app/Payments/Cubit/payment_states.dart';
import 'package:promo/app/Payments/View/Screens/pay_using_paypal.dart';
import 'package:promo/app/Payments/View/Widgets/discount_dialog.dart';
import 'package:promo/app/Profile/Cubit/profile_cubit.dart';
import 'package:promo/app/Profile/Cubit/profile_state.dart';
import 'package:promo/app/Widget/app_loading.dart';
import 'package:promo/app/Widget/custom_app_bar.dart';
import 'package:promo/app/Widget/custom_button.dart';
import 'package:promo/app/Widget/custom_text_field.dart';
import 'package:promo/app/Widget/try_agin.dart';
import 'package:promo/constant/app_assets.dart';
import 'package:promo/constant/colors.dart';
import 'package:promo/constant/global_functions.dart';
import 'package:promo/constant/text_style.dart';
import 'package:sizer/sizer.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.paymentCubit,
   
    required this.package,
  });

  static String routeName = '/payment-screen';
  final PaymentCubit paymentCubit;
  final Package package;
   @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String paymentType = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 15.h),
        child: const SafeArea(child: CustomAppBar("Payment")),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        // to get user id to execute payment using  paypal

        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return const AppLoading();
          }
          if (state is UnAuthenticatedState) {
            return const NeedToLogin();
          }
          if (state is ProfileSuccessState) {
            return SingleChildScrollView(
              child: BlocProvider.value(
                value: widget.paymentCubit,
                child: BlocConsumer<PaymentCubit, PaymentStates>(
                  listener: (context, state) {
                    if (state is CheckCouponSuccessState) {
                      if (state.isValid) {
                        showDialog(
                          context: context,
                          builder: (context) => DiscountDialog(
                            paymentType: paymentType,
                            widget: widget,
                            state: state,
                          ),
                        );
                      } else {
                        customSnackBar(
                            context: context,
                            success: 0,
                            message: "The coupon code is invalid");
                      }
                    }

                    if (state is CreatePaymentIntentSuccessState) {
                      widget.paymentCubit.showStripeSheet(
                          clientSecret: state.clientSecret,
                         );

                    } else if (state is CreatePaymentIntentErrorState) {
                      customSnackBar(
                          context: context, success: 0, message: state.message);
                    } else if (state is CheckCouponErrorState) {
                      customSnackBar(
                          context: context, success: 0, message: state.message);
                    }
                  },
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 5.h),
                          Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                'Payment method (Required) :',
                                style: AppTextStyles.defaultStyle(
                                    FontWeight.bold, 12.sp),
                              )),
                          SizedBox(height: 5.h),
                           RadioListTile(
                            title: Image.asset(AppAssets.paypal, height: 5.h),
                            value: "pay-pal",
                            activeColor: AppColors.blue,
                            groupValue: paymentType,
                            onChanged: (value) {
                              setState(() {
                                paymentType = value!;
                              });
                            },
                          ),
                          SizedBox(height: 2.h),
                          RadioListTile(
                            activeColor: AppColors.blue,
                            title: Image.asset(
                              AppAssets.stripe,
                              height: 5.h,
                            ),
                            value: "stripe",
                            groupValue: paymentType,
                            onChanged: (value) {
                              setState(() {
                                paymentType = value!;
                              });
                            },
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Divider(
                            endIndent: 5.w,
                            indent: 5.w,
                            color: AppColors.blue,
                          ),
                          SizedBox(height: 8.h),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              "Enter coupon (optional) :",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.defaultStyle(
                                  FontWeight.w500, 12.sp),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Form(
                            key: widget.paymentCubit.couponCodeFormKey,
                            child: CustomTextField(
                                focusNode:
                                    widget.paymentCubit.couponCodeFocusNode,
                                onChanged: (text) {
                                  if (text.length == 1 ||
                                      text.isEmpty ||
                                      text.length == 10) {
                                    setState(() {});// to reduce setstae 
                                  }
                                },
                                readonly:
                                    widget.paymentCubit.couponCodeReadOnly,
                                maxLength: 10,
                                validat: (text) {
                                  if (text!.length < 10) {
                                    return "The code must be ten characters";
                                  }
                                  return null;
                                },
                                hint: "(optional)",
                                label: "Coupon code",
                                controller:
                                    widget.paymentCubit.couponCodeController,
                                keyboardtype: TextInputType.name),
                          ),
                          SizedBox(height: 3.h),
                          Builder(
                            builder: (context) {
                              if (state is CreatePaymentIntentLoadingState ||
                                  state is CheckCouponLoadingState) {
                                return const AppLoading();
                              }
                              return CustomButton(
                                  disable: paymentType == "",
                                  height: 4.h,
                                  onPressedDisable: () {
                                    customSnackBar(
                                        context: context,
                                        success: 0,
                                        message: "Choose payment method");
                                  },
                                  width: 50.w,
                                  onPressed: () async {
                                    if (widget
                                        .paymentCubit.couponCodeController.text
                                        .trim()
                                        .isNotEmpty) {
                                      if (widget.paymentCubit.couponCodeFormKey
                                          .currentState!
                                          .validate()) {
                                        widget.paymentCubit.checkCoupon(
                                            packageId: widget.package.id);
                                      }
                                    } else {
                                      if (paymentType == "stripe") {
                                        widget.paymentCubit.createPaymentIntent(
                                            packageId: widget.package.id,
                                            userId: context
                                                .read<ProfileCubit>()
                                                .userId);
                                      } else {
                                        GoRouter.of(context).push(
                                            PayUsingPaypal.routeName,
                                            extra: {"package": widget.package});
                                      }
                                    }
                                  },
                                  title: widget.paymentCubit
                                          .couponCodeController.text.isNotEmpty
                                      ? "Check"
                                      : "buy");
                            },
                          ),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          }

          return TryAgain(onTap: () {
            context.read<ProfileCubit>().getProfile();
          });
        },
      ),
    );
  }
}
