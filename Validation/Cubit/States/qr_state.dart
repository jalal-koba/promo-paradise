abstract class QRState {}

final class QRInitialState extends QRState {}

final class UnAuthenticatedState extends QRState {}

//
final class GetOfferLoodingState extends QRState {}

final class GetOfferSuccessState extends QRState {}

final class GetOfferErrorState extends QRState {
  GetOfferErrorState({required this.message});
  String message;
}

final class RemoveOfferState extends QRState {}

final class RecciveNotifivationState extends QRState {}

final class AcceptOfferLoadingState extends QRState {
  final int offerId;

  AcceptOfferLoadingState({required this.offerId});
}

final class AcceptOfferSuccessState extends QRState {
  final int offerId;

  AcceptOfferSuccessState({required this.offerId});
}

final class AcceptOfferErrorState extends QRState {
  AcceptOfferErrorState({required this.message});
  String message;
}

//
final class ValidationRequestsLoadingState extends QRState {}

final class ValidationRequestsSuccessState extends QRState {}

final class ValidateRequestsErrorState extends QRState {
  ValidateRequestsErrorState({required this.message});
  String message;
}

///
final class RejectOfferLoadingState extends QRState {
  final int offerId;

  RejectOfferLoadingState({required this.offerId});
}

final class RejectOfferSuccessState extends QRState {}

final class RejectOfferErrorState extends QRState {
  RejectOfferErrorState({required this.message});
  String message;
}
