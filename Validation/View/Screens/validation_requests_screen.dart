import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promo/app/Packages/View/Screen/package_details_screen.dart';
import 'package:promo/app/Validation/Cubit/Cubit/qr_cubit.dart';
 import 'package:promo/app/Validation/Cubit/States/qr_state.dart';
 import 'package:promo/app/Validation/View/Widgets/validation_request_card.dart';
import 'package:promo/app/Widget/app_loading.dart';
import 'package:promo/app/Widget/custom_app_bar.dart';
import 'package:promo/app/Widget/try_agin.dart';
 import 'package:promo/app/offers/widgets/offer_card.dart';
 import 'package:promo/constant/text_style.dart';
import 'package:sizer/sizer.dart';

class ValidationRequestsScreen extends StatelessWidget {
  const ValidationRequestsScreen({super.key});
  static const String routeName = "/validation-requests";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 15.h),
          child: const SafeArea(child: CustomAppBar("Validation requests")),
        ),
        body: BlocProvider(
          create: (context) => QRCubit()..getValidationRequests(),
          child: BlocConsumer<QRCubit, QRState>(
            listener: (context, state) {
              if (state is AcceptOfferSuccessState) {
                context.read<QRCubit>().deleteOffer(id: state.offerId);
              }
            },
            builder: (context, state) {
              final QRCubit qrCubit = QRCubit.get(context);
              if (state is ValidateRequestsErrorState) {
                return TryAgain(
                  onTap: () {
                    qrCubit.getValidationRequests();
                  },
                );
              }
              if (state is ValidationRequestsLoadingState) {
                return const AppLoading();
              }

              if (qrCubit.offersResponse.isEmpty) {
                return Center(
                  child: Text(
                    'No validation requests to show',
                    style: AppTextStyles.defaultStyle(
                      FontWeight.w500,
                      12.sp,
                    ),
                  ),
                );
              }
              return ListView.separated(
                itemCount: qrCubit.offersResponse.length,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                separatorBuilder: (context, index) => SizedBox(height: 2.h),
                itemBuilder: (context, index) {
                  return CardWithShadow(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      OfferCard(offerResponse: qrCubit.offersResponse[index]),
                      Builder(
                        builder: (context) {
                          if (state is AcceptOfferLoadingState &&
                              state.offerId ==
                                  qrCubit.offersResponse[index].offer.id) {
                            return const AppLoading();
                          }

                          if (state is RejectOfferLoadingState &&
                              state.offerId ==
                                  qrCubit.offersResponse[index].offer.id) {
                            return const AppLoading();
                          } else {
                            return ValidationRequestCard(
                              qrCubit: qrCubit,
                              offer: qrCubit.offersResponse[index].offer,
                            );
                          }
                        },
                      )
                    ],
                  ));
                },
              );
            },
          ),
        ));
  }
}
