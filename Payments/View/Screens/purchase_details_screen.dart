import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:promo/app/Institutions/models/package.dart';
import 'package:promo/app/Payments/Cubit/payment_cubit.dart';
import 'package:promo/app/Payments/Cubit/payment_states.dart';
import 'package:promo/app/Payments/View/Screens/payment_screen.dart';
import 'package:promo/app/Payments/View/Widgets/payment_info_card.dart';
import 'package:promo/app/Widget/app_loading.dart';
import 'package:promo/app/Widget/custom_app_bar.dart';
import 'package:promo/app/Widget/custom_button.dart';
import 'package:promo/constant/colors.dart';
import 'package:promo/constant/global_functions.dart';
import 'package:promo/constant/text_style.dart';
import 'package:sizer/sizer.dart';

class PurchaseDetailsScreen extends StatefulWidget {
  const PurchaseDetailsScreen({super.key});
  static const String routeName = "/payment-info";

  @override
  State<PurchaseDetailsScreen> createState() => _PurchaseDetailsScreenState();
}

class _PurchaseDetailsScreenState extends State<PurchaseDetailsScreen> {
  bool agree = false;
  @override
  Widget build(BuildContext context) {
    final Package package =
        ModalRoute.of(context)!.settings.arguments as Package;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 15.h),
          child: const SafeArea(child: CustomAppBar("Purchase details")),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          children: [
            SizedBox(height: 5.h),
            PaymentInfoCard(package: package),
            SizedBox(height: 5.h),
            SizedBox(height: 7.h),
            CheckboxListTile(
              title: Text(
                "I agree to the privacy policy",
                style: AppTextStyles.defaultStyle(FontWeight.w500, 12.sp),
              ),
              value: agree,
              onChanged: (value) {
                setState(() {
                  agree = !agree;
                });
              },
              activeColor: AppColors.blue,
            ),
            SizedBox(height: 3.h),
            Align(
              child: BlocProvider(
                create: (context) => PaymentCubit(),
                child: BlocConsumer<PaymentCubit, PaymentStates>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    final PaymentCubit paymentCubit = PaymentCubit.get(context);

                    if (state is ShowSheetLoadingState) {
                      return const AppLoading();
                    }
                    return CustomButton(
                        disable: !agree,
                        width: 92.w,
                        onPressed: () async {
                          GoRouter.of(context).push(PaymentScreen.routeName,
                              extra: {
                                "paymentCubit": paymentCubit,
                                "package": package
                              });
                        },
                        onPressedDisable: () {
                          customSnackBar(
                              context: context,
                              success: 2,
                              message:
                                  "Please agree to privacy policy to continue");
                        },
                        title: "Buy the package");
                  },
                ),
              ),
            )
          ],
        ));
  }
}
