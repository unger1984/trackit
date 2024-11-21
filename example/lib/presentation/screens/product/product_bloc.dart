import 'package:example/domain/entities/product.entity.dart';
import 'package:example/domain/use_cases/products_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class ProductEvent {
  const ProductEvent();
  const factory ProductEvent.load(int id) = _LoadProductEvent;
}

final class _LoadProductEvent extends ProductEvent {
  final int id;
  const _LoadProductEvent(this.id);
}

sealed class ProductState {
  const ProductState();
  const factory ProductState.loading() = LoadingProductState;
  const factory ProductState.success(ProductEntity product) =
      SuccessProductState;
  const factory ProductState.error(String message) = ErrorProductState;
}

final class LoadingProductState extends ProductState {
  const LoadingProductState();
}

final class SuccessProductState extends ProductState {
  final ProductEntity product;
  const SuccessProductState(this.product);
}

final class ErrorProductState extends ProductState {
  final String message;
  const ErrorProductState(this.message);
}

class ProductBLoC extends Bloc<ProductEvent, ProductState> {
  final ProductsUseCases _productsUseCases;

  ProductBLoC(
      {required int productId, required ProductsUseCases productsUseCases})
      : _productsUseCases = productsUseCases,
        super(const ProductState.loading()) {
    on<ProductEvent>(
      (event, emitter) => switch (event) {
        _LoadProductEvent(:int id) => _load(id, emitter),
      },
    );
    add(ProductEvent.load(productId));
  }

  Future<void> _load(int id, Emitter<ProductState> emitter) async {
    emitter(const ProductState.loading());
    try {
      final product = await _productsUseCases.getProduct(id);
      emitter(ProductState.success(product));
    } catch (e) {
      emitter(ProductState.error('Every third request causes an error!'));
    }
  }
}
