import 'package:flutter/material.dart';
import 'package:hizligida/pages/base_page.dart';
import 'package:hizligida/widgets/widget_product_card.dart' as widget_product;
import 'package:hizligida/models/product.dart';
import 'package:hizligida/provider/products_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class ProductPage extends BasePage {
  final int? categoryId;

  ProductPage({Key? key, this.categoryId}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends BasePageState<ProductPage> {
  int _page = 1;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchQuery = TextEditingController();
  Timer? _debounce;

  final _sortByOptions = [
    SortBy("popularity", "Popularity", "asc"),
    SortBy("modified", "Latest", "asc"),
    SortBy("price", "Price High to Low", "desc"),
    SortBy("price", "Price: Low to High", "asc"),
  ];

  @override
  void initState() {
    super.initState();
    var productList = Provider.of<ProductsProvider>(context, listen: false);
    productList.resetStreams();
    productList.setLoadingState(LoadMoreStatus.INITIAL);
    productList.fetchProducts(_page);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchQuery.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      var productList = Provider.of<ProductsProvider>(context, listen: false);
      productList.setLoadingState(LoadMoreStatus.LOADING);
      productList.fetchProducts(++_page);
    }
  }

  void _onSearchTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      var productList = Provider.of<ProductsProvider>(context, listen: false);
      productList.resetStreams();
      productList.setLoadingState(LoadMoreStatus.INITIAL);
      productList.fetchProducts(1, strSearch: text);
    });
  }

  @override
  Widget pageUI() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Page"),
      ),
      body: Column(
        children: [
          _productFilters(),
          Expanded(
            child: Consumer<ProductsProvider>(
              builder: (context, productsModel, child) {
                if (productsModel.allProducts.isNotEmpty &&
                    productsModel.getLoadMoreStatus != LoadMoreStatus.INITIAL) {
                  return _buildList(
                    productsModel.allProducts,
                    productsModel.getLoadMoreStatus == LoadMoreStatus.LOADING,
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Product> items, bool isLoadMore) {
    return GridView.count(
      shrinkWrap: true,
      controller: _scrollController,
      crossAxisCount: 2,
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: items.map((Product item) {
        return widget_product.ProductCard(
          data: item,
        );
      }).toList(),
    );
  }

  Widget _productFilters() {
    return Container(
      height: 51,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: TextField(
              controller: _searchQuery,
              onChanged: _onSearchTextChanged,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Color(0xffe6e6ec),
                filled: true,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xffe6e6ec),
              borderRadius: BorderRadius.circular(9.0),
            ),
            child: PopupMenuButton<SortBy>(
              onSelected: (sortBy) {
                var productList = Provider.of<ProductsProvider>(context, listen: false);
                productList.setSortOrder(sortBy);
              },
              itemBuilder: (BuildContext context) {
                return _sortByOptions.map((item) {
                  return PopupMenuItem<SortBy>(
                    value: item,
                    child: Text(item.text),
                  );
                }).toList();
              },
              icon: Icon(Icons.tune),
            ),
          ),
        ],
      ),
    );
  }
}
