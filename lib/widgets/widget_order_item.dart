import 'package:flutter/material.dart';
import 'package:hizligida/models/order.dart';
import 'package:hizligida/pages/home_page.dart';
import 'package:hizligida/pages/order_detail.dart';
import 'package:hizligida/utils/cart_icons.dart';

class WidgetOrderItem extends StatelessWidget {
  final OrderModel? orderModel;
  WidgetOrderItem({this.orderModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          _orderStatus(this.orderModel?.status ?? "processing"),
          Divider(
            color: Colors.grey,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              iconText(
                Icon(CartIcons.edit, color: Color(0xFF4A4A4A),),
                Text(
                  "Sipariş Numarası",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                this.orderModel?.orderId?.toString() ?? "N/A",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              iconText(
                Icon(
                  Icons.today,
                  color: Color(0xFF4A4A4A),
                ),
                Text(
                  "Sipariş Tarihi",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                this.orderModel?.orderDate?.toString() ?? "N/A",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _orderDetailsButton(context),
              SizedBox(width: 5),
            ],
          )
        ],
      ),
    );
  }

  Widget iconText(Icon iconWidget, Text textWidget) {
    return Row(
      children: <Widget>[iconWidget, SizedBox(width: 5), textWidget],
    );
  }

  Widget _orderDetailsButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (this.orderModel != null && this.orderModel!.orderId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsPage(
                orderId: this.orderModel!.orderId!,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sipariş detayları mevcut değil')),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              "Sipariş Detayları",
              style: TextStyle(color: Colors.white),
            ),
            Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _orderStatus(String status) {
    Icon icon;
    Color color;

    if (status == "pending" || status == "processing" || status == "on-hold") {
      icon = Icon(Icons.timer, color: Colors.orange);
      color = Colors.orange;
    } else if (status == "completed") {
      icon = Icon(Icons.check, color: Colors.green);
      color = Colors.green;
    } else if (status == "cancelled" ||
        status == "refunded" ||
        status == "failed") {
      icon = Icon(Icons.clear, color: Colors.redAccent);
      color = Colors.redAccent;
    } else {
      icon = Icon(Icons.clear, color: Colors.redAccent);
      color = Colors.redAccent;
    }

    return iconText(
      icon,
      Text(
        "Order $status",
        style: TextStyle(
          fontSize: 15,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
