import 'package:flutter/material.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../models/clothing_item.dart';
import '../services/closet_service.dart';

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({super.key});

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  final ClosetService _closetService = ClosetService();

  List<ClothingItem> _items = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems({bool showLoading = true}) async {
    if (showLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final items = await _closetService.getItems();
      if (!mounted) return;
      setState(() {
        _items = items;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted && showLoading) {
        setState(() => _isLoading = false);
      }
    }
  }

  String? _resolveImageUrl(ClothingItem item) {
    final value = item.photoUrl?.trim().isNotEmpty == true
        ? item.photoUrl!.trim()
        : item.photo?.trim();
    if (value == null || value.isEmpty) return null;

    final uri = Uri.tryParse(value);
    if (uri == null) return null;
    if (uri.hasScheme) return value;

    return Uri.parse(ApiConstants.baseUrl).resolve(value).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orangeLinen,
      appBar: AppBar(
        title: const Text('Digital Closet'),
        backgroundColor: AppColors.orangeLinen,
        actions: [
          IconButton(
            onPressed: () => _loadItems(showLoading: false),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh closet',
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_errorMessage != null) {
      return _RefreshableContent(
        onRefresh: () => _loadItems(showLoading: false),
        child: Center(
          child: _MessageState(
            icon: Icons.cloud_off_outlined,
            title: 'Closet gagal dimuat',
            message: _errorMessage!,
            action: FilledButton.icon(
              onPressed: () => _loadItems(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba lagi'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.azureSanMarino,
                foregroundColor: AppColors.whiteSolid,
              ),
            ),
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      return _RefreshableContent(
        onRefresh: () => _loadItems(showLoading: false),
        child: const Center(
          child: _MessageState(
            icon: Icons.checkroom_outlined,
            title: 'Closet masih kosong',
            message: 'Pakaian yang kamu simpan akan muncul di sini.',
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width < 600
            ? 2
            : width < 900
                ? 3
                : (width / 230).floor().clamp(4, 8);

        return RefreshIndicator(
          onRefresh: () => _loadItems(showLoading: false),
          color: AppColors.azureSanMarino,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your wardrobe, at a glance.',
                        style: TextStyle(
                          color: AppColors.azureMartinique,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${_items.length} ${_items.length == 1 ? 'item' : 'items'} in your closet',
                        style: const TextStyle(
                          color: AppColors.azureDolphin,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _ClothingCard(
                      item: _items[index],
                      imageUrl: _resolveImageUrl(_items[index]),
                    ),
                    childCount: _items.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RefreshableContent extends StatelessWidget {
  const _RefreshableContent({required this.onRefresh, required this.child});

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.azureSanMarino,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: child,
          ),
        ],
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: AppColors.azure57),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.azureMartinique,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.azureDolphin,
              fontSize: 14,
            ),
          ),
          if (action != null) ...[
            const SizedBox(height: 20),
            action!,
          ],
        ],
      ),
    );
  }
}

class _ClothingCard extends StatelessWidget {
  const _ClothingCard({required this.item, required this.imageUrl});

  final ClothingItem item;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.whiteSolid,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.orangePearlBrush),
        boxShadow: const [
          BoxShadow(
            color: AppColors.azureMartinique6,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: imageUrl == null
                  ? const _PhotoFallback()
                  : Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const _PhotoFallback(),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const _PhotoFallback(isLoading: true);
                      },
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.azureMartinique,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.azureDolphin,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _parseColor(item.colorHex),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.orangePearlBrush),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item.color,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.azureDolphin,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String value) {
    final hex = value.replaceFirst('#', '');
    final parsed = int.tryParse(hex, radix: 16);
    return parsed == null ? AppColors.orangePearlBrush : Color(0xFF000000 | parsed);
  }
}

class _PhotoFallback extends StatelessWidget {
  const _PhotoFallback({this.isLoading = false});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.orangePearlBrush.withValues(alpha: 0.45),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(
                Icons.checkroom_rounded,
                size: 42,
                color: AppColors.azure57,
              ),
      ),
    );
  }
}
