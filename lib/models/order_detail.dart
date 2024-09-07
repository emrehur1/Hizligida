import 'customer_detail_model.dart';

class OrderDetailModel {
  int? orderId;
  String? orderNumber;
  String? paymentMethod;
  String? orderStatus;
  DateTime? orderDate;
  Shipping? shipping;
  List<LineItems>? lineItems;
  double? totalAmount;
  double? shippingTotal;
  double? itemTotalAmount;

  OrderDetailModel({
    this.orderId,
    this.orderNumber,
    this.paymentMethod,
    this.orderStatus,
    this.orderDate,
    this.shipping,
    this.lineItems,
    this.totalAmount,
    this.shippingTotal,
  });

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    orderId = json['id'];
    orderNumber = json['order_key'];
    paymentMethod = json['payment_method_title'];
    orderStatus = json['status'];
    orderDate = DateTime.tryParse(json['date_created']);
    shipping = json['shipping'] != null ? Shipping.fromJson(json['shipping']) : null;

    if (json['line_items'] != null) {
      lineItems = <LineItems>[];
      json['line_items'].forEach((v) {
        lineItems!.add(LineItems.fromJson(v));
      });

      itemTotalAmount = lineItems != null
          ? lineItems!
          .map<double>((m) => m.totalAmount ?? 0)
          .reduce((a, b) => a + b)
          : 0;
    }

    totalAmount = double.tryParse(json['total'] ?? '0');
    shippingTotal = double.tryParse(json['shipping_total'] ?? '0');
  }
}

class LineItems {
  int? productId;
  String? productName;
  int? quantity;
  int? variationId;
  double? totalAmount;
  Map<String, dynamic>? image; // Resim URL'ini içeren map

  LineItems({
    this.productId,
    this.productName,
    this.quantity,
    this.variationId,
    this.totalAmount,
    this.image,
  });

  LineItems.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['name'];
    variationId = json['variation_id'];
    quantity = json['quantity'];
    totalAmount = double.tryParse(json['total'] ?? '0');
    image = json['image'] != null ? Map<String, dynamic>.from(json['image']) : null;
  }
}
