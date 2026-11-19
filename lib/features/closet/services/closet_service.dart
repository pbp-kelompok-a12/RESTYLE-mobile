import 'dart:convert';
import 'dart:typed_data';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/clothing_item.dart';

class ClosetService {
  final ApiClient _apiClient = ApiClient();

  Future<List<ClothingItem>> getItems() async {
    final response = await _apiClient.getList(
      ApiConstants.closet,
      authenticated: true,
    );
    return response.map(ClothingItem.fromJson).toList();
  }

  Future<ClothingItem> createItem({
    required String name,
    required String category,
    required String color,
    required String material,
    required List<String> styles,
    required List<String> seasons,
    required List<String> weather,
    required String store,
    required String purchaseLink,
    required Uint8List photoBytes,
    required String photoFilename,
    DateTime? datePurchased,
    int? price,
  }) async {
    final fields = <String, String>{
      'name': name,
      'category': category,
      'color': color,
      'material': material,
      'styles': jsonEncode(styles),
      'seasons': jsonEncode(seasons),
      'weather': jsonEncode(weather),
      'store': store,
      'purchase_link': purchaseLink,
    };
    if (datePurchased != null) {
      fields['date_purchased'] = datePurchased
          .toIso8601String()
          .split('T')
          .first;
    }
    if (price != null) fields['price'] = price.toString();

    final response = await _apiClient.postMultipart(
      ApiConstants.closet,
      fields: fields,
      fileField: 'photo',
      fileBytes: photoBytes,
      fileName: photoFilename,
      authenticated: true,
    );
    return ClothingItem.fromJson(response);
  }

  Future<ClothingItem> getItem(int id) async {
    final response = await _apiClient.get(
      '${ApiConstants.closet}$id/',
      authenticated: true,
    );
    return ClothingItem.fromJson(response);
  }
}
