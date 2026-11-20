
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/post.dart';

class CommunityService {
  final ApiClient _apiClient = ApiClient();

  Future<List<CommunityPost>> getPosts() async {
    final url =
        '${ApiConstants.baseUrl}/community/api/v1/posts/';

    final response = await _apiClient.get(url);

    final postsJson = response['posts'] as List<dynamic>;

    return postsJson.map((post) {
      return CommunityPost.fromJson(
        Map<String, dynamic>.from(post as Map),
      );
    }).toList();
  }
}
