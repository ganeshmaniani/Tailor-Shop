import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../core/constants/app_color.dart';

class DateTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPass;
  final String address;
  final String index;
  const DateTile(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.isPass,
      required this.address,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(color: AppColors.primaryColor),
      indicatorStyle: IndicatorStyle(
        drawGap: true,
        indicator: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              index,
            ),
          ),
        ),
      ),
      endChild: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // color: AppColor.lightGrey.withOpacity(.2),
          ),
          child: Text(
            address,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
