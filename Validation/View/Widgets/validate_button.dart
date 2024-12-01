import 'package:flutter/material.dart';
import 'package:promo/constant/text_style.dart';
import 'package:sizer/sizer.dart';

class ValidateButton extends StatelessWidget {
  const ValidateButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.color,
    required this.icon,
  });
  final String title;
  final Color color;
  final void Function() onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: color),
      onPressed: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            color: Colors.white,
            icon,
            size: 15.sp,
          ),
          SizedBox(width: 2.w, height: 0.0),
          Text(
            textAlign: TextAlign.center,
            title,
            style: AppTextStyles.defaultStyle(
                color: Colors.white, FontWeight.bold, 10.sp),
          )
        ],
      ),
    );
  }
}
