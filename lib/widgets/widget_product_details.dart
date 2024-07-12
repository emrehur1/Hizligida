import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hizligida/models/product.dart';
import 'package:hizligida/utils/custom_stepper.dart';
import 'package:hizligida/utils/expand_text.dart';
import 'package:hizligida/widgets/widget_related_products.dart';
import 'package:hizligida/provider/load_provider.dart';
import 'package:hizligida/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:hizligida/models/cart_request_model.dart';

class ProductDetailsWidget extends StatefulWidget {
  final Product data;
  CartProducts cartProducts = CartProducts();

  ProductDetailsWidget({Key? key, required this.data}) : super(key: key);

  @override
  _ProductDetailsWidgetState createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  int qty = 1;

  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    widget.cartProducts.quantity = qty; // Initialize the cartProducts quantity
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
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
                    '${widget.data.calculateDiscount()}% OFF',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                widget.data.name ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.data.attributes != null &&
                        widget.data.attributes!.length > 0
                        ? (widget.data.attributes![0].name! +
                        ": " +
                        widget.data.attributes![0].options!.join("-")
                            .toString())
                        : "",
                  ),
                  Text(
                    "\$${widget.data.salePrice}",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
                    onPressed: () {
                      Provider.of<LoaderProvider>(context, listen: false)
                          .setLoadingStatus(true);

                      var cartProvider =
                      Provider.of<CartProvider>(context, listen: false);

                      widget.cartProducts.productId = widget.data.id;

                      cartProvider.addToCart(
                        widget.cartProducts,
                            (val) {
                          Provider.of<LoaderProvider>(context, listen: false)
                              .setLoadingStatus(false);
                          print(val);
                        },
                      );
                    },
                    child: Text(
                      "Sepete Ekle",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.all(15),
                      shape: StadiumBorder(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ExpandableText(
                labelHeader: 'Product Description',
                desc: widget.data.description ?? '',
                shortDesc: (widget.data.description != null &&
                    widget.data.description!.length > 100)
                    ? widget.data.description!.substring(0, 100) + '...'
                    : widget.data.description ?? '',
              ),
              SizedBox(height: 10),
              Text(
                "Availability : ${widget.data.stockStatus}",
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
                  "Product Code : ${widget.data.sku}",
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
      height: 250,
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
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  );
                },
                carouselController: _controller,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                _controller.previousPage();
              },
            ),
          ),
          Positioned(
            top: 100,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                _controller.nextPage();
              },
            ),
          ),
        ],
      ),
    );
  }
}
