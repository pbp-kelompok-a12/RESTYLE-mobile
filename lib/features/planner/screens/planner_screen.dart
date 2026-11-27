import 'package:flutter/material.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../closet/models/clothing_item.dart';
import '../../closet/services/closet_service.dart';
import '../services/planner_service.dart';

/// First iteration of the mobile planner: weekly layout and visual foundation.
class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final PlannerService _plannerService = PlannerService();
  final ClosetService _closetService = ClosetService();
  late DateTime _weekStart;
  late DateTime _selectedDate;
  Map<String, Map<String, dynamic>> _weekSlots = {};
  // Lazy initialization also survives hot reloads that add this state field.
  late Map<int, ClothingItem> _itemsById = <int, ClothingItem>{};
  Future<List<ClothingItem>>? _closetItemsFuture;
  bool _isLoadingWeek = true;
  String? _weekError;
  int _weekRequestId = 0;

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
    _loadWeek();
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

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  Future<void> _loadWeek() async {
    final requestId = ++_weekRequestId;
    setState(() {
      _isLoadingWeek = true;
      _weekError = null;
      _weekSlots = {};
    });
    try {
      final results = await Future.wait<dynamic>([
        _plannerService.getWeek(_weekStart),
        _closetItemsFuture ??= _closetService.getItems(),
      ]);
      final response = results[0] as Map<String, dynamic>;
      final items = results[1] as List<ClothingItem>;
      final rawSlots = response['slots'];
      final slots = <String, Map<String, dynamic>>{};
      if (rawSlots is List) {
        for (final rawSlot in rawSlots.whereType<Map>()) {
          final slot = Map<String, dynamic>.from(rawSlot);
          final date = slot['date']?.toString();
          if (date != null) slots[date] = slot;
        }
      }
      if (!mounted || requestId != _weekRequestId) return;
      setState(() {
        _weekSlots = slots;
        _itemsById = {for (final item in items) item.id: item};
        _isLoadingWeek = false;
      });
    } catch (error) {
      if (!mounted || requestId != _weekRequestId) return;
      _closetItemsFuture = null;
      setState(() {
        _weekError = error.toString().replaceFirst('Exception: ', '');
        _isLoadingWeek = false;
      });
    }
  }

  void _moveWeek(int offset) {
    final selectedWeekday =
        _selectedDate.difference(_weekStart).inDays.clamp(0, 6).toInt();
    setState(() {
      _weekStart = _weekStart.add(Duration(days: 7 * offset));
      _selectedDate = _weekStart.add(Duration(days: selectedWeekday));
    });
    _loadWeek();
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
                final slot = _weekSlots[_dateKey(date)];
                final hasPlan = slot?['plan'] is Map;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index == 6 ? 0 : 4),
                    child: _DayTile(
                      weekday: _weekdays[index],
                      day: '${date.day}',
                      isToday: isToday,
                      isSelected: isSelected,
                      hasPlan: hasPlan,
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
            if (_isLoadingWeek)
              const _SelectedDaySlot.loading()
            else if (_weekError != null)
              _SelectedDaySlot.error(
                message: _weekError!,
                onRetry: _loadWeek,
              )
            else
              _SelectedDaySlot(
                slot: _weekSlots[_dateKey(_selectedDate)],
                itemsById: _itemsById,
              ),
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
    required this.hasPlan,
    required this.onTap,
  });

  final String weekday;
  final String day;
  final bool isToday;
  final bool isSelected;
  final bool hasPlan;
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
                  if (hasPlan) ...[
                    const SizedBox(height: 3),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: AppColors.greenEcoLeaf,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
}

class _SelectedDaySlot extends StatelessWidget {
  const _SelectedDaySlot({this.slot, this.itemsById = const {}})
      : message = null,
        onRetry = null,
        loading = false;

  const _SelectedDaySlot.loading()
      : slot = null,
        itemsById = const {},
        message = null,
        onRetry = null,
        loading = true;

  const _SelectedDaySlot.error({required this.message, required this.onRetry})
      : slot = null,
        itemsById = const {},
        loading = false;

  final Map<String, dynamic>? slot;
  final Map<int, ClothingItem> itemsById;
  final String? message;
  final VoidCallback? onRetry;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final rawPlan = slot?['plan'];
    final plan = rawPlan is Map ? Map<String, dynamic>.from(rawPlan) : null;
    final rawOutfit = plan?['outfit'];
    final outfit = rawOutfit is Map
        ? Map<String, dynamic>.from(rawOutfit)
        : null;
    final outfitName = outfit?['name']?.toString();
    final tags = outfit?['tags'];
    final status = slot?['status']?.toString();

    return Container(
      constraints: const BoxConstraints(minHeight: 174),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteSolid,
        border: Border.all(color: AppColors.azure57, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.azureSanMarino),
            )
          : message != null
              ? _LoadError(message: message!, onRetry: onRetry!)
              : outfit == null
                  ? const _EmptyPlan()
                  : _PlannedOutfit(
                      name: outfitName?.isNotEmpty == true
                          ? outfitName!
                          : 'Outfit terencana',
                      status: status,
                      tags: tags is List ? tags : const [],
                      outfitItems: outfit?['items'] is Map
                          ? Map<String, dynamic>.from(outfit!['items'] as Map)
                          : const {},
                      itemsById: itemsById,
                    ),
    );
  }
}

class _EmptyPlan extends StatelessWidget {
  const _EmptyPlan();

  @override
  Widget build(BuildContext context) => const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline_rounded,
              color: AppColors.azurePoloBlue, size: 40),
          SizedBox(height: 10),
          Text(
            'Belum ada outfit',
            style: TextStyle(
              color: AppColors.azureSanMarino,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Outfit untuk hari terpilih akan muncul di sini.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.azureDolphin, fontSize: 12),
          ),
        ],
      );
}

class _PlannedOutfit extends StatelessWidget {
  const _PlannedOutfit({
    required this.name,
    required this.status,
    required this.tags,
    required this.outfitItems,
    required this.itemsById,
  });

  final String name;
  final String? status;
  final List<dynamic> tags;
  final Map<String, dynamic> outfitItems;
  final Map<int, ClothingItem> itemsById;

  ClothingItem? _piece(String slot) {
    final id = outfitItems[slot];
    if (id is! num) return null;
    return itemsById[id.toInt()];
  }

  List<ClothingItem> get _accessories {
    final ids = outfitItems['accessories'];
    if (ids is! List) return const [];
    return ids
        .whereType<num>()
        .map((id) => itemsById[id.toInt()])
        .whereType<ClothingItem>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isWashing = status == 'washing';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [_StatusPill(isWashing: isWashing)],
        ),
        const SizedBox(height: 10),
        _OutfitFlat(
          top: _piece('top'),
          bottom: _piece('bottom'),
          shoes: _piece('shoes'),
          outerwear: _piece('outerwear'),
          dress: _piece('dresses'),
          accessories: _accessories,
        ),
        const SizedBox(height: 14),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.azureSanMarino,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            tags.map((tag) => tag.toString()).join(' · '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.azureDolphin,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }
}

class _OutfitFlat extends StatelessWidget {
  const _OutfitFlat({
    required this.top,
    required this.bottom,
    required this.shoes,
    required this.outerwear,
    required this.dress,
    required this.accessories,
  });

  final ClothingItem? top;
  final ClothingItem? bottom;
  final ClothingItem? shoes;
  final ClothingItem? outerwear;
  final ClothingItem? dress;
  final List<ClothingItem> accessories;

  @override
  Widget build(BuildContext context) => Container(
        height: 220,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.orangeLinen,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            if (outerwear != null)
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(child: _OutfitPiece(item: outerwear)),
                    if (dress == null) const Expanded(child: SizedBox.shrink()),
                  ],
                ),
              ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: _OutfitPiece(item: dress ?? top),
                  ),
                  if (dress == null)
                    Expanded(flex: 5, child: _OutfitPiece(item: bottom)),
                  Expanded(flex: 3, child: _OutfitPiece(item: shoes)),
                ],
              ),
            ),
            if (accessories.isNotEmpty)
              Expanded(
                flex: 1,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: accessories.length.clamp(0, 4).toInt(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) =>
                      _OutfitPiece(item: accessories[index]),
                ),
              ),
          ],
        ),
      );
}

class _OutfitPiece extends StatelessWidget {
  const _OutfitPiece({required this.item});

  final ClothingItem? item;

  String? _imageUrl(ClothingItem item) {
    final value = item.photoUrl?.trim().isNotEmpty == true
        ? item.photoUrl!.trim()
        : item.photo?.trim();
    if (value == null || value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    if (uri == null) return null;
    return uri.hasScheme
        ? value
        : Uri.parse(ApiConstants.baseUrl).resolve(value).toString();
  }

  Color _swatchColor() {
    final value = item?.colorHex.replaceFirst('#', '');
    final parsed = value == null ? null : int.tryParse(value, radix: 16);
    return parsed == null
        ? AppColors.orangePearlBrush
        : Color(0xFF000000 | parsed);
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = item;
    if (currentItem == null) return const SizedBox.expand();
    final imageUrl = _imageUrl(currentItem);
    return Padding(
      padding: const EdgeInsets.all(3),
      child: imageUrl == null
          ? _PieceFallback(color: _swatchColor())
          : Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  _PieceFallback(color: _swatchColor()),
              loadingBuilder: (context, child, progress) => progress == null
                  ? child
                  : const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
            ),
    );
  }
}

class _PieceFallback extends StatelessWidget {
  const _PieceFallback({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.orangePearlBrush),
          ),
        ),
      );
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.isWashing});

  final bool isWashing;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: isWashing ? AppColors.pillWashingBg : AppColors.pillReadyBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          isWashing ? 'Dicuci' : 'Siap',
          style: TextStyle(
            color: isWashing
                ? AppColors.pillWashingText
                : AppColors.pillReadyText,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_rounded,
              color: AppColors.azureDolphin, size: 32),
          const SizedBox(height: 8),
          Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.azureDolphin, fontSize: 12),
          ),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Coba lagi'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.azureSanMarino,
            ),
          ),
        ],
      );
}
