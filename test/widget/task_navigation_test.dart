import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project/lab_11/models/task_model.dart';
import 'package:flutter_project/lab_11/screens/task_list_screen.dart';
import 'package:flutter_project/lab_11/repository/task_repository.dart';

void main() {
  testWidgets('Test điều hướng từ Danh sách sang màn hình Chi tiết Task', (WidgetTester tester) async {
    final repository = TaskRepository();
    repository.addTask(Task(id: 'abc', title: 'Task Thử Nghiệm Xem Chi Tiết'));

    await tester.pumpWidget(MaterialApp(home: TaskListScreen(repository: repository)));

    // Nhấp chọn phần tử Task trên danh sách
    await tester.tap(find.text('Task Thử Nghiệm Xem Chi Tiết'));
    await tester.pumpAndSettle(); // Chờ hiệu ứng chuyển màn hình hoàn tất hoàn toàn

    // Xác thực các thành phần trên màn hình mới xuất hiện đúng cấu trúc đề bài
    expect(find.text('Task Detail'), findsOneWidget);
    expect(find.byKey(const Key('detailTitleField')), findsOneWidget);
  });
}