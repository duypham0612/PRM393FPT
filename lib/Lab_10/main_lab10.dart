import 'package:flutter/material.dart';
import 'services/notification_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  // Đảm bảo các dịch vụ hệ thống của Flutter được khởi tạo xong trước khi nạp Notification
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi động dịch vụ thông báo cục bộ (LO7)
  await NotificationService.initNotification();

  runApp(const Lab10FullApp());
}

class Lab10FullApp extends StatelessWidget {
  const Lab10FullApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10 Integrated App',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Bắt đầu chạy từ màn hình chờ kiểm tra Session
    );
  }
}