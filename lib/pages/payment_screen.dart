import 'package:hizligida/pages/base_page.dart';
import 'package:hizligida/models/payment_method.dart';
import 'package:hizligida/widgets/widget_payment_method_list_item.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends BasePage {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends BasePageState<PaymentScreen> {
  late PaymentMethodList list;

  @override
  Widget build(BuildContext context) {
    list = new PaymentMethodList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 15),
          list.paymentsList.length > 0
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              leading: Icon(
                Icons.payment,
                color: Colors.redAccent,
              ),
              title: Text(
                "Payment Options",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.redAccent,
                  height: 1.3,
                ),
              ),
              subtitle: Text("Select your preferred Payment Mode"),
            ),
          )
         : SizedBox(height: 0),
          SizedBox(height: 10),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              return PaymentMethodListItem(paymentMethod: list.paymentsList.elementAt(index));
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
            itemCount: list.paymentsList.length,
          ),
          list.cashList.length > 0
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              leading: Icon(
                Icons.monetization_on,
                color: Colors.redAccent,
              ),
              title: Text(
                "Cash on Delivery",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.redAccent,
                  height: 1.3,
                ),
              ),
              subtitle: Text("Select your preferred Payment Mode"),
            ),
          )
              : SizedBox(height: 0),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              return PaymentMethodListItem(paymentMethod: list.cashList.elementAt(index));
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
            itemCount: list.cashList.length,
          ),


        ],
      ),
    );
  }
}
