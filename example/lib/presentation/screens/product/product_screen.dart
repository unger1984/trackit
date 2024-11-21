import 'package:example/di.dart';
import 'package:example/domain/entities/product.entity.dart';
import 'package:example/domain/use_cases/products_use_cases.dart';
import 'package:example/presentation/app/app_theme.dart';
import 'package:example/presentation/common/error_view.dart';
import 'package:example/presentation/screens/product/product_bloc.dart';
import 'package:example/presentation/screens/product/product_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreenArgs {
  final int id;
  final String name;

  ProductScreenArgs({required this.id, required this.name});

  @override
  String toString() => 'ProductScreenArgs(id=$id, name=$name)';
}

@immutable
class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ProductScreenArgs;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.name,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.txtMain),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocProvider<ProductBLoC>(
        create: (context) => ProductBLoC(
          productId: args.id,
          productsUseCases: ProductsUseCases(
            productRepository: DI.of(context).productRepository,
          ),
        ),
        child: BlocBuilder<ProductBLoC, ProductState>(
          builder: (context, state) => switch (state) {
            SuccessProductState(:ProductEntity product) =>
              ProductView(product: product),
            ErrorProductState(:String message) => ErrorView(
                message: message,
                onTry: () => context.read<ProductBLoC>().add(
                      ProductEvent.load(args.id),
                    ),
              ),
            _ => Center(child: CircularProgressIndicator()),
          },
        ),
      ),
    );
  }
}
