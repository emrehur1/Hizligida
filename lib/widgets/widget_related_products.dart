import 'package:flutter/material.dart';
import 'package:hizligida/api_service.dart';
import 'package:hizligida/models/product.dart';
import 'package:hizligida/pages/product_details.dart'; // ProductDetails import edildi

class WidgetRelatedProducts extends StatefulWidget {
  final String? labelName;
  final List<int>? products;
  final String? tagId; // tagId alanını ekliyoruz

  WidgetRelatedProducts({
    this.labelName,
    this.products,
    this.tagId,
  });

  @override
  _WidgetRelatedProductsState createState() => _WidgetRelatedProductsState();
}

class _WidgetRelatedProductsState extends State<WidgetRelatedProducts> {
  late APIService apiService;

  @override
  void initState() {
    super.initState();
    apiService = APIService();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF4F7FA),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16, top: 4),
                child: Text(
                  widget.labelName ?? "",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins"
                  ),
                ),
              ),
            ],
          ),
          _productsList(),
        ],
      ),
    );
  }

  Widget _productsList() {
    return FutureBuilder<List<Product>>(
      future: apiService.getProducts(productIds: this.widget.products),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No products available'),
          );
        } else {
          return _buildList(snapshot.data!);
        }
      },
    );
  }

  Widget _buildList(List<Product> items) {
    return Container(
      height: 200,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          var data = items[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetails(product: data),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  width: 130,
                  height: 120,
                  alignment: Alignment.center,
                  child: data.images != null && data.images!.isNotEmpty
                      ? Image.network(
                    data.images![0].src!,
                    height: 120,
                  )
                      : Container(), // Resim yoksa boş bir container göster
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(0, 5),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 130,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    data.name ?? '', // data.name null ise boş bir string göster
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: "Poppins"
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4, left: 4),
                  width: 130,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        '₺${data.regularPrice}',
                        style: TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '₺${data.salePrice}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
