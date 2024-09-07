import 'package:hizligida/models/customer_detail_model.dart';

class OrderModel {
  int? customerId;
  String? paymentMethod;
  String? paymentMethodTitle;
  bool? setPaid;
  String? transactionId;
  List<LineItems>? lineItems;
  int? orderId;
  String? orderNumber;
  String? status;
  DateTime? orderDate;
  Shipping? shipping;
  Billing? billing;
  List<ShippingLines>? shippingLines;

  OrderModel({
    this.customerId,
    this.paymentMethod,
    this.paymentMethodTitle,
    this.setPaid,
    this.transactionId,
    this.lineItems,
    this.orderId,
    this.orderNumber,
    this.status,
    this.orderDate,
    this.shipping,
    this.billing,
    this.shippingLines,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    orderId = json['id'];
    status = json['status'];
    orderNumber = json['order_key'];
    orderDate = DateTime.tryParse(json['date_created']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['customer_id'] = customerId;
    data['payment_method'] = paymentMethod;
    data['payment_method_title'] = paymentMethodTitle;
    data['set_paid'] = setPaid;
    data['transaction_id'] = transactionId;
    data['shipping'] = shipping?.toJson();
    data['billing'] = billing?.toJson();

    if (lineItems != null) {
      data['line_items'] = lineItems!.map((v) => v.toJson()).toList();
    }
    if (shippingLines != null) {
      data['shipping_lines'] = shippingLines!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LineItems {
  int? productId;
  int? quantity;
  int? variationId;

  LineItems({this.productId, this.quantity, this.variationId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['quantity'] = quantity;
    if (variationId != null) {
      data['variation_id'] = variationId;
    }
    return data;
  }
}
class ShippingLines {
  String? methodId;
  String? methodTitle;
  String? total;

  ShippingLines({this.methodId, this.methodTitle, this.total});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['method_id'] = methodId;
    data['method_title'] = methodTitle;
    data['total'] = total;
    return data;
  }
}