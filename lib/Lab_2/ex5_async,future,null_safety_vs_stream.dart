import 'dart:async';

void main() async {
  await loadData();

  // null safety
  String? name;
  print("Name: $name");

  // ??
  String displayName = name ?? "Guest";
  print("Display: $displayName");

  // !
  String notNull = "Hello";
  print(notNull!);

  // Stream
  Stream<int> stream = Stream.periodic(
    Duration(seconds: 1),
    (count) => count,
  ).take(3);

  await for (var value in stream) {
    print("Stream: $value");
  }
}

// Future
Future<void> loadData() async {
  print("Loading...");
  await Future.delayed(Duration(seconds: 2));
  print("Done!");
}