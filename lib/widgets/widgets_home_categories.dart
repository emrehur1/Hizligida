//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hizligida/models/category.dart' as categoryModel;
//import 'package:hizligida/pages/products_page.dart';
//import 'package:hizligida/pages/home_page.dart';
import 'package:hizligida/pages/product_page.dart';

import '../api_service.dart';
//import '../config.dart';

class WidgetCategories extends StatefulWidget {
  @override
  _WidgetCategoriesState createState() => _WidgetCategoriesState();
}

class _WidgetCategoriesState extends State<WidgetCategories> {
  late APIService apiService; // "late" keyword is used since it will be initialized in initState()

  @override
  void initState() {
    super.initState();
    apiService = APIService(); // Initialize the APIService instance
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, top: 10),
                child: Text(
                  'Tüm Kategoriler',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',

                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, top: 10, right: 10),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: TextStyle(color: Colors.redAccent,fontFamily: 'Poppins',),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: _categoriesList,
          ),
        ],
      ),
    );
  }

  Widget get _categoriesList {
    return FutureBuilder<List<categoryModel.Category>>(
      future: apiService.getCategories(),
      builder: (BuildContext context,
          AsyncSnapshot<List<categoryModel.Category>> model) {
        if (model.hasData) {
          return _buildCategoryList(model.data!);
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildCategoryList(List<categoryModel.Category> categories) {
    return Container(
      height: 120,  // Yüksekliği artırarak yeterli alan sağlanıyor
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          var data = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(
                    categoryId: data.categoryId,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 5),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        data.image?.url ?? '',
                        fit: BoxFit.cover,
                        height: 80,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Flexible(  // Flexible eklenerek metnin boyutunu mevcut alana göre ayarlaması sağlanıyor
                    child: Text(
                      data.categoryName ?? '',
                      style: TextStyle(fontFamily: 'Poppins',),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
