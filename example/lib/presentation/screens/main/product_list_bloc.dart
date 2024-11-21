import 'package:example/domain/entities/product.entity.dart';
import 'package:example/domain/use_cases/products_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class ProductListEvent {
  const ProductListEvent();
  const factory ProductListEvent.init() = _InitProductListEvent;
}

final class _InitProductListEvent extends ProductListEvent {
  const _InitProductListEvent();
}

sealed class ProductListState {
  const ProductListState();
  const factory ProductListState.loading() = LoadingProductListState;
  const factory ProductListState.success(List<ProductEntity> list) =
      SuccessProductListState;
  const factory ProductListState.error(String message) = ErrorProductListState;
}

final class LoadingProductListState extends ProductListState {
  const LoadingProductListState();
}

final class SuccessProductListState extends ProductListState {
  final List<ProductEntity> list;
  const SuccessProductListState(this.list);
}

final class ErrorProductListState extends ProductListState {
  final String message;
  const ErrorProductListState(this.message);
}

class ProductListBLoC extends Bloc<ProductListEvent, ProductListState> {
  final ProductsUseCases _productsUseCases;

  ProductListBLoC({required ProductsUseCases productsUseCases})
      : _productsUseCases = productsUseCases,
        super(const ProductListState.loading()) {
    on<ProductListEvent>(
      (event, emitter) => switch (event) {
        _InitProductListEvent() => _init(emitter),
      },
    );

    add(const ProductListEvent.init());
  }

  Future<void> _init(Emitter<ProductListState> emitter) async {
    emitter(const ProductListState.loading());
    try {
      final list = await _productsUseCases.getProducts();
      emitter(ProductListState.success(list));
    } catch (_) {
      emitter(ProductListState.error('Every third request causes an error!'));
    }
  }
}
