import 'package:flutter/material.dart';
import 'package:hizligida/api_service.dart';
import 'package:hizligida/models/product.dart';
import 'package:hizligida/pages/base_page.dart';
import 'package:hizligida/widgets/widget_product_details.dart';
import 'package:hizligida/models/variable_product.dart';

class ProductDetails extends BasePage {
  ProductDetails({Key? key, this.product}) : super(key: key);

  Product? product;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends BasePageState<ProductDetails> {
  APIService? apiService;

  @override
  void initState() {
    super.initState();
    apiService = APIService();
  }

  @override
  Widget pageUI() {
    if (this.widget.product == null) {
      return Center(
        child: Text("Product not found."),
      );
    }
    return this.widget.product?.type== "variable" ? _variableProductsList() :
    ProductDetailsWidget(data: this.widget.product!);
  }

  Widget _variableProductsList() {
    if (this.widget.product == null || this.widget.product!.id == null) {
      return Center(
        child: Text("Product ID not found."),
      );
    }
    return FutureBuilder(
      future: apiService!.getVariableProducts(this.widget.product!.id!),
      builder: (BuildContext context, AsyncSnapshot<List<VariableProduct>> model) {
        if (model.hasData) {
          return ProductDetailsWidget(
            data: this.widget.product!,
            variableProducts: model.data?.toList() ?? [],
            //Here we will pass 1 more variable of SelectedVariableProduct
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
