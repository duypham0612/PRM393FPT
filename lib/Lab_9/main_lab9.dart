import 'package:flutter/material.dart';
import 'screens/asset_list_screen.dart';
import 'screens/crud_database_screen.dart';

void main() {
  runApp(const LocalStorageLabApp());
}

class LocalStorageLabApp extends StatelessWidget {
  const LocalStorageLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 9 - Local Storage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📁 Menu Thực Hành Lab 9', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16), backgroundColor: Colors.teal, foregroundColor: Colors.white),
              icon: const Icon(Icons.folder_open, size: 24),
              label: const Text('Chạy bài Lab 9.1: Đọc JSON từ Assets', style: TextStyle(fontSize: 16)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AssetListScreen())),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
              icon: const Icon(Icons.storage, size: 24),
              label: const Text('Chạy bài Lab 9.2 + 9.3: Local JSON CRUD', style: TextStyle(fontSize: 16)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CrudDatabaseScreen())),
            ),
          ],
        ),
      ),
    );
  }
}