import 'package:example/di.dart';
import 'package:example/domain/use_cases/products_use_cases.dart';
import 'package:example/presentation/app/app_router.dart';
import 'package:example/presentation/screens/main/product_list.dart';
import 'package:example/presentation/screens/main/product_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        // surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.of(context).pushNamed(Routes.trackit),
          )
        ],
      ),
      body: BlocProvider<ProductListBLoC>(
        create: (context) => ProductListBLoC(
          productsUseCases: ProductsUseCases(
            productRepository: DI.of(context).productRepository,
          ),
        ),
        child: ProductList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Catalog'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Profile'),
        ],
      ),
    );
  }
}
