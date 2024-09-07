import 'package:flutter/material.dart';
import 'package:hizligida/models/product.dart';
import '../api_service.dart';
import '../config.dart';
import 'package:hizligida/pages/product_details.dart';// Ürün detay sayfasını import edin

class WidgetHomeProducts extends StatefulWidget {
  final String? labelName;
  final String? tagId;

  WidgetHomeProducts({Key? key, this.labelName, this.tagId}) : super(key: key);

  @override
  _WidgetHomeProductsState createState() => _WidgetHomeProductsState();
}

class _WidgetHomeProductsState extends State<WidgetHomeProducts> {
  late APIService apiService;

  @override
  void initState() {
    apiService = APIService();
    super.initState();
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
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, top: 4),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: TextStyle(color: Colors.redAccent, fontFamily: 'Poppins',),
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
      future: apiService.getProducts(tagName: this.widget.tagId),
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
      height: 250, // Bu değeri 200'den 250'ye çıkardım.
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
                  builder: (context) => ProductDetails(
                    product: data,
                  ),
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
                  height: 150, // Bu değeri de 120'den 150'ye çıkardım.
                  alignment: Alignment.center,
                  child: data.images != null && data.images!.isNotEmpty
                      ? Image.network(
                    data.images![0].src!,
                    height: 150, // Bu değeri de 120'den 150'ye çıkardım.
                  )
                      : Container(),
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
                    data.name ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
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
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '₺${data.salePrice}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
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
