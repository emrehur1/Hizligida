import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hizligida/provider/load_provider.dart';
import 'package:hizligida/utils/ProgressHUD.dart';
import 'package:hizligida/provider/cart_provider.dart';
import 'package:hizligida/pages/home_page.dart';
import 'package:hizligida/pages/cart_page.dart'; // CartPage import edildi

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {
  bool isApiCallProcess = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(
      builder: (context, loaderModel, child) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: ProgressHUD(
            child: pageUI(),
            inAsyncCall: loaderModel.isApiCallProcess,
            opacity: 0.3,
          ),
        );
      },
    );
  }

  _buildAppBar() {
    return CustomAppBar();
  }

  Widget? pageUI() {
    return null;
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    int cartItemsLength = Provider.of<CartProvider>(context).cartItems.length;

    return AppBar(
      elevation: 0,
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: true,
      title: Text(''),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(), // CartPage'e yönlendirildi
                ),
              );
            },
            child: Stack(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(), // CartPage'e yönlendirildi
                      ),
                    );
                  },
                ),
                Provider.of<CartProvider>(context, listen: false)
                    .cartItems
                    .length ==
                    0
                    ? Container()
                    : Positioned(
                  child: Stack(
                    children: <Widget>[
                      Icon(
                        Icons.brightness_1,
                        size: 22.0,
                        color: Colors.green[800],
                      ),
                      Positioned(
                        top: 3.0,
                        right: 5.0,
                        child: Center(
                          child: Text(
                            Provider.of<CartProvider>(context,
                                listen: false)
                                .cartItems
                                .length
                                .toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
