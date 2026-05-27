import 'dart:async';

class Product {
  final int id;
  final String name;
  final double price;

  Product(this.id, this.name, this.price);

  @override
  String toString() => '$id - $name - $price';
}

class ProductRepository {
  final List<Product> _data = [
    Product(1, 'Coffee', 2.5),
    Product(2, 'Milk Tea', 3.0),
  ];

  final StreamController<Product> _controller =
  StreamController<Product>.broadcast();

  Future<List<Product>> getAll() async {
    await Future.delayed(Duration(seconds: 1));
    return _data;
  }

  Stream<Product> liveAdded() => _controller.stream;

  void add(Product p) {
    _data.add(p);
    _controller.add(p);
  }
}

Future<void> runExercise1() async {
  final repo = ProductRepository();

  var list = await repo.getAll();
  print('Initial:');
  list.forEach(print);

  repo.liveAdded().listen((p) {
    print('New: $p');
  });

  repo.add(Product(3, 'Latte', 3.5));
  await Future.delayed(Duration(milliseconds: 500));
}