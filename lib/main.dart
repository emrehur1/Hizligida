import 'package:flutter/material.dart';
import 'package:hizligida/pages/PayWithIyzicoExample.dart';
import 'package:hizligida/pages/base_page.dart';
import 'package:hizligida/pages/cart_page.dart';
import 'package:hizligida/pages/orders_page.dart';
import 'package:hizligida/pages/product_page.dart';
import 'package:hizligida/pages/home_page.dart';
import 'package:hizligida/pages/verify_adress.dart';
import 'package:hizligida/provider/cart_provider.dart';
import 'package:hizligida/provider/load_provider.dart';
import 'package:hizligida/provider/master_provider.dart';
import 'package:hizligida/provider/order_provider.dart';
import 'package:hizligida/provider/products_provider.dart';
import 'package:hizligida/provider/user_Provider.dart';
import 'package:provider/provider.dart';
//import 'package:hizligida/pages/product_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductsProvider(),
          child: ProductPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoaderProvider(),
          child: BasePage(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),

        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: CartPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
          child: OrdersPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => MastersProvider(),
          child: VerifyAddress(),
        ),
        ChangeNotifierProvider(create: (context) => UserModel()
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: Colors.blue,
            secondary: Colors.green,
            background: Colors.white,
            surface: Colors.white,
            error: Colors.red,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onBackground: Colors.black,
            onSurface: Colors.black,
            onError: Colors.white,
          ),
          useMaterial3: true,
        ),
        home: WebViewExample(),
        //HomePage(),
        routes: {
          '/home': (context) => HomePage(),
          '/product': (context) => ProductPage(),
          '/base': (context) => BasePage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
