import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import '../provider/product.dart';
import '../provider/products.dart';
import '../provider/auth.dart';
import '../provider/cart.dart';

class ProductItem extends StatelessWidget {
  //final String id;
  //final String title;
  //final String imageUrl;

  //ProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final selectProduct = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: selectProduct.id,
            );
          },
          child: Hero(
            tag: selectProduct.id,
            child: FadeInImage(
              placeholder: AssetImage('assest/images/product-placeholder.png'),
              image: NetworkImage(selectProduct.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, selectProduct, _) => IconButton(
              icon: Icon(
                selectProduct.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              onPressed: () {
                /*Provider.of<Products>(context, listen: false).updateProduct(
                  selectProduct.id,
                  Product(
                    id: selectProduct.id,
                    title: selectProduct.title,
                    description: selectProduct.description,
                    imageUrl: selectProduct.imageUrl,
                    price: selectProduct.price,
                    isFavorite: !selectProduct.isFavorite,
                  ),
                );*/
                selectProduct.toggleFavoriteState(auth.token, auth.userId);
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            selectProduct.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addCart(
                selectProduct.id,
                selectProduct.price,
                selectProduct.title,
              );
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added it to Cart !!'),
                  duration: Duration(seconds: 4),
                  action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removoneitem(selectProduct.id);
                      }),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
