import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 1: Core Widgets'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headline Text
            const Text(
              'Welcome to Flutter UI!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),

            // Material Icon với kích thước và màu sắc tùy chỉnh
            const Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 40),
                SizedBox(width: 8),
                Text('Favorite Component', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),

            // Image.network tải ảnh từ URL
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Không thể tải ảnh. Vui lòng kiểm tra internet.');
                },
              ),
            ),
            const SizedBox(height: 16),

            // Card chứa ListTile bên trong
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text('John Doe'),
                subtitle: Text('Flutter Developer'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}