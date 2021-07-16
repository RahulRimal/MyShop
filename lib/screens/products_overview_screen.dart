import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/widgets/products_grid.dart';
import 'package:provider/provider.dart';

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
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
