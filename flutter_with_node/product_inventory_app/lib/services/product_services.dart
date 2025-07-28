import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductServices {
  // Make sure to use your local IP if you're testing on a physical device!
  static const String baseUrl = "http://localhost:5000/api";

  /// Fetch all products
  static Future<Map<String, dynamic>> fetchProduct() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'data': "No token found"};
      }

      final res = await http.get(
        Uri.parse("$baseUrl/products"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'data': data['msg'] ?? 'Failed to fetch products',
        };
      }
    } catch (err) {
      return {'success': false, 'data': "Error: $err"};
    }
  }

  /// Create/add a new product
  static Future<Map<String, dynamic>> createProduct({
    required String name,
    required double price,
    required String description,
    required String imageUrl,
    required bool isFav,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'data': 'No token found'};
      }

      final res = await http.post(
        Uri.parse("$baseUrl/products/add"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
          'image': imageUrl,
          'isFav': isFav,
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'data': data['msg'] ?? 'Failed to add product',
        };
      }
    } catch (err) {
      return {'success': false, 'data': "Error: $err"};
    }
  }
}
