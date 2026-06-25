import 'package:flutter/material.dart';
import 'repository/task_repository.dart';
import 'screens/task_list_screen.dart';

void main() {
  final TaskRepository taskRepository = TaskRepository();
  runApp(TasklyApp(repository: taskRepository));
}

class TasklyApp extends StatelessWidget {
  final TaskRepository repository;
  const TasklyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: TaskListScreen(repository: repository),
    );
  }
}