import 'dart:convert';

final class ProductsFake {
  static final List<Map<String, dynamic>> _products = [
    {
      'id': 1,
      'name': 'Product 1',
      'description': 'Description 1',
      'price': 10.0,
      'image': 'assets/p1.png',
    },
    {
      'id': 2,
      'name': 'Product 2',
      'description': 'Description 2',
      'price': 0.99,
      'image': 'assets/p2.png',
    },
    {
      'id': 3,
      'name': 'Product 3',
      'description': 'Description 3',
      'price': 1.99,
      'image': 'assets/p3.png',
    },
    {
      'id': 4,
      'name': 'Product 4',
      'description': 'Description 4',
      'price': 2.99,
      'image': 'assets/p4.png',
    },
    {
      'id': 5,
      'name': 'Product 5',
      'description': 'Description 5',
      'price': 1.09,
      'image': 'assets/p5.png',
    },
    {
      'id': 6,
      'name': 'Product 6',
      'description': 'Description 6',
      'price': 5.69,
      'image': 'assets/p6.png',
    },
    {
      'id': 7,
      'name': 'Product 7',
      'description': 'Description 7',
      'price': 2.49,
      'image': 'assets/p2.png',
    },
    {
      'id': 8,
      'name': 'Product 8',
      'description': 'Description 8',
      'price': 5.39,
      'image': 'assets/p3.png',
    },
    {
      'id': 9,
      'name': 'Product 9',
      'description': 'Description 9',
      'price': 4.49,
      'image': 'assets/p4.png',
    },
  ];

  static String getProducts() => jsonEncode(_products);
}
