import 'package:example/domain/entities/product.entity.dart';
import 'package:example/domain/repositories/product.repository.dart';
import 'package:trackit/trackit.dart';

class ProductsUseCases {
  static final _log = Trackit.create('ProductsUseCases');
  final ProductRepository productRepository;

  const ProductsUseCases({required this.productRepository});

  Future<List<ProductEntity>> getProducts() async {
    _log.info('get products list...');
    final list = await productRepository.getProducts();
    _log.info('get products list receive ${list.length}');
    return list;
  }

  Future<ProductEntity> getProduct(int id) async {
    _log.info('get product $id...');
    final product = await productRepository.getProduct(id);
    _log.info('get product $id success');
    return product;
  }
}
