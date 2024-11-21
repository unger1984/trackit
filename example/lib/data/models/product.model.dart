import 'package:example/domain/entities/product.entity.dart';

class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        price: json['price'],
        image: json['image'],
      );

  factory ProductModel.fromEntity(ProductEntity entity) => ProductModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        price: entity.price,
        image: entity.image,
      );

  ProductEntity toEntity() => ProductEntity(
        id: id,
        name: name,
        description: description,
        price: price,
        image: image,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'image': image,
      };
}
