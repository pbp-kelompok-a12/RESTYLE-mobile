import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<Map<String, dynamic>> get(
    String url, {
    bool authenticated = false,
  }) async {
    final response = await _request(
      'GET',
      url,
      authenticated: authenticated,
    );
    if (response is Map) return Map<String, dynamic>.from(response);
    throw Exception('Format respons API tidak sesuai.');
  }

  Future<List<Map<String, dynamic>>> getList(
    String url, {
    bool authenticated = false,
  }) async {
    final response = await _request(
      'GET',
      url,
      authenticated: authenticated,
    );
    if (response is List) {
      return response
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }
    throw Exception('Format respons API bukan berupa list.');
  }

  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    bool authenticated = false,
  }) async {
    final response = await _request(
      'POST',
      url,
      body: body,
      authenticated: authenticated,
    );
    if (response is Map) return Map<String, dynamic>.from(response);
    throw Exception('Format respons API tidak sesuai.');
  }

  Future<Map<String, dynamic>> patch(
    String url, {
    Map<String, dynamic>? body,
    bool authenticated = false,
  }) async {
    final response = await _request(
      'PATCH',
      url,
      body: body,
      authenticated: authenticated,
    );
    if (response is Map) return Map<String, dynamic>.from(response);
    throw Exception('Format respons API tidak sesuai.');
  }

  Future<dynamic> _request(
    String method,
    String url, {
    Map<String, dynamic>? body,
    bool authenticated = false,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (authenticated) {
      final token = await getToken();

      if (token == null) {
        throw Exception('Token tidak ditemukan. Silakan login.');
      }

      headers['Authorization'] = 'Token $token';
    }

    final uri = Uri.parse(url);
    late http.Response response;

    switch (method) {
      case 'GET':
        response = await http.get(uri, headers: headers);
        break;
      case 'POST':
        response = await http.post(
          uri,
          headers: headers,
          body: jsonEncode(body ?? {}),
        );
        break;
      case 'PATCH':
        response = await http.patch(
          uri,
          headers: headers,
          body: jsonEncode(body ?? {}),
        );
        break;
      default:
        throw Exception('HTTP method tidak didukung.');
    }

    final dynamic decoded = response.body.isEmpty
        ? {}
        : jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    throw Exception(
      decoded is Map
          ? decoded['detail']?.toString() ??
              decoded['message']?.toString() ??
              decoded.toString()
          : decoded.toString(),
    );
  }
}
