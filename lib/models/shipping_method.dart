class ShippingMethod {
  int? id;
  String? title;
  String? cost;

  ShippingMethod({
    this.id,
    this.title,
    this.cost,
  });

  // JSON verisinden ShippingMethod nesnesi oluşturma
  ShippingMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    cost = json['settings']?['cost']?['value'];
  }
}
