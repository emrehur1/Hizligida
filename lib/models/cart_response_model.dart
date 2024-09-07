class CartResponseModel {
  bool? status;
  List<CartItem>? data;

  CartResponseModel({this.status, this.data});

  CartResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null && json['data'] is List) {
      data = <CartItem>[];
      json['data'].forEach((v) {
        data!.add(CartItem.fromJson(v));
      });
    } else {
      print("Invalid data type: ${json['data']?.runtimeType}");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItem {
  int? productId;
  String? productName;
  double? productRegularPrice;
  double? productSalePrice;
  String? thumbnail;
  int? qty;
  double? lineSubtotal;
  double? lineTotal;
  int? variationId;
  String? attribute;
  String? attributeValue;

  CartItem({
    this.productId,
    this.productName,
    this.productRegularPrice,
    this.productSalePrice,
    this.thumbnail,
    this.qty,
    this.lineSubtotal,
    this.lineTotal,
    this.variationId,
    this.attribute,
    this.attributeValue,
  });

  CartItem.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productRegularPrice = _toDouble(json['product_regular_price']);
    productSalePrice = _toDouble(json['product_sale_price']);
    thumbnail = json['thumbnail'];
    qty = json['qty'];
    lineSubtotal = _toDouble(json['line_subtotal']);
    lineTotal = _toDouble(json['line_total']);
    variationId = json['variation_id'];

    // attribute alanını ayrıştırma
    if (json["attribute"] is Map<String, dynamic>) {
      attribute = json["attribute"].keys.isNotEmpty
          ? json["attribute"].keys.first.toString()
          : "";
      attributeValue = json["attribute"].values.isNotEmpty
          ? json["attribute"].values.first.toString()
          : "";
    } else if (json["attribute"] is List<dynamic> && json["attribute"].isNotEmpty) {
      var firstAttribute = json["attribute"].first;
      if (firstAttribute is Map<String, dynamic>) {
        attribute = firstAttribute.keys.isNotEmpty
            ? firstAttribute.keys.first.toString()
            : "";
        attributeValue = firstAttribute.values.isNotEmpty
            ? firstAttribute.values.first.toString()
            : "";
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_regular_price'] = productRegularPrice;
    data['product_sale_price'] = productSalePrice;
    data['thumbnail'] = thumbnail;
    data['qty'] = qty;
    data['line_subtotal'] = lineSubtotal;
    data['line_total'] = lineTotal;
    data['variation_id'] = variationId;
    data['attribute'] = {attribute ?? "": attributeValue ?? ""};

    return data;
  }

  double? _toDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value);
    } else {
      return value;
    }
  }
}


