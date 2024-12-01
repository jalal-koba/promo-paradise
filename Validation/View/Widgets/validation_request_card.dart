import 'package:flutter/material.dart';
import 'package:promo/app/Validation/Cubit/Cubit/qr_cubit.dart';
import 'package:promo/app/Validation/View/Widgets/validate_button.dart';
import 'package:promo/app/offers/models/offer.dart';
import 'package:promo/constant/colors.dart';
import 'package:sizer/sizer.dart';

class ValidationRequestCard extends StatelessWidget {
  const ValidationRequestCard({
    super.key,
    required this.qrCubit,
    required this.offer,
  });

  final QRCubit qrCubit;
  final Offer offer;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ValidateButton(
            onPressed: () {
              qrCubit.rejectOffer(id: offer.id!);
            },
            title: 'reject',
            icon: Icons.cancel_outlined,
            color: AppColors.red.withOpacity(0.7)),
        SizedBox(width: 5.w, height: 0.0),
        ValidateButton(
          onPressed: () async {
            await qrCubit.acceptOffer(offerId: offer.id!);
          },
          title: 'Validate',
          color: AppColors.blue,
          icon: Icons.check_circle_outline,
        )
      ],
    );
  }
}
