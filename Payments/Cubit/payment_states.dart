abstract class PaymentStates {}

final class PaymentInitialStates extends PaymentStates {}

final class ShowSheetLoadingState extends PaymentStates {}

final class ShowSheetSuccessState extends PaymentStates {}

final class ShowSheetErrorState extends PaymentStates {
  final String message;

  ShowSheetErrorState({required this.message});
}
///
 

final class CreatePaymentIntentLoadingState extends PaymentStates {}

final class CreatePaymentIntentSuccessState extends PaymentStates {
  final String clientSecret;

  CreatePaymentIntentSuccessState({required this.clientSecret});
}

final class CreatePaymentIntentErrorState extends PaymentStates {
  final String message;

  CreatePaymentIntentErrorState({required this.message});
}



/////
 

 
final class CheckCouponLoadingState extends PaymentStates {}

final class CheckCouponSuccessState extends PaymentStates {
  final String coupon;
  final bool isValid;
  final num? price, discountPercentage, priceAfterDiscount;
  CheckCouponSuccessState({
    required this.coupon,
    required this.isValid,
    required this.price,
    required this.priceAfterDiscount,
    required this.discountPercentage,
  });
}

final class CheckCouponErrorState extends PaymentStates {
  final String message;
  CheckCouponErrorState({required this.message});
}
