import 'package:flutter/material.dart';
import 'package:hizligida/models/product.dart';
import 'package:hizligida/pages/product_details.dart';
import 'package:hizligida/pages/product_details.dart';

class ProductCard extends StatelessWidget {
  final Product data;

  ProductCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetails(
              product: data,

            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color(0xfff8f8f8),
              blurRadius: 15,
              spreadRadius: 10,
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Visibility(
                visible: data.calculateDiscount() > 0,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      '${data.calculateDiscount()}% OFF',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xffE65829).withAlpha(40),
                    ),
                    Image.network(
                      data.images != null &&
                          data.images!.isNotEmpty &&
                          data.images![0].src != null
                          ? data.images![0].src!
                          : "https://t4.ftcdn.net/jpg/04/70/29/97/360_F_470299797_UD0eoVMMSUbHCcNJCdv2t8B2g1GVqYgs.jpg",
                      height: 160,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          "https://t4.ftcdn.net/jpg/04/70/29/97/360_F_470299797_UD0eoVMMSUbHCcNJCdv2t8B2g1GVqYgs.jpg",
                          height: 160,
                          fit: BoxFit.cover,
                        );
                      },
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Text(
                data.name ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (data.salePrice != data.regularPrice)
                    Text(
                      "\$${data.regularPrice}",
                      style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(width: 5),
                  Text(
                    "\$${data.salePrice}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
