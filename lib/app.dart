import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'features/landing/screens/landing_screen.dart';

class RestyleApp extends StatelessWidget {
  const RestyleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RE:STYLE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.orangeLinen,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.azureSanMarino,
          primary: AppColors.azureSanMarino,
        ),
      ),
      initialRoute: LandingScreen.routeName,
      routes: {
        LandingScreen.routeName: (context) => const LandingScreen(),
        // route lain ditambah di sini nanti (login, closet, planner, community)
      },
    );
  }
}