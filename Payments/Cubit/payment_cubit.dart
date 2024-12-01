import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promo/Apis/exception_handler.dart';
import 'package:promo/Apis/network.dart';
import 'package:promo/Apis/urls.dart';
import 'package:promo/app/Payments/Cubit/payment_states.dart';
import 'package:promo/app/Payments/Models/coupon_response.dart';
import 'package:promo/app/Payments/Utils/stripe_services.dart';

class PaymentCubit extends Cubit<PaymentStates> {
  PaymentCubit() : super(PaymentInitialStates());
  static PaymentCubit get(context) => BlocProvider.of(context);

  final TextEditingController couponCodeController = TextEditingController();
  final GlobalKey<FormState> couponCodeFormKey = GlobalKey<FormState>();
  final FocusNode couponCodeFocusNode = FocusNode();

  bool couponCodeReadOnly = false;

  Future<void> showStripeSheet(
      { 
       required String clientSecret}) async {
    emit(ShowSheetLoadingState());
    try {
      await StripeServices.initPaymentSheet(clientSecret: clientSecret);

      emit(ShowSheetSuccessState());

      await StripeServices.presentPaymentSheet();
    } catch (error) {
      emit(ShowSheetErrorState(message: error.toString()));
    }
  }

  Future<void> createPaymentIntent(
      {required int packageId, String? coupon, required int userId}) async {
    try {
      emit(CreatePaymentIntentLoadingState());

      FormData formData = FormData.fromMap({
        "user_id": userId,
        "package_id": packageId,
        if (coupon != null) "coupon": coupon
      });
      Response response =
          await Network.postData(url: Urls.postPaymentIntent, data: formData);
      String clientSecret = response.data['data']['client_secret'];

      couponCodeFocusNode.unfocus();
      emit(CreatePaymentIntentSuccessState(clientSecret: clientSecret));
    } on DioException catch (error) {
      emit(CreatePaymentIntentErrorState(
          message: exceptionsHandle(error: error)));
    } catch (_) {
      emit(CreatePaymentIntentErrorState(message: "An error ocour"));
    }
  }

  String couponCode = '';
  Future<void> checkCoupon({required int packageId}) async {
    try {
      couponCodeReadOnly = true;
      couponCode = couponCodeController.text.trim();

      emit(CheckCouponLoadingState());
      final FormData formData = FormData.fromMap({
        "package_id": packageId,
        "code": couponCodeController.text.trim(),
        if (couponCode.length == 10) "coupon": couponCode
      });

      final Response response =
          await Network.postData(url: Urls.checkCoupon, data: formData);
      CouonResponse couonResponse = CouonResponse.fromJson(response.data);

      couponCodeController.text = "";
      couponCodeReadOnly = false;
      emit(CheckCouponSuccessState(
          coupon: couponCode,
          discountPercentage: couonResponse.data.discountPercentage,
          isValid: couonResponse.data.isValid,
          price: couonResponse.data.price,
          priceAfterDiscount: couonResponse.data.priceAfterDiscount));
    } on DioException catch (error) {
      couponCodeReadOnly = false;

      emit(CheckCouponErrorState(message: exceptionsHandle(error: error)));
    } catch (_) {
      emit(CheckCouponErrorState(message: "An error ocour"));
    }
  }
}
