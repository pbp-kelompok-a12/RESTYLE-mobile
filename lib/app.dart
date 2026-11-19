import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'features/auth/screens/login_screen.dart';

class RestyleApp extends StatelessWidget {
  const RestyleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RESTYLE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.orangeTumbleweed,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
