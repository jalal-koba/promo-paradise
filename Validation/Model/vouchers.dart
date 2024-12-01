import 'package:promo/app/Institutions/models/package.dart';

class UserPackage {
  final Package package;
  final int totalVouchers;
  final int totalUsage;

  UserPackage({
    required this.package,
    required this.totalVouchers,
    required this.totalUsage,
  });

  factory UserPackage.fromJson(Map<String, dynamic> json) => UserPackage(
        package: Package.fromJson(json["package"]),
        totalVouchers: json["total_vouchers"],
        totalUsage: json["total_usage"],
      );
}
