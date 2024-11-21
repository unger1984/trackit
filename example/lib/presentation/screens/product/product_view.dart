import 'package:example/domain/entities/product.entity.dart';
import 'package:flutter/material.dart';

@immutable
class ProductView extends StatelessWidget {
  final ProductEntity product;
  const ProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        SizedBox(
          height: 200,
          child: Image.asset(product.image, fit: BoxFit.contain),
        ),
        SizedBox(height: 10),
        Text(
          'It is a long established fact that a reader will be distracted\n'
          'by the readable content of a page when looking at its layout.\n'
          'The point of using Lorem Ipsum is that it has a more-or-less normal\n'
          'distribution of letters, as opposed to using \'Content here, content here\',\n'
          'making it look like readable English. Many desktop publishing packages\n'
          'and web page editors now use Lorem Ipsum as their default model text,\n'
          'and a search for \'lorem ipsum\' will uncover many web sites still\n'
          'in their infancy. Various versions have evolved over the years,\n'
          'sometimes by accident, sometimes on purpose (injected humour and the like).',
        ),
        SizedBox(height: 10),
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
        )
      ],
    );
  }
}
