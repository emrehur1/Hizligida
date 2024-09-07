import 'package:flutter/material.dart';
import 'package:hizligida/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:hizligida/models/order.dart';
import 'package:hizligida/models/payment_method.dart';
import 'package:hizligida/provider/cart_provider.dart';
import '../widgets/widget_order_succes.dart';
import 'checkout_base.dart';
import 'package:hizligida/config.dart';

class PaymentMethodsWidget extends CheckoutBasePage {
  @override
  _PaymentMethodsWidgetState createState() => _PaymentMethodsWidgetState();
}

class _PaymentMethodsWidgetState extends CheckoutBasePageState<PaymentMethodsWidget> {
  PaymentMethodList? list;
  int? paymentMode;

  @override
  void initState() {
    super.initState();
    Provider.of<CartProvider>(context, listen: false).fetchShippingCost(2, 2);
    this.currentPage = 1;
    paymentMode = 1;
  }

  @override
  Widget pageUI() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          cartItems(),
          SizedBox(height: 15),
          Card(
            elevation: 0,
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 1,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white),
              child: ListTile(
                dense: true,
                leading: Radio(
                  value: 1,
                  groupValue: paymentMode,
                  onChanged: (val) {
                    setState(() {
                      paymentMode = 1;
                    });
                  },
                ),
                title: Row(
                  children: [
                    Image.asset(
                      "assets/img/paypal.png",
                      width: 25,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "paypal".toUpperCase(),
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Poppins"
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            elevation: 0,
            margin: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 1,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white),
              child: ListTile(
                dense: true,
                leading: Radio(
                  value: 3,
                  groupValue: paymentMode,
                  onChanged: (val) {
                    setState(() {
                      paymentMode = 3;
                    });
                  },
                ),
                title: Row(
                  children: [
                    Image.asset(
                      "assets/img/stripe.png",
                      width: 25,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "stripe".toUpperCase(),
                      style: TextStyle(
                        fontSize: 15,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            elevation: 0,
            margin: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 1,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white),
              child: ListTile(
                dense: true,
                leading: Radio(
                  value: 2,
                  groupValue: paymentMode,
                  onChanged: (val) {
                    setState(() {
                      paymentMode = 2;
                    });
                  },
                ),
                title: Row(
                  children: [
                    Image.asset(
                      "assets/img/cash.png",
                      width: 25,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "cash on delivery".toUpperCase(),
                      style: TextStyle(
                        fontSize: 15,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              //minWidth: MediaQuery.of(context).size.width,
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Şimdi Öde'.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white, // Yazı rengi beyaz
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 1,
                      fontFamily: "Poppins", // Yazı fontu olarak Poppins kullan
                    ),
                  ),
                ],
              ),
              onPressed: () async {
                if (paymentMode == 1) {
                  // Paypal payment logic
                } else if (paymentMode == 2) {
                  var order = Provider.of<CartProvider>(context, listen: false);
                  OrderModel orderModel = OrderModel();
                  orderModel.paymentMethod = "COD";
                  orderModel.paymentMethodTitle = "COD";
                  orderModel.setPaid = true;
                  orderModel.transactionId = "TEST_COD";

                  order.processOrder(orderModel);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderSuccessWidget(),
                    ),
                    ModalRoute.withName("/OrderSuccess"),
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.black, // Butonun arka plan rengini siyah yap
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0), // İçerik padding'i
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Köşeleri yuvarlat
                ),
                elevation: 5, // Gölge efekti
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cartItems() {
    return Consumer<CartProvider>(
      builder: (context, cartModel, child) {
        if (cartModel.cartItems != null && cartModel.cartItems.isEmpty) {
          return Center(child: Text("Cart Empty"));
        } else if (cartModel.cartItems != null && cartModel.cartItems.isNotEmpty) {
          // Ara toplam ve kargo ücretini hesaplıyoruz
          double totalAmountWithShipping = cartModel.totalAmount + (cartModel.shippingCost ?? 0);

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                ),
                child: Text(
                  "Ürünleriniz",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: cartModel.cartItems.length,
                itemBuilder: (context, index) {
                  var cartItem = cartModel.cartItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cartItem.productName ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          cartItem.productSalePrice != null
                              ? "₺${cartItem.productSalePrice.toString()}"
                              : "Fiyat bilgisi bulunmamaktadır",
                          style: TextStyle(
                            fontSize: 14,
                            color: cartItem.productSalePrice != null ? Colors.black : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                color: Colors.black,
                child: Column(
                  children: [
                    Card(
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(
                        horizontal: .5,
                        vertical: .5,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.white),
                        child: ListTile(
                          dense: true,
                          title: Text(
                            "Ara Toplam",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Poppins",
                            ),
                          ),
                          trailing: Text(
                            "${Config.currency}${cartModel.totalAmount.toString()}",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    // Kargo ücreti kısmı eklendi
                    Card(
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 0.5,
                        vertical: 0.5,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.white),
                        child: ListTile(
                          dense: true,
                          title: Text(
                            "Kargo Ücreti",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Poppins",
                            ),
                          ),
                          trailing: Text(
                            "${Config.currency}${cartModel.shippingCost?.toString() ?? '0.0'}",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 0.5,
                        vertical: 0.5,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.white),
                        child: ListTile(
                          dense: true,
                          title: Text(
                            "TOPLAM",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                            ),
                          ),
                          trailing: Text(
                            "${Config.currency}${totalAmountWithShipping.toString()}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

}
