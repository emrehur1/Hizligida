class CartResponseModel {
  bool status;
  List<CartItem>? data;
  //String message;

  CartResponseModel({
    required this.status,
    this.data,
    //required this.message,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      status: json['status'],
      //message: json['message'],
      data: (json['data'] as List<dynamic>?)
          ?.map((v) => CartItem.fromJson(v))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      //'message': message,
      'data': data?.map((v) => v.toJson()).toList(),
    };
  }
}

class CartItem {
  int productId;
  String productName;
  String productRegularPrice;
  String productSalePrice;
  String thumbnail;
  int qty;
  double lineSubtotal;
  double lineTotal;
  int variationId;
  String attribute;
  String attributeValue;

  CartItem({
    required this.productId,
    required this.productName,
    required this.productRegularPrice,
    required this.productSalePrice,
    required this.thumbnail,
    required this.qty,
    required this.lineSubtotal,
    required this.lineTotal,
    required this.variationId,
    required this.attribute,
    required this.attributeValue,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['product_id'],
      productName: json['product_name'],
      productRegularPrice: json['product_regular_price'],
      productSalePrice: json['product_sale_price'] ?? json['product_regular_price'],
      thumbnail: json['thumbnail'].toString(),
      qty: json['qty'],
      lineSubtotal: double.parse(json['line_subtotal'].toString()),
      lineTotal: double.parse(json['line_total'].toString()),
      variationId: json['variation_id'],
      attribute: json['attribute'] != null && (json['attribute'] as Map<String, dynamic>).isNotEmpty
          ? (json['attribute'] as Map<String, dynamic>).keys.first.toString()
          : "",
      attributeValue: json['attribute'] != null && (json['attribute'] as Map<String, dynamic>).isNotEmpty
          ? (json['attribute'] as Map<String, dynamic>).values.first.toString()
          : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_regular_price': productRegularPrice,
      'product_sale_price': productSalePrice,
      'thumbnail': thumbnail,
      'qty': qty,
      'line_subtotal': lineSubtotal,
      'line_total': lineTotal,
      'variation_id': variationId,
      'attribute': attribute,
      'attribute_value': attributeValue,
    };
  }

  void increaseQty() {
    qty++;
  }

  void decreaseQty() {
    qty == 0 ? qty = 0 : qty--;
  }
}
