import 'package:example/domain/entities/product.entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts();
  Future<ProductEntity> getProduct(int id);
}
