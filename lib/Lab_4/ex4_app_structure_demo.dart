import 'package:flutter/material.dart';

class AppStructureDemo extends StatefulWidget {
  const AppStructureDemo({super.key});

  @override
  State<AppStructureDemo> createState() => _AppStructureDemoState();
}

class _AppStructureDemoState extends State<AppStructureDemo> {
  // Trạng thái bật/tắt Dark Mode
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    // Định nghĩa ThemeData động dựa trên trạng thái biến _isDarkMode
    return Theme(
      data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Exercise 4: Structure & Theme'),
          actions: [
            // Nút chuyển đổi Theme nhanh trên AppBar
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                size: 80,
                color: _isDarkMode ? Colors.yellow : Colors.orange,
              ),
              const SizedBox(height: 16),
              Text(
                _isDarkMode ? 'Dark Mode Active' : 'Light Mode Active',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        // FloatingActionButton thực hiện thay đổi Theme khi nhấn vào
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isDarkMode = !_isDarkMode;
            });
          },
          tooltip: 'Toggle Theme',
          child: const Icon(Icons.transform),
        ),
      ),
    );
  }
}