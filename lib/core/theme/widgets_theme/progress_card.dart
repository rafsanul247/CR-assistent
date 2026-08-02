import 'package:cr_app/core/constants/colors.dart';
import 'package:cr_app/core/constants/sizes.dart';
import 'package:cr_app/core/helpers/device_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key, controller, required this.progressValue});

  // final ProgressCardController progressCardController;
  final dynamic progressValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 125.h,
      width: context.screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: context.isDark ? UColors.progCardDark : UColors.progCardLight,
        border: Border.all(color: context.isDark ? UColors.progCardDarkBorder : UColors.progCardLightBorder,),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Overall progress",
              style: TextStyle(fontSize: USizes.fontSizeSm.spMin),
            ),
            Text(
              "Keep going",
              style: TextStyle(fontSize: USizes.fontSizeMd.spMin),
            ),
            10.verticalSpace,
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 8.h,
                color: Colors.white,
                backgroundColor: Colors.grey,
              ),
            ),
            4.verticalSpace,
            Align(
              alignment: AlignmentGeometry.centerRight,
              child: Text(
                "${(progressValue * 100).toInt()}% completed",
                style: TextStyle(fontSize: 12.spMin),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
