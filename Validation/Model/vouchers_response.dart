import 'package:promo/app/Validation/Model/vouchers.dart';
import 'package:promo/app/offers/models/offer_response.dart';

class VouchersResponse {
  final Data data;
  final int code;

  VouchersResponse({
    required this.data,
    required this.code,
  });

  factory VouchersResponse.fromJson(Map<String, dynamic> json) =>
      VouchersResponse(
        data: Data.fromJson(json["data"]),
        code: json["code"],
      );
}

class Data {
  final String? qr;
  final List<UserPackage> packages;
  final List<OfferResponse> vouchersUsingHistory;
  final int totalActiveVouchers;

  Data({
    required this.qr,
    required this.packages,
    required this.vouchersUsingHistory,
    required this.totalActiveVouchers,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        qr: json["qr"],
        packages: List<UserPackage>.from(
            json["packages"].map((x) => UserPackage.fromJson(x))),
        vouchersUsingHistory: List<OfferResponse>.from(
            json["user_offers"].map((x) => OfferResponse.fromJson(x))),
        totalActiveVouchers: json["total_active_vouchers"],
      );
}
