import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class SectionPlaceholderScreen extends StatelessWidget {
  const SectionPlaceholderScreen({
    required this.title,
    required this.icon,
    super.key,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orangeLinen,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.orangeLinen,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: AppColors.azureSanMarino),
            const SizedBox(height: 16),
            Text(
              '$title segera hadir',
              style: const TextStyle(
                color: AppColors.azureMartinique,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
