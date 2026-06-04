import 'package:flutter/material.dart';

class DebugAndFixDemo extends StatefulWidget {
  const DebugAndFixDemo({super.key});

  @override
  State<DebugAndFixDemo> createState() => _DebugAndFixDemoState();
}

class _DebugAndFixDemoState extends State<DebugAndFixDemo> {
  bool _fixedSwitchValue = false;
  DateTime? _fixedDate;

  // Hàm DatePicker nhận BuildContext hợp lệ từ widget tree
  void _showFixedDatePicker(BuildContext validContext) async {
    final DateTime? picked = await showDatePicker(
      context: validContext,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _fixedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 5: Debug & Fix UI')),
      // FIX 2: Bọc toàn bộ body bằng SingleChildScrollView để chống tràn màn hình (Overflow) trên thiết bị nhỏ
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '1. FIX: ListView inside Column',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // FIX 1: ListView lồng trong Column tạo ra lỗi "Vertical viewport was given unbounded height".
            // Giải pháp: Sử dụng thuộc tính `shrinkWrap: true` và `physics: NeverScrollableScrollPhysics()`
            // Hoặc bọc trong Expanded/SizedBox có kích thước cố định.
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) => ListTile(
                title: Text('Fixed List Item $index'),
              ),
            ),
            const Divider(),

            const Text(
              '2. FIX: Lack of State Update',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('Toggle me (State fixed)'),
              value: _fixedSwitchValue,
              onChanged: (value) {
                // FIX 3: Thêm setState() để thông báo cho Flutter render lại giao diện khi data thay đổi.
                setState(() {
                  _fixedSwitchValue = value;
                });
              },
            ),
            const Divider(),

            const Text(
              '3. FIX: DatePicker BuildContext Error',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // FIX 4: Gọi DatePicker truyền trực tiếp `context` hợp lệ từ cây widget của Screen thay vì gọi sai ngữ cảnh.
            ElevatedButton(
              onPressed: () => _showFixedDatePicker(context),
              child: const Text('Open Date Picker Safely'),
            ),
            if (_fixedDate != null) Text('Date: ${_fixedDate!.toLocal()}'),
          ],
        ),
      ),
    );
  }
}