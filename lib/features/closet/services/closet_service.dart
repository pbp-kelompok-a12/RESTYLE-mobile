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

  Future<ClothingItem> getItem(int id) async {
    final response = await _apiClient.get(
      '${ApiConstants.closet}$id/',
      authenticated: true,
    );
    return ClothingItem.fromJson(response);
  }
}
