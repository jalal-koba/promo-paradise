import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promo/app/Auth/View/Widgets/need_to_login.dart';
import 'package:promo/app/Notification/Notification-cubit/notification_cubit.dart';
import 'package:promo/app/Validation/Cubit/Cubit/qr_cubit.dart';
import 'package:promo/app/Validation/View/Widgets/vouchers_using_history_card.dart';
import 'package:promo/app/Profile/Cubit/profile_cubit.dart';
import 'package:promo/app/Profile/Cubit/profile_state.dart' as profilestate;
 import 'package:promo/app/Validation/Cubit/States/qr_state.dart';
import 'package:promo/app/Widget/app_loading.dart';
import 'package:promo/app/Widget/cached_image.dart';
import 'package:promo/app/Widget/try_agin.dart';
import 'package:promo/app/Widget/custom_button.dart';
import 'package:promo/constant/colors.dart';
import 'package:promo/constant/global_functions.dart';
import 'package:promo/constant/text_style.dart';
import 'package:promo/localization/AppLocalization.dart';
import 'package:sizer/sizer.dart';

class CheckQr extends StatefulWidget {
  const CheckQr({super.key, this.isHome = true});
  final bool isHome;
  @override
  CheckQrState createState() => CheckQrState();
}

class CheckQrState extends State<CheckQr> {
  @override
  void initState() {
    firstObject = QRCubit();
    secondObject = QRCubit();

    super.initState();
  }

  @protected
  static late QRCubit firstObject;
  static late QRCubit secondObject;

  static int offerId = 0;
  static void recciveNotifivation({required dynamic id}) async {
    offerId = int.parse("$id");

    final state = await firstObject.getOffer(offerId: offerId);

    if (state is GetOfferSuccessState) {
      secondObject.recciveNotifivation(id: offerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (widget.isHome)
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            toolbarHeight: 6.h,
            shadowColor: Colors.black,
            backgroundColor: AppColors.lightBlue,
            surfaceTintColor: Colors.transparent,
            title: Text(
              'qr code'.tr(context),
              style: AppTextStyles.defaultStyle(
                FontWeight.w700,
                16,
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              SizedBox(height: 7.h),
              Align(
                alignment: Alignment.center,
                child: BlocBuilder<ProfileCubit, profilestate.ProfileState>(
                  builder: (context, state) {
                    final ProfileCubit profileCubit = ProfileCubit.get(context);
                    if (state is profilestate.ProfileLoadingState) {
                      return const AppLoading();
                    } else if (state is profilestate.ProfileErrorState) {
                      return TryAgain(
                          small: true,
                          onTap: () {
                            profileCubit.getProfile();
                          });
                    } else if (state is profilestate.UnAuthenticatedState) {
                      return const NeedToLogin();
                    }
                    return CachedImage(
                      image: profileCubit.qrImage,
                      width: 45.w,
                      height: 45.w,
                      radius: BorderRadius.circular(0),
                    );
                  },
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(height: 1.h),
              BlocProvider(
                create: (context) => firstObject,
                child: BlocConsumer<QRCubit, QRState>(
                  listener: (context, state) {
                    if (state is GetOfferLoodingState) {
                      context
                          .read<NotificationCubit>()
                          .getNotification(read: 0);
                    }
                  },
                  builder: (context, state) {
                    final firstObject = QRCubit.get(context);
                    if (state is UnAuthenticatedState) {
                      return const NeedToLogin();
                    }
                    if (state is GetOfferLoodingState) {
                      return const AppLoading();
                    }

                    if (state is GetOfferErrorState) {
                      return TryAgain(
                          withImage: false,
                          onTap: () async {
                            final state =
                                await firstObject.getOffer(offerId: offerId);
                            if (state is GetOfferSuccessState) {
                              secondObject.recciveNotifivation(id: offerId);
                            }
                          });
                    }

                    if (state is GetOfferSuccessState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              'Coupons Available'.tr(context),
                              style: AppTextStyles.defaultStyle(
                                  FontWeight.bold, 12.sp),
                            ),
                          ),
                          VouchersUsingHistoryCard(
                              index: 2,
                              vouchersUsingHistory: firstObject.offer!),
                        ],
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
              SizedBox(height: 10.h),
              BlocProvider(
                create: (context) => secondObject,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: BlocConsumer<QRCubit, QRState>(
                    listener: (context, state) {
                      if (state is AcceptOfferSuccessState) {
                        firstObject.removeOffer();
                        customSnackBar(
                            context: context,
                            success: 1,
                            message: "Coupons consumed Successfully");
                      }

                      if (state is AcceptOfferErrorState) {
                        customSnackBar(
                            context: context,
                            success: 0,
                            message: state.message);
                      }
                    },
                    builder: (context, state) {
                      final QRCubit qrCubit = QRCubit.get(context);

                      if (state is AcceptOfferLoadingState) {
                        return const AppLoading();
                      }
                      return CustomButton(
                          disable: !secondObject.showValidate,
                          onPressed: () {
                            qrCubit.acceptOffer(offerId: offerId);
                          },
                          title: "Validate".tr(context));
                    },
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
