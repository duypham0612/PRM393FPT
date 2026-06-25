import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Bắt buộc phải có để dùng rootBundle

class AssetListScreen extends StatefulWidget {
  const AssetListScreen({super.key});

  @override
  State<AssetListScreen> createState() => _AssetListScreenState();
}

class _AssetListScreenState extends State<AssetListScreen> {
  List<dynamic> _assetStudents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJsonFromAssets();
  }

  // Hàm tải dữ liệu JSON từ Assets
  Future<void> _loadJsonFromAssets() async {
    try {
      // Giả lập delay 1 giây để thầy cô thấy được trạng thái Loading dữ liệu
      await Future.delayed(const Duration(seconds: 1));

      final String response = await rootBundle.loadString('assets/data/student_assets.json');
      final data = await jsonDecode(response);
      setState(() {
        _assetStudents = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 9.1 - Read JSON Assets'), backgroundColor: Colors.teal, foregroundColor: Colors.white,),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : _assetStudents.isEmpty
          ? const Center(child: Text('Không tìm thấy file hoặc dữ liệu trống.'))
          : ListView.builder(
        itemCount: _assetStudents.length,
        itemBuilder: (context, index) {
          final student = _assetStudents[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade100,
                child: Text('${student['id']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
              ),
              title: Text(student['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('MSSV: ${student['code']} | Ngành: ${student['major']}'),
            ),
          );
        },
      ),
    );
  }
}