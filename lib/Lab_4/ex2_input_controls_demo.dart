import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  // Biến lưu trữ giá trị của các Input
  double _sliderValue = 20.0;
  bool _switchValue = false;
  String? _selectedGender = 'Male';
  DateTime? _selectedDate;

  // Hàm hiển thị DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // Cập nhật State để UI thay đổi
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 2: Input Controls')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Slider Component
            Text('Volume: ${_sliderValue.round()}'),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              divisions: 10,
              label: _sliderValue.round().toString(),
              onChanged: (value) {
                setState(() => _sliderValue = value);
              },
            ),

            // 2. Switch Component
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _switchValue,
              onChanged: (value) {
                setState(() => _switchValue = value);
              },
            ),

            // 3. RadioListTile Group Component
            const Text('Gender:', style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<String>(
              title: const Text('Male'),
              value: 'Male',
              groupValue: _selectedGender,
              onChanged: (value) => setState(() => _selectedGender = value),
            ),
            RadioListTile<String>(
              title: const Text('Female'),
              value: 'Female',
              groupValue: _selectedGender,
              onChanged: (value) => setState(() => _selectedGender = value),
            ),

            // 4. Date Picker Component
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Pick a Date'),
                ),
                const SizedBox(width: 16),
                Text(
                  _selectedDate == null
                      ? 'No date chosen'
                      : 'Selected: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}