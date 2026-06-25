import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project/lab_11/models/task_model.dart';
import 'package:flutter_project/lab_11/repository/task_repository.dart';

void main() {
  group('TaskRepository Unit Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository(); // Khởi tạo mới trước mỗi bài test
    });

    test('Thêm task mới thành công', () {
      final task = Task(id: '10', title: 'Đi chợ');
      repository.addTask(task);

      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.title, 'Đi chợ');
    });

    test('Xóa task dựa theo ID thành công', () {
      final task = Task(id: '20', title: 'Đọc sách');
      repository.addTask(task);
      repository.deleteTask('20');

      expect(repository.tasks.isEmpty, true);
    });

    test('Cập nhật tiêu đề của task thành công', () {
      final task = Task(id: '30', title: 'Code Java');
      repository.addTask(task);
      repository.updateTask('30', 'Code Flutter Xịn');

      expect(repository.tasks.first.title, 'Code Flutter Xịn');
    });
  });
}