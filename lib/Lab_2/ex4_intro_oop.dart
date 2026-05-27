void main() {
  Car car1 = Car("Toyota");
  car1.run();

  Car car2 = Car.named();
  car2.run();

  ElectricCar eCar = ElectricCar("Tesla");
  eCar.run();
}

// Class
class Car {
  String brand;

  // Constructor
  Car(this.brand);

  // Named constructor
  Car.named() : brand = "Unknown";

  void run() {
    print("$brand is running");
  }
}

// Subclass
class ElectricCar extends Car {
  ElectricCar(String brand) : super(brand);

  @override
  void run() {
    print("$brand is running silently (electric)");
  }
}