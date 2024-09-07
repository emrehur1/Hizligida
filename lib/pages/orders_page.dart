import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hizligida/models/order.dart';
import 'package:hizligida/widgets/widget_order_item.dart';

import '../provider/order_provider.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    var ordersList = Provider.of<OrderProvider>(context, listen: false);
    ordersList.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Siparişlerim",
          style: TextStyle(color: Colors.black, fontSize: 20,fontFamily:"Poppins"),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, ordersModel, child) {
          if (ordersModel.allOrders != null) {
            return ordersModel.allOrders!.length > 0
                ? _listView(context, ordersModel.allOrders!)
                : Center(child: Text("SİPARİŞ YOK"));
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _listView(BuildContext context, List<OrderModel> orders) {
    return ListView.builder(
      itemCount: orders.length,
      physics: ScrollPhysics(),
      padding: EdgeInsets.all(8.0),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: WidgetOrderItem(orderModel: orders[index]),
        );
      },
    );
  }
}
