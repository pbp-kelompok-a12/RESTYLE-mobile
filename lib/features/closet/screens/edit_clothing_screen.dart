import 'package:flutter/material.dart';

import '../models/clothing_item.dart';
import 'add_clothing_screen.dart';

class EditClothingScreen extends StatelessWidget {
  const EditClothingScreen({required this.item, super.key});

  final ClothingItem item;

  @override
  Widget build(BuildContext context) {
    return ClothingFormScreen(item: item);
  }
}
