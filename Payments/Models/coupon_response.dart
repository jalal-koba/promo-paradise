class CouonResponse {
  final Data data;
 
  CouonResponse({
    required this.data,
   });

  factory CouonResponse.fromJson(Map<String, dynamic> json) => CouonResponse(
        data: Data.fromJson(json["data"]),
       );
}

class Data {
  final bool isValid;
  final num? discountPercentage;
  final num? price;
  final num? priceAfterDiscount;

  Data({
    required this.isValid,
    required this.discountPercentage,
    required this.price,
    required this.priceAfterDiscount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isValid: json["is_valid"],
        discountPercentage: json["discount_percentage"],
        price: json["price"],
        priceAfterDiscount: json["price_after_discount"]?.toDouble(),
      );
}
