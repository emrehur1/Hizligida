import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hizligida/pages/cart_page.dart';
import 'package:hizligida/pages/dashboard_page.dart';
import 'package:hizligida/pages/my_account.dart';
import 'package:hizligida/pages/search_page.dart';
import 'package:provider/provider.dart';
import 'package:hizligida/provider/cart_provider.dart';

class HomePage extends StatefulWidget {
  final int selectedPage;

  HomePage({Key? key, this.selectedPage = 0}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
    if (widget.selectedPage != null) {
      _index = widget.selectedPage;
    }
  }

  void _loadCartItems() async {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    await cartProvider.fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Sepetim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorilerim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Hesabım',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
        ),
        currentIndex: _index,
        onTap: (index) {
          if (index == 0) {
            setState(() {
              _index = index;
            });
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyAccount(),
              ),
            );
          } else {
            setState(() {
              _index = index;
            });
          }
        },
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    // Geçerli sayfayı göstermek için kullanılır
    switch (_index) {
      case 0:
        return DashboardPage();
      case 2:
        return DashboardPage(); // Favoriler için bir sayfa ekleyebilirsiniz
      default:
        return DashboardPage();
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,

      title: Image.asset(
        'assets/img/logo.PNG',
        height: 40,
        fit: BoxFit.contain, // İhtiyacınıza göre yüksekliği ayarlayın
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(),
              ),
            );
          },
        ),

        _buildCartIcon(),
        SizedBox(width: 10,),
      ],
    );
  }

  Widget _buildCartIcon() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Stack(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(),
                  ),
                );
              },
            ),
            if (cartProvider.cartItems.isNotEmpty)
              Positioned(
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${cartProvider.cartItems.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
