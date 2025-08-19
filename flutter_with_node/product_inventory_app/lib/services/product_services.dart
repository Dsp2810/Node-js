import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductServices {
  // Make sure to use your local IP if you're testing on a physical device!
  // static const String baseUrl = "http://192.168.0.123:5000/api";
  // static const String baseUrl = "https://node-js-oerf.onrender.com/api";
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
    required int quantity,
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
          "quantity": quantity,
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

  /// Upload product with image file (from gallery or camera)
  static Future<Map<String, dynamic>> uploadProductWithImage({
    required String name,
    required double price,
    required String description,
    required File file,
    required bool isFav,
    required int quantity,
    required String userId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'data': 'No token found'};
      }

      var uri = Uri.parse("$baseUrl/products/upload");
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['name'] = name;
      request.fields['price'] = price.toString();
      request.fields['description'] = description;
      request.fields['isFav'] = isFav.toString();
      request.fields['userId'] = userId;
      request.fields['quantity'] = quantity.toString();

      request.files.add(await http.MultipartFile.fromPath('image', file.path));

      var response = await request.send();
      final resBody = await response.stream.bytesToString();
      final resData = jsonDecode(resBody);

      if (response.statusCode == 201) {
        return {'success': true, 'data': resData};
      } else {
        return {'success': false, 'data': resData['msg'] ?? 'Upload failed'};
      }
    } catch (err) {
      return {'success': false, 'data': "Error: $err"};
    }
  }

  static Future<Map<String, dynamic>> UpadteProduct({
    required String name,
    required String ProductId,
    required double price,
    required String description,
    required String imageUrl,
    required int quantity,
    required bool isFav,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'data': 'No token found'};
      }

      final res = await http.put(
        Uri.parse("$baseUrl/products/edit/$ProductId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
          "quantity": quantity,
          'image': imageUrl,
          'isFav': isFav,
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'data': data['msg'] ?? 'Failed to Update product',
        };
      }
    } catch (err) {
      return {'success': false, 'data': "Error: $err"};
    }
  }
}
