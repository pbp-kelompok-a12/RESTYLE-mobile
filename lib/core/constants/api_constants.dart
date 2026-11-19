class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  static const String register = '$baseUrl/api/auth/register/';
  static const String login = '$baseUrl/api/auth/login/';
  static const String logout = '$baseUrl/api/auth/logout/';
  static const String profile = '$baseUrl/api/auth/profile/';
  static const String closet = '$baseUrl/api/closet/';

  static const String planner = '$baseUrl/api/planner/';
}
