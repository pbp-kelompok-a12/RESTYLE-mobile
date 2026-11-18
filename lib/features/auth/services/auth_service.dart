import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/user_profile.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    return await _apiClient.post(
      ApiConstants.register,
      body: {
        'username': username,
        'email': email,
        'password': password,
      },
    );
  }

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      body: {
        'username': username,
        'password': password,
      },
    );

    final token = response['token'];

    if (token == null) {
      throw Exception('Token tidak ditemukan dalam respons login.');
    }

    await _apiClient.saveToken(token.toString());

    return response;
  }

  Future<void> logout() async {
    try {
      await _apiClient.post(
        ApiConstants.logout,
        authenticated: true,
      );
    } finally {
      await _apiClient.clearToken();
    }
  }

  Future<UserProfile> getProfile() async {
    final response = await _apiClient.get(
      ApiConstants.profile,
      authenticated: true,
    );

    return UserProfile.fromJson(response);
  }

  Future<UserProfile> updateProfile({
    required String stylePersona,
    required String preferredStyle,
    required String consciousShoppingPriority,
    required String wardrobeGoal,
  }) async {
    final response = await _apiClient.patch(
      ApiConstants.profile,
      authenticated: true,
      body: {
        'style_persona': stylePersona,
        'preferred_style': preferredStyle,
        'conscious_shopping_priority':
            consciousShoppingPriority,
        'wardrobe_goal': wardrobeGoal,
      },
    );

    return UserProfile.fromJson(response);
  }
}