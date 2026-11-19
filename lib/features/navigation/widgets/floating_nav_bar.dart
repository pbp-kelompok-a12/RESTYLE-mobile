import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _icons = <IconData>[
    Icons.calendar_month_rounded,
    Icons.auto_awesome_rounded,
    Icons.checkroom_rounded,
    Icons.groups_rounded,
    Icons.person_rounded,
  ];

  static const _labels = <String>[
    'Planner',
    'Mixmatch',
    'Closet',
    'Community',
    'Profile',
  ];

  static const double _barPadding = 14;
  static const double _gap = 8;
  static const double _itemHeight = 56;
  static const double _activeRatio = 1.7; // lebar aktif = 1.7x lebar non-aktif

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.all(_barPadding),
              decoration: const BoxDecoration(
                color: AppColors.azure57,
                borderRadius: BorderRadius.all(Radius.circular(999)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.azureMartinique6,
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final count = _icons.length;
                  final available =
                      constraints.maxWidth - _gap * (count - 1);
                  final itemWidth = available / (count - 1 + _activeRatio);
                  final activeWidth = itemWidth * _activeRatio;

                  return Row(
                    children: List.generate(count, (index) {
                      final isActive = index == currentIndex;
                      return Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 0 : _gap,
                        ),
                        child: Semantics(
                          button: true,
                          selected: isActive,
                          label: _labels[index],
                          child: Tooltip(
                            message: _labels[index],
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => onTap(index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeInOutCubic,
                                width: isActive ? activeWidth : itemWidth,
                                height: _itemHeight,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? AppColors.orangeDairyCream
                                      : AppColors.azureSanMarino,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(999),
                                  ),
                                ),
                                child: Icon(
                                  _icons[index],
                                  size: 28,
                                  color: isActive
                                      ? AppColors.azureMartinique
                                      : AppColors.whiteSolid,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}