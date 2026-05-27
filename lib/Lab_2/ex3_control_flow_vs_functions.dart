void main() {
  int score = 85;

  // if/else
  if (score >= 90) {
    print("Excellent");
  } else if (score >= 75) {
    print("Good");
  } else {
    print("Average");
  }

  // switch
  int day = 3;
  switch (day) {
    case 1:
      print("Monday");
      break;
    case 2:
      print("Tuesday");
      break;
    case 3:
      print("Wednesday");
      break;
    default:
      print("Other day");
  }

  // for
  for (int i = 0; i < 3; i++) {
    print("For: $i");
  }

  // for-in
  List<int> nums = [1, 2, 3];
  for (var n in nums) {
    print("For-in: $n");
  }

  // forEach
  nums.forEach((n) {
    print("forEach: $n");
  });

  // function
  print("Sum: ${sum(3, 4)}");
  print("Multiply: ${multiply(3, 4)}");
}

int sum(int a, int b) {
  return a + b;
}

// arrow function
int multiply(int a, int b) => a * b;