import 'package:example/domain/entities/product.entity.dart';
import 'package:example/presentation/common/error_view.dart';
import 'package:example/presentation/screens/main/product_card.dart';
import 'package:example/presentation/screens/main/product_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductListBLoC>().add(const ProductListEvent.init());
      },
      child: BlocBuilder<ProductListBLoC, ProductListState>(
        builder: (context, state) => switch (state) {
          SuccessProductListState(:List<ProductEntity> list) =>
            GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) => ProductCard(
                product: list.elementAt(index),
              ),
              itemCount: list.length,
            ),
          ErrorProductListState(:String message) => ErrorView(
              message: message,
              onTry: () => context
                  .read<ProductListBLoC>()
                  .add(const ProductListEvent.init()),
            ),
          _ => Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}
