import 'package:flutter/material.dart';
import 'package:tailor_shop/core/constants/app_color.dart';

class CustomSmallButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final bool isIcon;
  final IconData? icon;
  const CustomSmallButton(
      {super.key,
      required this.label,
      required this.onTap,
      this.color = AppColors.primaryColor,
      this.isIcon = false,
      this.textColor = Colors.white,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            if (isIcon && icon != null) Icon(icon, size: 18, color: textColor),
          ],
        ),
      ),
    );
  }
}
