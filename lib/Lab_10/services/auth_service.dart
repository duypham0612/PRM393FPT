import 'dart:convert';
import 'package:flutter/foundation.dart'; // Bắt buộc thêm dòng này để kiểm tra môi trường kWeb
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Đăng nhập qua API thật của DummyJSON (Tích hợp cơ chế tự động Mock khi chạy trên Web Chrome)
  static Future<bool> loginWithApi(String username, String password) async {
    // 🟢 KIỂM TRA: Nếu chạy trên Chrome (Web) -> Chuyển sang cơ chế MOCK LOGIN của Lab 10.1 luôn để tránh lỗi CORS
    if (kIsWeb) {
      if (username == 'emilys' && password == 'emilyspass') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', 'mock_token_for_chrome_web_12345');
        await prefs.setString('user_name', 'Emily Smith (Mock Web)');
        await prefs.setString('user_email', 'emily.smith@example.com');
        return true;
      }
      return false;
    }

    // 📱 NẾU CHẠY TRÊN MOBILE (ANDROID/IOS): Vẫn giữ nguyên gọi API thật của DummyJSON như cũ
    final url = Uri.parse('https://dummyjson.com/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_name', data['firstName'] + " " + data['lastName']);
        await prefs.setString('user_email', data['email']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Đăng xuất xóa sạch Session (Lab 10.3)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}