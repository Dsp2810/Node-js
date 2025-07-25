import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductServices {
  static const String baseUrl = "http://192.168.66.21:5000/api";

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
          'Authorization': 'Bearer $token', // important!
        },
      );
      print("Status: ${res.statusCode}");
      print("Body: ${res.body}");
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'data': data['msg'] ?? 'failed to fectch Products',
        };
      }
    } catch (err) {
      return {'success': false, 'data': "Error:$err"};
    }
  }
}
