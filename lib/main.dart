import 'package:flutter/material.dart';
import 'Lab_4/ex1_core_widgets_demo.dart';
import 'Lab_4/ex2_input_controls_demo.dart';
import 'Lab_4/ex3_layout_basics_demo.dart';
import 'Lab_4/ex4_app_structure_demo.dart';
import 'Lab_4/ex5_debug_and_fix_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Lab 4',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LabMainMenu(),
    );
  }
}

class LabMainMenu extends StatelessWidget {
  const LabMainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 4 - Flutter UI Menu')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMenuButton(context, 'Exercise 1: Core Widgets', const CoreWidgetsDemo()),
          _buildMenuButton(context, 'Exercise 2: Input Controls', const InputControlsDemo()),
          _buildMenuButton(context, 'Exercise 3: Layout Basics', LayoutBasicsDemo()),
          _buildMenuButton(context, 'Exercise 4: Structure & Theme', const AppStructureDemo()),
          _buildMenuButton(context, 'Exercise 5: Debug & Fix UI', const DebugAndFixDemo()),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, Widget targetScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
        },
        child: Text(title, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}