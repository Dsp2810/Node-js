import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  // static const String baseUrl = "http://192.168.0.115:5000/api";
  static const String baseUrl = "http://localhost:5000/api";

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email.trim(), "password": password.trim()}),
      );

      final data = jsonDecode(res.body);

      // ✅ Save token if successful
      if (res.statusCode == 200 && data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
      }

      return {'success': res.statusCode == 200, 'data': data};
    } catch (err) {
      return {'success': false, 'data': 'Error: $err'};
    }
  }

  static Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      final data = jsonDecode(res.body);

      // ✅ Save token if returned after signup
      if (res.statusCode == 200 && data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
      }
      print(data);

      return {'success': res.statusCode == 200, 'data': data};
    } catch (err) {
      return {'success': false, 'data': 'Error: $err'};
    }
  }
}
