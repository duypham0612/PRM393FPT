import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project/lab_11/screens/task_list_screen.dart';
import 'package:flutter_project/lab_11/repository/task_repository.dart';

void main() {
  testWidgets('Integration Test: Đóng gói toàn bộ luồng tạo -> xem -> sửa -> kiểm tra kết quả', (WidgetTester tester) async {
    final repository = TaskRepository();
    await tester.pumpWidget(MaterialApp(home: TaskListScreen(repository: repository)));

    // Luồng 1: Tạo Task "Original title"
    await tester.enterText(find.byKey(const Key('taskInputTextField')), 'Original title');
    await tester.tap(find.byKey(const Key('taskAddButton')));
    await tester.pump();
    expect(find.text('Original title'), findsOneWidget);

    // Luồng 2: Tap mở màn hình Chi tiết
    await tester.tap(find.text('Original title'));
    await tester.pumpAndSettle();

    // Luồng 3: Sửa đổi tiêu đề thành "Updated title" và nhấn lưu
    await tester.enterText(find.byKey(const Key('detailTitleField')), 'Updated title');
    await tester.tap(find.byKey(const Key('taskSaveButton')));
    await tester.pumpAndSettle(); // Quay lại màn hình chính

    // Luồng 4: Kiểm tra xem màn hình chính đã hiển thị giá trị mới cập nhật hay chưa
    expect(find.text('Updated title'), findsOneWidget);
    expect(find.text('Original title'), findsNothing);
  });
}