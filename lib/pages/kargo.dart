import 'package:flutter/material.dart';
import 'package:hizligida/api_service.dart';

class ShippingCostPage extends StatefulWidget {
  @override
  _ShippingCostPageState createState() => _ShippingCostPageState();
}

class _ShippingCostPageState extends State<ShippingCostPage> {
  String? shippingCost;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchShippingCost();
  }

  Future<void> fetchShippingCost() async {
    // API Service'ı kullanarak kargo ücretini çekiyoruz
    APIService apiService = APIService();
    String? cost = await apiService.getShippingCost(2, 2); // Örnek olarak zoneId: 2, methodId: 2

    setState(() {
      shippingCost = cost;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Cost'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : shippingCost != null
            ? Text(
          'Kargo Ücreti: $shippingCost ₺',
          style: TextStyle(fontSize: 24),
        )
            : Text(
          'Kargo ücretini alırken bir hata oluştu.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
