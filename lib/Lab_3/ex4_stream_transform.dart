import 'dart:async';

Future<void> runExercise4() async {
  Stream<int> stream = Stream.fromIterable([1, 2, 3, 4, 5]);

  stream
      .map((e) => e * e) // bình phương
      .where((e) => e % 2 == 0) // lọc số chẵn
      .listen((value) {
    print(value);
  });

  await Future.delayed(Duration(seconds: 1));
}