import 'dart:async';

Future<void> runExercise3() async {
  print('Start');

  scheduleMicrotask(() {
    print('Microtask');
  });

  Future(() {
    print('Event queue');
  });

  print('End');

  await Future.delayed(Duration(milliseconds: 500));
}