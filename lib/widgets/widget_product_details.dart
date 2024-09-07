import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hizligida/models/product.dart';
import 'package:hizligida/models/variable_product.dart';
import 'package:hizligida/utils/custom_stepper.dart';
import 'package:hizligida/utils/expand_text.dart';
import 'package:hizligida/widgets/unauth_widget.dart';
import 'package:hizligida/widgets/widget_related_products.dart';
import 'package:hizligida/provider/load_provider.dart';
import 'package:hizligida/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:hizligida/models/cart_request_model.dart';

import '../shared_service.dart';

class ProductDetailsWidget extends StatefulWidget {
  final Product data;
  final List<VariableProduct>? variableProducts;
  CartProducts cartProducts = CartProducts();

  ProductDetailsWidget({Key? key, required this.data, this.variableProducts}) : super(key: key);

  @override
  _ProductDetailsWidgetState createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  int qty = 1;
  VariableProduct? selectedVariableProduct;

  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    widget.cartProducts.quantity = qty; // Initialize the cartProducts quantity

    // En düşük gramajı ve ilgili fiyatı seçin
    if (widget.data.type == "variable" && widget.variableProducts != null && widget.variableProducts!.isNotEmpty) {
      selectedVariableProduct = widget.variableProducts!.first;
      widget.data.price = selectedVariableProduct!.price;
      widget.data.regularPrice = selectedVariableProduct!.regularPrice;
      widget.data.salePrice = selectedVariableProduct!.salePrice;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debugging prints
    //print('Product type: ${widget.data.type}');
   // print('Attributes: ${widget.data.attributes}');

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              productImages(widget.data.images ?? [], context),
              SizedBox(height: 10),
              Visibility(
                visible: widget.data.calculateDiscount() > 0,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(color: Colors.green),
                  child: Text(
                    '${widget.data.calculateDiscount()}% İNDİRİM',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.data.name ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\₺${widget.data.price}",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              if (widget.data.type == "variable" &&
                  widget.data.attributes != null &&
                  widget.data.attributes!.isNotEmpty &&
                  widget.variableProducts != null &&
                  widget.variableProducts!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,  // Adjust width as needed
                    child: selectDropdown(
                      context,
                      selectedVariableProduct ?? widget.variableProducts!.first,
                      widget.variableProducts!,
                          (value) {
                        setState(() {
                          selectedVariableProduct = value;
                          widget.data.price = value.price;
                          widget.data.regularPrice = value.regularPrice;
                          widget.data.salePrice = value.salePrice;
                        });
                      },
                    ),
                  ),
                ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomStepper(
                    lowerLimit: 1,
                    upperLimit: 20,
                    stepValue: 1,
                    iconSize: 22.0,
                    value: qty,
                    onChanged: (value) {
                      setState(() {
                        qty = value;
                      });
                      widget.cartProducts.quantity = qty;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      bool isLoggedIn = await SharedService.isLoggedIn();

                      if (!isLoggedIn) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UnAuthWidget()),
                        );
                      } else {
                        Provider.of<LoaderProvider>(context, listen: false)
                            .setLoadingStatus(true);

                        var cartProvider =
                        Provider.of<CartProvider>(context, listen: false);


                        setState(() {
                          widget.cartProducts.productId = widget.data.id;
                          widget.cartProducts.variationId = selectedVariableProduct != null
                              ? selectedVariableProduct!.id
                              : 0;
                          widget.cartProducts.quantity = qty; // Sepete eklemeden önce `quantity` değerini güncelliyoruz.
                        });

                        cartProvider.addToCart(
                          widget.cartProducts,
                              (val) {
                            Provider.of<LoaderProvider>(context, listen: false)
                                .setLoadingStatus(false);
                            print(val);
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Arka plan rengini siyah yap
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0), // Hem dikey hem yatay padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Köşeleri yuvarlat
                      ),
                      shadowColor: Colors.black.withOpacity(0.2), // Gölge rengi
                      elevation: 5, // Gölge efekti için elevation
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sepete Ekle",
                          style: TextStyle(
                            color: Colors.white, // Yazı rengini beyaz yap
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
              SizedBox(height: 10),
              ExpandableText(
                labelHeader: 'Ürün Açıklaması',
                desc: widget.data.description ?? '',
                shortDesc: (widget.data.description != null &&
                    widget.data.description!.length > 100)
                    ? widget.data.description!.substring(0, 100) + '...'
                    : widget.data.description ?? '',
              ),
              SizedBox(height: 10),
              Text(
                "Stok Durumu : ${widget.data.stockStatus}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                    "Ürün Kodu : ${widget.data.sku}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
              SizedBox(height: 10),
              WidgetRelatedProducts(
                labelName: "İlgili ürünler",
                products: widget.data.relatedIds,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget productImages(List<Images> images, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 400, // Yüksekliği artırdık
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Visibility(
              visible: images.isNotEmpty,
              child: CarouselSlider.builder(
                itemCount: images.length,
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  aspectRatio: 1.0,
                  autoPlay: false,
                ),
                itemBuilder: (context, index, rindex) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Image.network(
                      images[index].src ?? "",
                      fit: BoxFit.cover, // Resmin tüm alanı kaplaması için cover olarak ayarlandı
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                  );
                },
                carouselController: _controller,
              ),
            ),
          ),

        ],
      ),
    );
  }


  static Widget selectDropdown(
      BuildContext context,
      VariableProduct initialValue,
      List<VariableProduct> data,
      Function onChanged, {
        Function? onValidate,
      }) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: 75,
        width: double.infinity,  // Set to maximum width
        padding: EdgeInsets.only(top: 5),
        child: DropdownButtonFormField<VariableProduct>(
          hint: Text("Select"),
          value: initialValue,
          isDense: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          ),
          onChanged: (VariableProduct? newValue) {
            FocusScope.of(context).requestFocus(FocusNode());
            onChanged(newValue);
          },
          validator: (value) {
            if (onValidate != null) {
              return onValidate(value);
            }
            return null;
          },
          items: data != null
              ? data.map<DropdownMenuItem<VariableProduct>>((VariableProduct data) {
            return DropdownMenuItem<VariableProduct>(
              value: data,
              child: Text(
                data.attributes!.first.option + " " + data.attributes!.first.name,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList()
              : null,
        ),
      ),
    );
  }


  static InputDecoration fieldDecoration(
      BuildContext context,
      String hintText, {
        required String helperText,
        required Widget prefixIcon,
        required Widget suffixIcon,
      }) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(6),
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
    );
  }
}
