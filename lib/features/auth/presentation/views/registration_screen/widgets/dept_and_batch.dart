import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeptAndBatch extends StatelessWidget {
  const DeptAndBatch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Dept.
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: "Dept.",
              prefixIcon: Icon(Icons.school_outlined),
            ),
          ),
        ),

        10.horizontalSpace,

        // Batch
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: "Batch",
              prefixIcon: Icon(Icons.school_outlined),
            ),
          ),
        ),
      ],
    );
  }
}