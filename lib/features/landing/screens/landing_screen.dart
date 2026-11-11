import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class LandingScreen extends StatelessWidget {
  static const routeName = '/';

  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/img/bunglon_hires.png', height: 250),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.azureSanMarino,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Join RESTYLE Now',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.04,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}