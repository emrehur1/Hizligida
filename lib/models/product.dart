import 'variable_product.dart';

class Product {
  int? id;
  String? name;
  String? description;
  String? shortDescription;
  String? sku;
  String? price;
  String? regularPrice;
  String? salePrice;
  String? stockStatus;
  List<Images>? images;
  List<Categories>? categories;
  List<ProductAttributes>? attributes; // Güncellenmiş sınıf adı
  List<int>? relatedIds;
  String? type;
  VariableProduct? variableProduct;

  Product({
    this.id,
    this.name,
    this.description,
    this.shortDescription,
    this.sku,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.stockStatus,
    this.images,
    this.categories,
    this.attributes,
    this.relatedIds,
    this.type,
    this.variableProduct,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    shortDescription = json['short_description'];
    sku = json['sku'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'] != "" ? json['sale_price'] : json['regular_price'];
    stockStatus = json['stock_status'];
    relatedIds = json['cross_sell_ids']?.cast<int>() ?? [];
    type = json["type"];

    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories?.add(Categories.fromJson(v));
      });
    }

    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images?.add(Images.fromJson(v));
      });
    }

    if (json['attributes'] != null) {
      attributes = [];
      json['attributes'].forEach((v) {
        attributes?.add(ProductAttributes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'description': description,
      'short_description': shortDescription,
      'sku': sku,
      'price': price,
      'regular_price': regularPrice,
      'sale_price': salePrice,
      'stock_status': stockStatus,
      'categories': categories?.map((e) => e.toJson()).toList(),
      'images': images?.map((e) => e.toJson()).toList(),
      'attributes': attributes?.map((e) => e.toJson()).toList(),
      'cross_sell_ids': relatedIds,
    };

    return data;
  }

  int calculateDiscount() {
    double disPercent = 0;

    if (this.regularPrice != "") {
      double regularPrice = double.parse(this.regularPrice ?? '0');
      double salePrice = this.salePrice != "" ? double.parse(this.salePrice ?? '0') : regularPrice;
      double discount = regularPrice - salePrice;
      disPercent = (discount / regularPrice) * 100;
    }

    return disPercent.round();
  }
}

class Categories {
  int? id;
  String? name;

  Categories({this.id, this.name});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
    };
    return data;
  }
}

class Images {
  String? src;

  Images({this.src});

  Images.fromJson(Map<String, dynamic> json) {
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'src': src};
    return data;
  }
}

class ProductAttributes {
  int? id;
  String? name;
  List<String>? options;

  ProductAttributes({this.id, this.name, this.options});

  ProductAttributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    options = json['options']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'options': options,
    };
    return data;
  }
}
