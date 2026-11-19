import 'package:flutter/material.dart';

import '../../auth/screens/profile_screen.dart';
import '../../closet/screens/closet_screen.dart';
import '../widgets/floating_nav_bar.dart';
import 'section_placeholder_screen.dart';

class AuthenticatedShell extends StatefulWidget {
  const AuthenticatedShell({
    this.initialIndex = 4,
    super.key,
  });

  final int initialIndex;

  @override
  State<AuthenticatedShell> createState() => _AuthenticatedShellState();
}

class _AuthenticatedShellState extends State<AuthenticatedShell> {
  late int _currentIndex;

  static const _pages = <Widget>[
    SectionPlaceholderScreen(
      title: 'Planner',
      icon: Icons.calendar_month_rounded,
    ),
    SectionPlaceholderScreen(
      title: 'Mixmatch',
      icon: Icons.auto_awesome_rounded,
    ),
    ClosetScreen(),
    SectionPlaceholderScreen(
      title: 'Community',
      icon: Icons.groups_rounded,
    ),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, _pages.length - 1).toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: FloatingNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
