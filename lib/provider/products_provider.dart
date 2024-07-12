import 'package:flutter/material.dart';
import 'package:hizligida/models/product.dart';
import 'package:hizligida/api_service.dart';


class SortBy {
  String value;
  String text;
  String sortOrder;

  SortBy(this.value, this.text, this.sortOrder);
}

enum LoadMoreStatus { INITIAL, LOADING, STABLE }

class ProductsProvider with ChangeNotifier {
  APIService? _apiService;
  List<Product> _productsList = [];
  SortBy? _sortBy;

  int totalPages = 0;
  int pageSize = 20;

  List<Product> get allProducts => _productsList;
  double get totalRecords => _productsList.length.toDouble();

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;
  LoadMoreStatus get getLoadMoreStatus => _loadMoreStatus;

  ProductsProvider() {
    resetStreams();
    _sortBy = SortBy("modified", "Latest", "asc");
  }

  void resetStreams() {
    _apiService = APIService();
    _productsList = [];
  }

  Future<void> fetchProducts(
      int pageNumber, {
        String? strSearch,
        String? tagName,
        String? categoryId,
        String? sortBy,
        String sortOrder = "asc",
      }) async {
    List<Product> itemModel = await _apiService!.getProducts(
      strSearch: strSearch,
      pageNumber: pageNumber,
      pageSize: this.pageSize,
      tagName: tagName,
      categoryId: categoryId,
      sortBy: this._sortBy!.value,
      sortOrder: this._sortBy!.sortOrder,
    );

    if (itemModel.isNotEmpty) {
      _productsList.addAll(itemModel);
    }

    setLoadingState(LoadMoreStatus.STABLE);
    notifyListeners();
  }

  void setLoadingState(LoadMoreStatus loadMoreStatus) {
    _loadMoreStatus = loadMoreStatus;
    notifyListeners();
  }

  void setSortOrder(SortBy sortBy) {
    _sortBy = sortBy;
    resetStreams();
    fetchProducts(1);
  }
}

class ProductCard extends StatelessWidget {
  final Product data;

  ProductCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0XFFFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color(0xfff8f8f8),
            blurRadius: 15,
            spreadRadius: 10,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Visibility(
              visible: data.calculateDiscount() > 0,
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    '${data.calculateDiscount()}% OFF',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xffE65829).withAlpha(40),
                  ),
                  Image.network(
                    data.images != null &&
                        data.images!.isNotEmpty &&
                        data.images![0].src != null
                        ? data.images![0].src!
                        : "https://t4.ftcdn.net/jpg/04/70/29/97/360_F_470299797_UD0eoVMMSUbHCcNJCdv2t8B2g1GVqYgs.jpg",
                    height: 160,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        "https://t4.ftcdn.net/jpg/04/70/29/97/360_F_470299797_UD0eoVMMSUbHCcNJCdv2t8B2g1GVqYgs.jpg",
                        height: 160,
                        fit: BoxFit.cover,
                      );
                    },
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Text(
              data.name ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (data.salePrice != data.regularPrice)
                  Text(
                    "\$${data.regularPrice}",
                    style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                SizedBox(width: 5),
                Text(
                  "\$${data.salePrice}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
