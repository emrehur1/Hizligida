import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hizligida/provider/products_provider.dart';
import 'package:hizligida/widgets/widget_product_card.dart' as widget_product;

import '../models/product.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchQueryController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchQueryController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      var productList = Provider.of<ProductsProvider>(context, listen: false);
      productList.resetStreams();
      productList.setLoadingState(LoadMoreStatus.INITIAL);
      productList.fetchProducts(1, strSearch: text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: TextField(
          controller: _searchQueryController,
          onChanged: _onSearchTextChanged,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear, color: Colors.black),
            onPressed: () {
              _searchQueryController.clear();
              _onSearchTextChanged('');
            },
          ),
        ],
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, productsModel, child) {
          if (productsModel.getLoadMoreStatus == LoadMoreStatus.LOADING &&
              productsModel.allProducts.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (productsModel.allProducts.isNotEmpty) {
            return _buildSearchResults(productsModel.allProducts);
          } else if (productsModel.allProducts.isEmpty &&
              productsModel.getLoadMoreStatus == LoadMoreStatus.STABLE) {
            return Center(
              child: Text("No products found."),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildSearchResults(List<Product> items) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.7,
      children: items.map((Product item) {
        return widget_product.ProductCard(data: item);
      }).toList(),
    );
  }
}
