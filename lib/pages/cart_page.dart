import 'package:flutter/material.dart';
import 'package:hizligida/models/cart_response_model.dart';
import 'package:hizligida/pages/verify_adress.dart';
import 'package:hizligida/utils/ProgressHUD.dart';
import 'package:hizligida/provider/cart_provider.dart';
import 'package:hizligida/provider/load_provider.dart';
import 'package:hizligida/widgets/widget_order_succes.dart';
import 'package:provider/provider.dart';
import 'package:hizligida/utils/custom_stepper.dart';
import 'package:hizligida/utils/utils.dart';
import 'package:hizligida/models/product.dart';
import 'package:hizligida/models/variable_product.dart';
import 'package:hizligida/api_service.dart';
import 'package:hizligida/pages/product_details.dart';

import '../shared_service.dart';
import '../widgets/unauth_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  APIService apiService = APIService();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    var cartItemsList = Provider.of<CartProvider>(context, listen: false);
    cartItemsList.resetStreams();
    cartItemsList.fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: SharedService.isLoggedIn(),
      builder: (
          BuildContext context,
          AsyncSnapshot<bool> loginModel,
          ) {
        if (loginModel.hasData) {
          if (loginModel.data!) {
            return Consumer<LoaderProvider>(
              builder: (context, loaderModel, child) {
                return Scaffold(
                  key: scaffoldKey,
                  appBar: AppBar(
                    title: Text('Sepetim',style: TextStyle(color: Colors.black,fontFamily: 'Poppins',)),

                    backgroundColor: Colors.white,
                  ),
                  body: ProgressHUD(
                    child: Column(
                      children: [
                        Expanded(child: _buildCartList(context)),
                      ],
                    ),
                    inAsyncCall: loaderModel.isApiCallProcess,
                    opacity: 0.3,
                  ),
                  bottomNavigationBar: _buildBottomBar(context), // Include the bottom bar here
                );
              },
            );
          } else {
            return UnAuthWidget();
          }
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildCartList(BuildContext context) {
    var cartModel = Provider.of<CartProvider>(context);

    if (cartModel.cartItems != null && cartModel.cartItems.isNotEmpty) {
      return ListView.builder(
        itemCount: cartModel.cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = cartModel.cartItems[index];
          return _buildCartItem(context, cartItem);
        },
      );
    } else {
      return Center(child: Text('Sepette ürün bulunmamaktadır',style: TextStyle(color: Colors.black,fontFamily: 'Poppins',)),);
    }
  }

  Widget _buildCartItem(BuildContext context, CartItem cartItem) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                List<VariableProduct> variableProducts = [];
                if (cartItem.variationId != null && cartItem.variationId != 0) {
                  variableProducts = await apiService.getVariableProducts(cartItem.productId!);
                }

                List<ProductAttributes> attributes = [];
                if (cartItem.attribute != null && cartItem.attributeValue != null) {
                  attributes.add(ProductAttributes(name: cartItem.attribute!, options: [cartItem.attributeValue!]));
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetails(
                      product: Product(
                        id: cartItem.productId,
                        name: cartItem.productName,
                        price: cartItem.productSalePrice?.toString() ?? '',
                        regularPrice: cartItem.productRegularPrice?.toString() ?? '',
                        salePrice: cartItem.productSalePrice?.toString() ?? '',
                        type: cartItem.variationId != null && cartItem.variationId != 0 ? "variable" : "simple",
                        images: [Images(src: cartItem.thumbnail)],
                        attributes: attributes,
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                child: cartItem.thumbnail != null
                    ? Image.network(
                  cartItem.thumbnail!,
                  height: 80,
                  width: 80,
                )
                    : Placeholder(),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.productName ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (cartItem.attributeValue != null && cartItem.attribute != null)
                    Text(
                      "${cartItem.attributeValue} ${cartItem.attribute}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  SizedBox(height: 5),
                  Text(
                    cartItem.productSalePrice != null
                        ? "₺${cartItem.productSalePrice.toString()}"
                        : "Fiyat bilgisi bulunmamaktadır",
                    style: TextStyle(
                      fontSize: 14,
                      color: cartItem.productSalePrice != null ? Colors.black : Colors.red,
                        fontFamily: 'Poppins'
                    ),
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      Utils.showMessage(
                          context,
                          "Hızlı Gıda",
                          "Silmek istiyor musunuz?",
                          "Evet",
                              () {
                            Provider.of<LoaderProvider>(context, listen: false).setLoadingStatus(true);

                            if (cartItem.productId != null) {
                              Provider.of<CartProvider>(context, listen: false).removeItem(cartItem.productId!);
                              var cartProvider = Provider.of<CartProvider>(context, listen: false);
                              cartProvider.updateCart((val) {
                                Provider.of<LoaderProvider>(context, listen: false).setLoadingStatus(false);
                              });
                            } else {
                              // Hata yönetimi: productId null ise ne yapılacağını belirleyin.
                            }
                            Provider.of<LoaderProvider>(context, listen: false).setLoadingStatus(false);
                            Navigator.of(context).pop();
                          },
                          buttonText2: "Hayır",
                          isConfirmationDialog: true,
                          onPressed2: () {
                            Navigator.of(context).pop();
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(8),
                      backgroundColor: Colors.black, // Butonun arka plan rengini siyah yap
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Köşeleri yuvarlat
                      ),
                      shadowColor: Colors.black.withOpacity(0.2), // Gölge rengi
                      elevation: 5, // Gölge efekti için elevation
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Sil",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CustomStepper(
              lowerLimit: 1,
              upperLimit: 20,
              stepValue: 1,
              iconSize: 22.0,
              value: cartItem.qty ?? 1,
              onChanged: (value) {
                if (cartItem.productId != null) {
                  Provider.of<LoaderProvider>(context, listen: false).setLoadingStatus(true);
                  Provider.of<CartProvider>(context, listen: false).updateQty(cartItem.productId!, value, variationId: cartItem.variationId ?? 0);
                  var cartProvider = Provider.of<CartProvider>(context, listen: false);
                  cartProvider.updateCart((val) {
                    Provider.of<LoaderProvider>(context, listen: false).setLoadingStatus(false);
                  });
                } else {
                  // Hata yönetimi: productId null ise ne yapılacağını belirleyin.
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    var cartModel = Provider.of<CartProvider>(context);
    double totalPrice = cartModel.cartItems.fold(0.0, (sum, item) => sum + (item.productSalePrice ?? 0.0) * (item.qty ?? 1));

    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -1),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Toplam',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                    ),
                  ),
                  Text(
                    '₺${totalPrice.toString()}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VerifyAddress()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                  backgroundColor: Colors.black, // Butonun arka plan rengini siyah yap
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Köşeleri yuvarlat
                  ),
                  shadowColor: Colors.black.withOpacity(0.2), // Gölge rengi
                  elevation: 5, // Gölge efekti için elevation
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Satın Al',
                      style: TextStyle(
                        color: Colors.white, // Yazı rengi beyaz
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        fontFamily: 'Poppins', // Yazı fontu olarak Poppins kullan
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
        ],
      ),
    );
  }
}


