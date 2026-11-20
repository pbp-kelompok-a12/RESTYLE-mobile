import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

/// First iteration of the mobile planner: weekly layout and visual foundation.
class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  late DateTime _weekStart;
  late DateTime _selectedDate;

  static const _weekdays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  @override
  void initState() {
    super.initState();
    _weekStart = _monday(DateTime.now());
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  DateTime _monday(DateTime date) =>
      DateTime(date.year, date.month, date.day - (date.weekday - 1));

  String _formatWeek() {
    final end = _weekStart.add(const Duration(days: 6));
    if (_weekStart.month == end.month) {
      return '${_weekStart.day}-${end.day} ${_months[end.month - 1]} ${end.year}';
    }
    return '${_weekStart.day} ${_months[_weekStart.month - 1]} - '
        '${end.day} ${_months[end.month - 1]} ${end.year}';
  }

  void _moveWeek(int offset) {
    final selectedWeekday =
        _selectedDate.difference(_weekStart).inDays.clamp(0, 6).toInt();
    setState(() {
      _weekStart = _weekStart.add(Duration(days: 7 * offset));
      _selectedDate = _weekStart.add(Duration(days: selectedWeekday));
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    final selectedIndex = _selectedDate.difference(_weekStart).inDays;
    final safeSelectedIndex = selectedIndex.clamp(0, 6).toInt();

    return Scaffold(
      backgroundColor: AppColors.orangeLinen,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: AppColors.azureSanMarino,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.12,
                ),
                children: [
                  TextSpan(text: 'Plan your\n'),
                  TextSpan(
                    text: 'outfit!',
                    style: TextStyle(
                      color: AppColors.yellowPeachYellow,
                      backgroundColor: AppColors.azureSanMarino,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _WeatherPreview(),
            const SizedBox(height: 24),
            Row(
              children: [
                _WeekArrow(
                  icon: Icons.chevron_left_rounded,
                  onTap: () => _moveWeek(-1),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      _formatWeek(),
                      style: const TextStyle(
                        color: AppColors.azureMartinique,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                _WeekArrow(
                  icon: Icons.chevron_right_rounded,
                  onTap: () => _moveWeek(1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(7, (index) {
                final date = _weekStart.add(Duration(days: index));
                final isToday = date == todayKey;
                final isSelected = index == safeSelectedIndex;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index == 6 ? 0 : 4),
                    child: _DayTile(
                      weekday: _weekdays[index],
                      day: '${date.day}',
                      isToday: isToday,
                      isSelected: isSelected,
                      onTap: () => setState(() => _selectedDate = date),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Text(
              '${_weekdays[safeSelectedIndex]}, ${_selectedDate.day} '
              '${_months[_selectedDate.month - 1]}',
              style: const TextStyle(
                color: AppColors.azureMartinique,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            const _SelectedDaySlot(),
          ],
        ),
      ),
    );
  }
}

class _WeatherPreview extends StatelessWidget {
  const _WeatherPreview();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.weatherSunnyStart, AppColors.weatherSunnyEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Row(
          children: [
            Icon(Icons.cloud_rounded, color: AppColors.whiteSolid, size: 38),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cuaca saat ini',
                    style: TextStyle(
                      color: AppColors.whiteSolid,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Info cuaca, blm ada integrasinya',
                    style: TextStyle(color: AppColors.whiteSolid, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _WeekArrow extends StatelessWidget {
  const _WeekArrow({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.yellowPeachYellow,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, color: AppColors.azureSanMarino, size: 26),
          ),
        ),
      );
}

class _DayTile extends StatelessWidget {
  const _DayTile({
    required this.weekday,
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });

  final String weekday;
  final String day;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 68,
        child: Material(
          color: AppColors.orangeLinen,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.azureSanMarino
                    : AppColors.whiteSolid,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? AppColors.azureSanMarino
                      : AppColors.orangePearlBrush,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekday,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.whiteSolid
                          : AppColors.azureDolphin,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 27,
                    height: 27,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isToday
                          ? AppColors.yellowPeachYellow
                          : AppColors.orangeLinenTransparent,
                      shape: BoxShape.circle,
                      border: isToday
                          ? Border.all(color: AppColors.yellowPeachYellow)
                          : null,
                    ),
                    child: Text(
                      day,
                      style: TextStyle(
                        color: isToday
                            ? AppColors.azureSanMarino
                            : isSelected
                                ? AppColors.whiteSolid
                                : AppColors.azureMartinique,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
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

class _SelectedDaySlot extends StatelessWidget {
  const _SelectedDaySlot();

  @override
  Widget build(BuildContext context) => Container(
        height: 174,
        decoration: BoxDecoration(
          color: AppColors.whiteSolid,
          border: Border.all(
            color: AppColors.azure57,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.azurePoloBlue,
              size: 40,
            ),
            const SizedBox(height: 10),
            const Text(
              'Pilih outfit',
              style: TextStyle(
                color: AppColors.azureSanMarino,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Outfit untuk hari terpilih akan muncul di sini.',
              style: TextStyle(
                color: AppColors.azureDolphin,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
}
