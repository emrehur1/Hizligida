import '../models/payment_method.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class PaymentMethodListItem extends StatelessWidget {
  final PaymentMethod paymentMethod;

  PaymentMethodListItem({Key? key, required this.paymentMethod}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.redAccent, // Theme.of(context).accentColor
      focusColor: Colors.redAccent, // Theme.of(context).accentColor
      highlightColor: Colors.white, // Theme.of(context).primaryColor
      onTap: () {
        if (this.paymentMethod.isRouteRedirect) {
          Navigator.of(context).pushNamed(this.paymentMethod.route);
        } else {
          this.paymentMethod.onTap();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.1), // Theme.of(context).focusColor.withOpacity(0.1)
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.1), // Theme.of(context).focusColor.withOpacity(0.1)
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                image: DecorationImage(
                  image: AssetImage(paymentMethod.logo),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          paymentMethod.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            height: 1.3,
                          ),
                        ),
                        Text(
                          paymentMethod.description,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }
}