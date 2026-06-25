class Task {
  final String id;
  String title;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false, // Mặc định chưa hoàn thành
  });

  void toggle() {
    isCompleted = !isCompleted;
  }
}
