import 'package:flutter/material.dart';
import '../services/json_storage_service.dart';

class CrudDatabaseScreen extends StatefulWidget {
  const CrudDatabaseScreen({super.key});

  @override
  State<CrudDatabaseScreen> createState() => _CrudDatabaseScreenState();
}

class _CrudDatabaseScreenState extends State<CrudDatabaseScreen> {
  final JsonStorageService _storageService = JsonStorageService();
  List<dynamic> _allStudents = [];
  List<dynamic> _filteredStudents = [];

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocalData();
  }

  // Tải dữ liệu từ File cục bộ lên Bộ nhớ tạm RAM khi khởi động app
  Future<void> _loadLocalData() async {
    final data = await _storageService.readFromJsonFile();
    setState(() {
      _allStudents = data;
      _filteredStudents = data;
    });
  }

  // Đồng bộ danh sách tạm trên RAM xuống File JSON cứng cục bộ + Thông báo Toast
  Future<void> _saveAndRefresh(String message) async {
    await _storageService.writeToJsonFile(_allStudents);
    _filterStudents(_searchController.text); // Cập nhật lại bộ lọc tìm kiếm hiện tại
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.indigo, duration: const Duration(seconds: 1)),
    );
  }

  // Bộ lọc tìm kiếm (Client-side Search)
  void _filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStudents = _allStudents;
      } else {
        _filteredStudents = _allStudents
            .where((s) => s['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
            s['code'].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // Hiển thị BottomSheet nhập liệu Form (Dùng chung cho cả Thêm và Sửa)
  void _showFormDialog(int? id, Map<String, dynamic>? studentData) {
    if (studentData != null) {
      _nameController.text = studentData['name'];
      _codeController.text = studentData['code'];
    } else {
      _nameController.clear();
      _codeController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 20, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(studentData == null ? '➕ Thêm sinh viên mới' : '📝 Cập nhật thông tin',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
            const SizedBox(height: 12),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Họ và tên', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _codeController, decoration: const InputDecoration(labelText: 'Mã số sinh viên', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
              onPressed: () {
                if (_nameController.text.trim().isEmpty || _codeController.text.trim().isEmpty) return;

                if (studentData == null) {
                  // HÀNH ĐỘNG: THÊM MỚI (Tự sinh ID tăng tiến)
                  final int newId = _allStudents.isEmpty ? 1 : (_allStudents.map((e) => e['id'] as int).reduce((a, b) => a > b ? a : b) + 1);
                  _allStudents.add({
                    'id': newId,
                    'name': _nameController.text.trim(),
                    'code': _codeController.text.trim(),
                  });
                  _saveAndRefresh('Đã thêm và tự động lưu JSON!');
                } else {
                  // HÀNH ĐỘNG: CẬP NHẬT / SỬA
                  final index = _allStudents.indexWhere((element) => element['id'] == id);
                  if (index != -1) {
                    _allStudents[index]['name'] = _nameController.text.trim();
                    _allStudents[index]['code'] = _codeController.text.trim();
                    _saveAndRefresh('Đã cập nhật thay đổi vào file JSON!');
                  }
                }
                Navigator.pop(ctx);
              },
              child: const Text('Xác nhận lưu dữ liệu'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // HÀNH ĐỘNG: XÓA (Có hiển thị hộp thoại cảnh báo xác nhận - Điểm cộng Bonus)
  void _deleteStudent(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('⚠️ Xác nhận xóa?'),
        content: const Text('Dữ liệu này sẽ bị xóa vĩnh viễn khỏi file lưu trữ JSON cục bộ.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              _allStudents.removeWhere((element) => element['id'] == id);
              _saveAndRefresh('Đã xóa dữ liệu thành công!');
              Navigator.pop(ctx);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 9.2 + 9.3 - Local JSON CRUD'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: Column(
        children: [
          // Thanh tìm kiếm (Search Bar) liên tục lọc khi gõ chữ
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterStudents,
              decoration: InputDecoration(
                labelText: 'Tìm kiếm theo tên hoặc MSSV...',
                prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          // Danh sách hiển thị kết quả từ file Local JSON
          Expanded(
            child: _filteredStudents.isEmpty
                ? const Center(child: Text('Danh sách trống hoặc không có kết quả phù hợp.'))
                : ListView.builder(
              itemCount: _filteredStudents.length,
              itemBuilder: (context, index) {
                final student = _filteredStudents[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.shade50,
                      child: Text('${student['id']}', style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(student['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('MSSV: ${student['code']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.orange), onPressed: () => _showFormDialog(student['id'], student)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteStudent(student['id'])),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () => _showFormDialog(null, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}