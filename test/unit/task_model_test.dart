import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project/lab_11/models/task_model.dart';

void main() {
  group('Task Model Unit Tests', () {
    test('Kiểm tra giá trị hoàn thành mặc định phải là false', () {
      // 1. Arrange
      final task = Task(id: '1', title: 'Học bài Flutter');

      // 3. Assert
      expect(task.isCompleted, false);
    });

    test('Hàm toggle() phải chuyển đổi qua lại giữa true và false', () {
      // 1. Arrange
      final task = Task(id: '1', title: 'Làm Lab 11');

      // 2. Act
      task.toggle();
      // 3. Assert
      expect(task.isCompleted, true);

      // 2. Act tiếp lần nữa
      task.toggle();
      // 3. Assert
      expect(task.isCompleted, false);
    });
  });
}