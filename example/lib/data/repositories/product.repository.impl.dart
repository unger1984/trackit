import 'dart:convert';

import 'package:example/data/fake/products_fake.dart';
import 'package:example/data/models/product.model.dart';
import 'package:example/domain/datasources/api_source.dart';
import 'package:example/domain/entities/product.entity.dart';
import 'package:example/domain/repositories/product.repository.dart';
import 'package:trackit/trackit.dart';

final class ProductRepositoryImpl extends ProductRepository {
  static final _log = Trackit.create('ProductRepositoryImpl');
  final fakeProducts = ProductsFake.getProducts();
  final ApiSource _api;
  var _requestsCount = 0;

  ProductRepositoryImpl({required ApiSource api}) : _api = api;

  Future<void> _try() async {
    _requestsCount += 1;
    if (_requestsCount % 3 == 0) {
      await _api.get('/notfound');
    } else {
      await _api.get<dynamic>('/products');
    }
  }

  @override
  Future<List<ProductEntity>> getProducts() async {
    try {
      await _try();
      // Fake data
      final result = jsonDecode(fakeProducts) as List<dynamic>;
      _log.debug(result);
      return result
          .cast<Map<String, dynamic>>()
          .map((item) => ProductModel.fromJson(item).toEntity())
          .toList();
    } catch (exception, stackTrace) {
      _log.error('getProducts error', exception, stackTrace);
      Error.throwWithStackTrace(exception, stackTrace);
    }
  }

  @override
  Future<ProductEntity> getProduct(int id) async {
    try {
      await _try();
      final result = jsonDecode(fakeProducts) as List<dynamic>;
      final product = result
          .cast<Map<String, dynamic>>()
          .map((item) => ProductModel.fromJson(item).toEntity())
          .firstWhere((item) => item.id == id);
      _log.debug(ProductModel.fromEntity(product).toJson());
      return product;
    } catch (exception, stackTrace) {
      _log.error('getProduct $id error', exception, stackTrace);
      Error.throwWithStackTrace(exception, stackTrace);
    }
  }
}
