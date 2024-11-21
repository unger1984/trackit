import 'package:example/domain/entities/product.entity.dart';
import 'package:example/presentation/app/app_router.dart';
import 'package:example/presentation/app/app_theme.dart';
import 'package:example/presentation/screens/product/product_screen.dart';
import 'package:flutter/material.dart';

@immutable
class ProductCard extends StatelessWidget {
  final ProductEntity product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.product,
          arguments: ProductScreenArgs(name: product.name, id: product.id),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppTheme.brdMain),
          borderRadius: BorderRadius.circular(10),
        ),
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(product.image, fit: BoxFit.scaleDown),
              )),
              Text(
                product.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                product.description,
                style: TextStyle(fontSize: 18, color: AppTheme.txtSecondary),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${product.price.toString()}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.zero,
                      minimumSize: Size(50, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        // side: BorderSide(width: 2, color: Colors.green),
                      ),
                    ),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
