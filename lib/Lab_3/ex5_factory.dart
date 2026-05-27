class Settings {
  static final Settings _instance = Settings._internal();

  factory Settings() {
    return _instance;
  }

  Settings._internal();
}

void runExercise5() {
  var a = Settings();
  var b = Settings();

  print(identical(a, b)); // true
}