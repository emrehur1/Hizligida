import 'package:flutter/material.dart';
import 'package:hizligida/models/order.dart';

import '../api_service.dart';

class OrderProvider with ChangeNotifier {
  APIService? _apiService;

  List<OrderModel>? _orderList;
  List<OrderModel>? get allOrders => _orderList;
  double get totalRecords => _orderList?.length.toDouble() ?? 0.0;

  OrderProvider() {
    resetStreams();
  }

  void resetStreams() {
    _apiService = APIService();
  }

  fetchOrders() async {
    List<OrderModel> orderList = await _apiService!.getOrders();

    if (_orderList == null) {
      _orderList = [];
    }

    if (orderList.isNotEmpty) {
      _orderList = [];
      _orderList!.addAll(orderList);
    }

    notifyListeners();
  }
}
