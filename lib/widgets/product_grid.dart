import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/product.dart';
import '../provider/products.dart';
import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;
  ProductGrid(this.showFavoriteOnly);
  @override
  Widget build(BuildContext context) {
    final Products productsData = Provider.of<Products>(context);
    final List<Product> products =
        showFavoriteOnly ? productsData.favoriteOnly : productsData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      padding: EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
            //products[i].id,
            //products[i].title,
            //products[i].imageUrl,
            ),
      ),
    );
  }
}
