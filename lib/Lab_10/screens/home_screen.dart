import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "Đang tải...";
  String email = "";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('user_name') ?? 'User';
      email = prefs.getString('user_email') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trang Chủ Hệ Thống'), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(radius: 40, backgroundColor: Colors.greenAccent, child: Icon(Icons.person, size: 40, color: Colors.green)),
              const SizedBox(height: 16),
              Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(email, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                icon: const Icon(Icons.logout),
                label: const Text('ĐĂNG XUẤT (CLEAR SESSION)'),
                onPressed: () async {
                  await AuthService.logout();
                  if (mounted) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}