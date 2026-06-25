import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../repository/task_repository.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final TaskRepository repository;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.repository,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _detailController;

  @override
  void initState() {
    super.initState();
    _detailController = TextEditingController(text: widget.task.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'), // Đúng tiêu đề bài Test định dạng
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('detailTitleField'), // Key bắt buộc để pass bài test
              controller: _detailController,
              decoration: const InputDecoration(
                labelText: 'Edit Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              key: const Key('taskSaveButton'), // Key bắt buộc để pass bài test
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
              onPressed: () {
                if (_detailController.text.trim().isEmpty) return;
                widget.repository.updateTask(widget.task.id, _detailController.text.trim());
                Navigator.pop(context); // Trở về danh sách cũ
              },
            ),
          ],
        ),
      ),
    );
  }
}