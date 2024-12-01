abstract class VouchersStates {}

final class VouchersInitial extends VouchersStates {}

final class VouchersLooding extends VouchersStates{}

final class VouchersSuccess extends VouchersStates{}

final class VouchersChangeScreen extends VouchersStates{}

final class VouchersError extends VouchersStates{
  int code;
  String message;

  VouchersError({required this.message,  this.code=0});
}
