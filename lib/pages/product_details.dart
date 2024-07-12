import 'package:flutter/material.dart';
import 'package:hizligida/models/product.dart';
import 'package:hizligida/pages/base_page.dart';
import 'package:hizligida/widgets/widget_product_details.dart';

class ProductDetails extends BasePage {
  final Product product;

  ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends BasePageState<ProductDetails> {
  @override
  Widget pageUI() {
    return ProductDetailsWidget(data: this.widget.product);
  }
}
