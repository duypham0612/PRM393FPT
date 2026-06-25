import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project/lab_11/screens/task_list_screen.dart';
import 'package:flutter_project/lab_11/repository/task_repository.dart';

void main() {
  testWidgets('Test Trạng thái trống và Thêm nhiều Task thành công', (WidgetTester tester) async {
    final repository = TaskRepository();

    // Nạp Widget vào môi trường test ảo
    await tester.pumpWidget(MaterialApp(home: TaskListScreen(repository: repository)));

    // 1. Kiểm tra trạng thái Empty ban đầu
    expect(find.text('No tasks yet. Add one!'), findsOneWidget);

    // 2. Giả lập nhập text và click nút Thêm Task 1
    await tester.enterText(find.byKey(const Key('taskInputTextField')), 'Task Số 1');
    await tester.tap(find.byKey(const Key('taskAddButton')));
    await tester.pump(); // Cập nhật lại giao diện (Render)

    expect(find.text('Task Số 1'), findsOneWidget);
    expect(find.text('No tasks yet. Add one!'), findsNothing);

    // 3. Thêm tiếp Task số 2 để xác thực đa nhiệm hiển thị
    await tester.enterText(find.byKey(const Key('taskInputTextField')), 'Task Số 2');
    await tester.tap(find.byKey(const Key('taskAddButton')));
    await tester.pump();

    expect(find.text('Task Số 1'), findsOneWidget);
    expect(find.text('Task Số 2'), findsOneWidget);
  });
}