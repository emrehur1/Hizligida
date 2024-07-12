import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Eklendi
import 'package:hizligida/pages/dashboard_page.dart';
import 'package:hizligida/utils/cart_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _widgetList = [
    DashboardPage(),
    DashboardPage(),
    DashboardPage(),
    DashboardPage()
  ];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CartIcons.home),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(CartIcons.cart),
            label: 'My Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(CartIcons.favourites),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(CartIcons.account),
            label: 'My Account',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.shifting,
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
      body: _widgetList[_index],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light, // brightness yerine systemOverlayStyle kullanıldı
      elevation: 0,
      backgroundColor: Colors.redAccent,
      automaticallyImplyLeading: false,
      title: Text(
        "Hızlı Gıda",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        Icon(Icons.notifications_none, color: Colors.white),
        SizedBox(width: 10,),
        Icon(Icons.shopping_cart, color: Colors.white),
        SizedBox(width: 10,),
      ],
    );
  }
}
