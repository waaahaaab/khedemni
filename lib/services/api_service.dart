import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'HTTP Error ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Failed to parse response: $e'};
    }
  }

  // ========================================
  // AUTH METHODS
  // ========================================

  static Future<Map<String, dynamic>> register(
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: await _getHeaders(),
        body: json.encode(userData),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: await _getHeaders(),
        body: json.encode({'email': email, 'password': password}),
      );

      final result = _handleResponse(response);
      if (result['success'] == true) {
        await saveToken(result['data']['token']);
      }
      return result;
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // ========================================
  // PASSWORD RESET METHODS
  // ========================================

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: await _getHeaders(),
        body: json.encode({'email': email}),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> verifyResetCode(
    String email,
    String code,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-reset-code'),
        headers: await _getHeaders(),
        body: json.encode({'email': email, 'code': code}),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> resetPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: await _getHeaders(),
        body: json.encode({
          'email': email,
          'code': code,
          'newPassword': newPassword,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // ========================================
  // PROFILE METHODS
  // ========================================

  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/profile'),
        headers: await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/auth/profile'),
        headers: await _getHeaders(),
        body: json.encode(profileData),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateProfileWithImage(
    Map<String, dynamic> profileData,
    String imagePath,
  ) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/auth/profile'),
      );

      final token = await getToken();
      request.headers['Authorization'] = 'Bearer $token';

      profileData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (imagePath.isNotEmpty) {
        var file = await http.MultipartFile.fromPath(
          'profile_picture',
          imagePath,
        );
        request.files.add(file);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateProfileWithImageWeb(
    Map<String, dynamic> profileData,
    Uint8List imageBytes,
    String fileName,
  ) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/auth/profile'),
      );

      final token = await getToken();
      request.headers['Authorization'] = 'Bearer $token';

      profileData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      var file = http.MultipartFile.fromBytes(
        'profile_picture',
        imageBytes,
        filename: fileName,
      );
      request.files.add(file);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // ========================================
  // OFFER METHODS
  // ========================================

  static Future<Map<String, dynamic>> createOffer(
    Map<String, dynamic> offerData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/offers'),
        headers: await _getHeaders(),
        body: json.encode(offerData),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getOffers({
    int? categoryId,
    int? limit,
  }) async {
    try {
      final params = <String, String>{};
      if (categoryId != null) params['category_id'] = categoryId.toString();
      if (limit != null) params['limit'] = limit.toString();

      final response = await http.get(
        Uri.parse('$baseUrl/offers').replace(queryParameters: params),
        headers: await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/offers/categories'),
        headers: await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> toggleFavorite(int offerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/offers/$offerId/favorite'),
        headers: await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  // ========================================
  // VISIBILITY & PUBLIC PROFILE METHODS
  // ========================================

  // Toggle visibility on home page
  static Future<Map<String, dynamic>> toggleVisibility() async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/auth/toggle-visibility'),
        headers: await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Get visible service seekers
  static Future<Map<String, dynamic>> getVisibleServiceSeekers({
    int? limit,
    String? wilaya,
  }) async {
    try {
      final params = <String, String>{};
      if (limit != null) params['limit'] = limit.toString();
      if (wilaya != null) params['wilaya'] = wilaya;

      final response = await http.get(
        Uri.parse(
          '$baseUrl/auth/visible-service-seekers',
        ).replace(queryParameters: params),
        headers: await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Get public profile of a user
  static Future<Map<String, dynamic>> getPublicProfile(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/users/$userId/public-profile'),
        headers: await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // ========================================
  // OFFER STATUS METHODS
  // ========================================

  // Toggle offer status (owner only)
  static Future<Map<String, dynamic>> toggleOfferStatus(int offerId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/offers/$offerId/status'),
        headers: await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Get single offer details
  static Future<Map<String, dynamic>> getOfferDetails(int offerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/offers/$offerId'),
        headers: await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Update an offer
  static Future<Map<String, dynamic>> updateOffer(
    int offerId,
    Map<String, dynamic> offerData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/offers/$offerId'),
        headers: await _getHeaders(),
        body: json.encode(offerData),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
