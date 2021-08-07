import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/widgets/app_drawer.dart';
import 'package:myshop/widgets/badge.dart';
import 'package:myshop/widgets/products_grid.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';

enum FilterOptions {
  showFavorites,
  showAll,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  // @override
  // void initState() {
  // TODO: implement initState

  // Provider.of<Products>(context).fetchAndSetProducts();
  //   Future.delayed(Duration.zero).then((value) {
  //     Provider.of<Products>(context).fetchAndSetProducts();
  //   });

  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selected) {
              setState(() {
                if (selected == FilterOptions.showFavorites)
                  _showOnlyFavorites = true;
                if (selected == FilterOptions.showAll)
                  _showOnlyFavorites = false;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.showFavorites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterOptions.showAll,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (context, cart, child) => Badge(
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.routName);
                },
                icon: Icon(Icons.shopping_cart),
              ),
              value: cart.itemCount.toString(),
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : ProductsGrid(_showOnlyFavorites),
    );
  }
}
