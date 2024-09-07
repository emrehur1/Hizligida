import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hizligida/provider/load_provider.dart';
import 'package:hizligida/utils/ProgressHUD.dart';
import '../utils/widget_checkpoints.dart';
import 'home_page.dart';

class CheckoutBasePage extends StatefulWidget {
  @override
  CheckoutBasePageState createState() => CheckoutBasePageState();
}

class CheckoutBasePageState<T extends CheckoutBasePage> extends State<T> {
  int currentPage = 0;
  bool showBackbutton = true;

  @override
  void initState() {
    super.initState();
    print('CheckoutBasePage: initState()');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(
      builder: (context, loaderModel, child) {
        return Scaffold(
          appBar: _buildAppBar(),
          backgroundColor: Colors.white,
          body: ProgressHUD(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CheckPoints(
                    checkedTill: currentPage,
                    checkPoints: [
                      "Shipping",
                      "Payment",
                      "Order",
                    ],
                    checkPointFilledColor: Colors.green,
                  ),
                  Divider(color: Colors.black),
                  pageUI(),
                ],
              ),
            ),
            inAsyncCall: loaderModel.isApiCallProcess,
            opacity: 0.3,
          ),
        );
      },
    );
  }

  _buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: showBackbutton,
      title: Text(
        "Ödeme",
        style: TextStyle(color: Colors.black, fontFamily: "Poppins"),
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false,
          );
        },
      ),
      actions: <Widget>[],
    );
  }


  Widget pageUI() {
    return SizedBox();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
