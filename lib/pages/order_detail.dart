import 'package:flutter/material.dart';
import 'package:hizligida/api_service.dart';
import 'package:hizligida/utils/widget_checkpoints.dart';
import '../config.dart';
import '../models/order_detail.dart';
import '../utils/city.dart'; // CityStateMapping sınıfını içe aktar

class OrderDetailsPage extends StatelessWidget {
  final int? orderId;
  OrderDetailsPage({Key? key, this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sipariş Detayı', style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Poppins",),),
      ),
      body: pageUI(context),
    );
  }

  Widget pageUI(BuildContext context) {
    if (orderId == null) {
      return Center(
        child: Text('Order ID is null'),
      );
    }

    APIService apiService = APIService();

    return FutureBuilder<OrderDetailModel?>(
      future: apiService.getOrderDetails(orderId!),
      builder: (
          BuildContext context,
          AsyncSnapshot<OrderDetailModel?> orderDetailModel,
          ) {
        if (orderDetailModel.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (orderDetailModel.hasError) {
          return Center(
            child: Text('Error: ${orderDetailModel.error}'),
          );
        } else if (orderDetailModel.hasData) {
          return orderDetailsUI(context, orderDetailModel.data!);
        } else {
          return Center(
            child: Text('No data found'),
          );
        }
      },
    );
  }

  Widget orderDetailsUI(BuildContext context, OrderDetailModel orderDetailModel) {
    // state kodunu isimle değiştirmek için gerekli kod
    String? stateCode = orderDetailModel.shipping?.state;
    String? stateName = CityStateMapping.cityToStateCode.entries
        .firstWhere((entry) => entry.value == stateCode, orElse: () => MapEntry('', ''))
        .key;

    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "#${orderDetailModel.orderId}",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              fontFamily: "Poppins",
              color: Colors.black,
              height: 1.3,
            ),
          ),
          Text(
            "${orderDetailModel.orderDate}",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w300,
              fontFamily: "Poppins",
              color: Colors.grey,
              height: 1.2,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Teslimat adresi:",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              fontFamily: "Poppins",
              color: Colors.black,
              height: 1.4,
            ),
          ),
          Text(
            "${orderDetailModel.shipping?.address1 ?? ''}",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
              color: Colors.black,
              height: 1.3,
            ),
          ),
          Text(
            "${orderDetailModel.shipping?.address2 ?? ''}",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
              color: Colors.black,
              height: 1.3,
            ),
          ),
          Text(
            "${orderDetailModel.shipping?.city ?? ''}, $stateName",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
              color: Colors.black,
              height: 1.3,
            ),
          ),
          Text(
            "İsim Soyisim: ${orderDetailModel.shipping?.firstName ?? ''} ${orderDetailModel.shipping?.lastName ?? ''}",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
              color: Colors.black,
              height: 1.3,
            ),
          ),
          Text(
            "Telefon: ${orderDetailModel.shipping?.phone ?? ''}",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
              color: Colors.black,
              height: 1.3,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Ödeme Yöntemi:",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              fontFamily: "Poppins",
              color: Colors.black,
              height: 1.4,
            ),
          ),
          Text(
            "${orderDetailModel.paymentMethod == 'COD' ? 'Kapıda ödeme' : orderDetailModel.paymentMethod ?? ''}",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
              color: Colors.black,
              height: 1.3,
            ),
          ),

          Divider(color: Colors.grey),
          SizedBox(height: 5),
          CheckPoints(
            checkedTill: 0,
            checkPoints: [
              "Processing",
              "Shipping",
              "Delivered",
            ],
            checkPointFilledColor: Colors.redAccent,
          ),
          Divider(color: Colors.grey),
          _listOrderItems(context, orderDetailModel),
          Divider(color: Colors.grey),
          _itemTotal(
            "Ara Toplam",
            "${orderDetailModel.itemTotalAmount ?? ''}",
            TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
              color: Colors.black,
              height: 1.3,
            ),
          ),
          _itemTotal(
            "Kargo Ücreti",
            "${orderDetailModel.shippingTotal ?? ''}",
            TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
              color: Colors.black,
              height: 1.3,
            ),
          ),
          _itemTotal(
            "Toplam",
            "${orderDetailModel.totalAmount ?? ''}",
            TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              fontFamily: "Poppins",
              color: Colors.black,
              height: 1.4,
            ),
          ),
          Divider(color: Colors.grey),
        ],
      ),
    );
  }

  Widget _listOrderItems(BuildContext context, OrderDetailModel orderDetailModel) {
    return ListView.builder(
      itemCount: orderDetailModel.lineItems?.length ?? 0,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var product = orderDetailModel.lineItems![index];
        var productImage = product.image != null ? product.image!['src'] : '';

        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.all(2),
          onTap: () {},
          leading: productImage.isNotEmpty
              ? Image.network(
            productImage,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          )
              : Container(
            width: 50,
            height: 50,
            color: Colors.grey,
          ),
          title: Text(
            product.productName ?? '',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
              color: Colors.black,
              height: 1.3,
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 1),
            child: Text("Adet: ${product.quantity ?? ''}", style: TextStyle(fontFamily: "Poppins",),),
          ),
          trailing: Text("${Config.currency}${product.totalAmount ?? ''}", style: TextStyle(fontFamily: "Poppins",)),
        );
      },
    );
  }

  Widget _itemTotal(String label, String value, TextStyle textStyle) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      contentPadding: EdgeInsets.fromLTRB(2, -10, 2, -10),
      onTap: () {},
      title: Text(
        label,
        style: textStyle,
      ),
      trailing: Text("${Config.currency}$value", style: TextStyle(fontFamily: "Poppins",)),
    );
  }
}
