import 'package:cr_app/core/constants/colors.dart';
import 'package:cr_app/core/helpers/device_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';


class ULogoAndTitle extends StatelessWidget {
  const ULogoAndTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: () {
          context.pop();
        }, icon: Icon(Icons.arrow_back_ios_new, size: 16)),
        6.horizontalSpace,
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              color: UColors.grey,
              borderRadius: BorderRadius.circular(6)
          ),
          child: Center(
            child: Image.asset(context.isDark? "assets/icons/app_icon_white.png" : "assets/icons/app_icon_black.png", height: 20, width: 20, fit: BoxFit.cover,),
          ),
        ),
        const SizedBox(width:8),
        Text("CR Assistant", style: TextStyle(fontSize: 16.spMin, fontWeight: FontWeight.bold),)
      ],
    );
  }
}