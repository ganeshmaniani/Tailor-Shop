import 'package:flutter/material.dart';

import '../core/constants/app_color.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
            color: AppColors.primaryColor,
            backgroundColor: Colors.grey.shade200));
  }
}
