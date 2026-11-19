import 'package:flutter/material.dart';

import 'features/auth/screens/login_screen.dart';
import 'features/community/screens/feed_screen.dart';

class RestyleApp extends StatelessWidget {
  const RestyleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RESTYLE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B7355)),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      routes: {FeedScreen.routeName: (context) => const FeedScreen()},
    );
  }
}
