import 'package:flutter/material.dart';
import 'package:hizligida/pages/checkout_base.dart';
import 'package:provider/provider.dart';
import '../pages/home_page.dart';
import '../provider/cart_provider.dart';

class OrderSuccessWidget extends CheckoutBasePage {
  @override
  _OrderSuccessWidgetState createState() => _OrderSuccessWidgetState();
}

class _OrderSuccessWidgetState extends CheckoutBasePageState<OrderSuccessWidget> {

  @override
  void initState() {
    currentPage = 2;
    showBackbutton = false;
    var orderProvider = Provider.of<CartProvider>(context,listen: false);
    orderProvider.createOrder();

    super.initState();
  }

  @override
  Widget pageUI() {
    return Consumer<CartProvider>(
      builder: (context, orderModel, child) {
        if (orderModel.isOrderCreated) {
          return Center(
            child: Container(
              margin: EdgeInsets.only(top: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Colors.green.withOpacity(1),
                              Colors.green.withOpacity(0.2),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 90,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Opacity(
                    opacity: 0.6,
                    child: Text(
                      "Siparişiniz başarıyla oluşturuldu",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                          color: Colors.black,
                          height: 1.3),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Köşeleri yuvarlat
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                            (Route<dynamic> route) => false,
                      );
                    },
                    child: Text(
                      'Anasayfaya Dön',
                      style: TextStyle(color: Colors.white,fontFamily: "Poppins"),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
