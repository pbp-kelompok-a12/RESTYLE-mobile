import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class MixMatchScreen extends StatelessWidget {
  const MixMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = {
      'Top': Icons.checkroom,
      'Bottom': Icons.style_outlined,
      'Shoes': Icons.directions_walk,
      'Accessories': Icons.diamond_outlined,
      'Outerwear': Icons.checkroom_outlined,
      'Dresses': Icons.dry_cleaning,
    };

    return Scaffold(
      backgroundColor: AppColors.orangeLinen,
      appBar: AppBar(
        title: const Text('Mix & Match'),
        backgroundColor: AppColors.orangeLinen,
        foregroundColor: AppColors.azureMartinique,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Create Your Outfit',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.azureSanMarino,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Rediscover your wardrobe.',
            style: TextStyle(
              color: AppColors.azureDolphin,
            ),
          ),
          const SizedBox(height: 24),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: categories.entries.map((entry) {
              return Card(
                elevation: 0,
                color: AppColors.whiteSolid,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(
                    color: AppColors.orangePearlBrush,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      entry.value,
                      size: 36,
                      color: AppColors.azureSanMarino,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      entry.key,
                      style: const TextStyle(
                        color: AppColors.azureMartinique,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '+ Select item',
                      style: TextStyle(
                        color: AppColors.azureDolphin,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          const TextField(
            maxLength: 100,
            decoration: InputDecoration(
              labelText: 'Outfit Name',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          const TextField(
            maxLength: 500,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Notes',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          const FilledButton(
            onPressed: null,
            child: Text('Save Outfit'),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}