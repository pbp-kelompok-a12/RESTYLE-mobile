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

  Future<ClothingItem> updateItem({
    required ClothingItem original,
    required String name,
    required String category,
    required String color,
    required String material,
    required List<String> styles,
    required List<String> seasons,
    required List<String> weather,
    required String store,
    required String purchaseLink,
    Uint8List? photoBytes,
    String? photoFilename,
    DateTime? datePurchased,
    int? price,
  }) async {
    final fields = <String, dynamic>{};
    if (name != original.name) fields['name'] = name;
    if (category != original.category) fields['category'] = category;
    if (color != original.color) fields['color'] = color;
    if (material != original.material) fields['material'] = material;
    if (jsonEncode(styles) != jsonEncode(original.styles)) {
      fields['styles'] = styles;
    }
    if (jsonEncode(seasons) != jsonEncode(original.seasons)) {
      fields['seasons'] = seasons;
    }
    if (jsonEncode(weather) != jsonEncode(original.weather)) {
      fields['weather'] = weather;
    }
    if (store != original.store) fields['store'] = store;
    if (purchaseLink != original.purchaseLink) {
      fields['purchase_link'] = purchaseLink;
    }
    if (datePurchased?.toIso8601String().split('T').first !=
        original.datePurchased?.toIso8601String().split('T').first) {
      fields['date_purchased'] = datePurchased
          ?.toIso8601String()
          .split('T')
          .first;
    }
    if (price != original.price) fields['price'] = price;

    final url = '${ApiConstants.closet}${original.id}/';
    final Map<String, dynamic> response;
    if (photoBytes != null) {
      if (photoFilename == null || photoFilename.isEmpty) {
        throw ArgumentError('Filename foto tidak boleh kosong.');
      }
      final multipartFields = fields.map(
        (key, value) => MapEntry(
          key,
          value is List<String> ? jsonEncode(value) : value?.toString() ?? '',
        ),
      );
      response = await _apiClient.patchMultipart(
        url,
        fields: multipartFields,
        fileField: 'photo',
        fileBytes: photoBytes,
        fileName: photoFilename,
        authenticated: true,
      );
    } else {
      response = await _apiClient.patch(url, body: fields, authenticated: true);
    }

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
