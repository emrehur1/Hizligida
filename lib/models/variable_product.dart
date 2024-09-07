class VariableProduct {
  int id;
  String price;
  String regularPrice;
  String salePrice;
  List<Attributes>? attributes;

  VariableProduct({
    required this.id,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    this.attributes,
  });

  VariableProduct.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        price = json['price'],
        regularPrice = json['regular_price'],
        salePrice = json['sale_price'],
        attributes = (json['attributes'] as List?)
            ?.map((v) => Attributes.fromJson(v))
            .toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'price': price,
      'regular_price': regularPrice,
      'sale_price': salePrice,
    };
    if (attributes != null) {
      data['attributes'] = attributes!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VariableProduct &&
        other.id == id &&
        other.price == price &&
        other.regularPrice == regularPrice &&
        other.salePrice == salePrice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    price.hashCode ^
    regularPrice.hashCode ^
    salePrice.hashCode;
  }
}


class Attributes {
   late int id;
   late String name;
   late String option;

   Attributes({
     required this.id,
     required this.name,
     required this.option,
   });

   Attributes.fromJson(Map<String, dynamic> json) {
     id = json['id'];
     name = json['name'];
     option = json['option'];
   }

   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = {
       'id': id,
       'name': name,
       'option': option,
     };
     return data;
   }
 }
