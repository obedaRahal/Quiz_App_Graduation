

import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';

class UniversityLogo extends StatelessWidget {
  final String? logoPath;
  final double radius;

  const UniversityLogo({
    super.key,
    required this.logoPath,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    if (logoPath == null || logoPath!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppPalette.grey,
        child: Icon(
          Icons.school_outlined,
          size: radius + 2,
          color: AppPalette.greyMedium,
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundImage: AssetImage(logoPath!),
      backgroundColor: Colors.transparent,
    );
  }
}