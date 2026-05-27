void main() {
  // List
  List<int> numbers = [1, 2, 3];
  numbers.add(4);
  numbers.remove(2);

  print("List: $numbers");
  print("First element: ${numbers[0]}");

  // Operators
  int a = 10;
  int b = 5;

  print("a + b = ${a + b}");
  print("a == b: ${a == b}");
  print("a > b && b > 0: ${a > b && b > 0}");

  // Ternary
  String result = (a > b) ? "a lớn hơn b" : "b lớn hơn a";
  print(result);

  // Set
  Set<int> setNumbers = {1, 2, 2, 3};
  print("Set: $setNumbers");

  // Map
  Map<String, int> scores = {
    "Duy": 9,
    "An": 8
  };

  scores["Minh"] = 10;

  print("Map: $scores");
  print("Score of Duy: ${scores["Duy"]}");
}