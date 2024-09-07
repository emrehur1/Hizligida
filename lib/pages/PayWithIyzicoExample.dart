import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebViewExample(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  late WebViewController _controller;
  final String sdkWebUrl = 'https://sandbox-mobil-sdk.iyzipay.com/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment SDK Integration'),
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: sdkWebUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
          },
          onPageFinished: (String url) async {
            if (url == sdkWebUrl) {
              final paymentBody = {
                'locale': 'tr',
                'conversationId': '123456789',
                'paidPrice': '50.19',
                'enabledInstallments': [2, 3, 6, 9],
                'price': '50.19',
                'paymentGroup': 'PRODUCT',
                'paymentSource': 'MOBILE_SDK',
                'callbackUrl': 'https://www.merchant.com/callback',
                'currency': 'TRY',
                'basketId': 'B67832',
                'buyer': {
                  'id': 'BY789',
                  'name': 'John',
                  'surname': 'Buyer',
                  'identityNumber': '74300864791',
                  'email': 'john.buyer@mail.com',
                  'gsmNumber': '+905555555555',
                  'registrationAddress': 'Adres',
                  'city': 'Istanbul',
                  'country': 'Turkey',
                  'ip': 'buyer Ip',
                },
                'shippingAddress': {
                  'address': 'Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1',
                  'contactName': 'John Buyer',
                  'city': 'Istanbul',
                  'country': 'Turkey',
                },
                'billingAddress': {
                  'address': 'Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1',
                  'contactName': 'John Buyer',
                  'city': 'Istanbul',
                  'country': 'Turkey',
                },
                'basketItems': [
                  {
                    'id': 'BI101',
                    'price': '50.19',
                    'name': 'Binocular',
                    'category1': 'Collectibles',
                    'itemType': 'PHYSICAL',
                  }
                ],
                'mobileDeviceInfoDto': {
                  'operatingSystemVersion': 'iOS - 13',
                  'model': 'iPhone 10',
                  'brand': 'Apple',
                },
              };
              final thirdPartyClientId = 'iyzico';
              final thirdPartyClientSecret = 'iyzicoSecret';
              final merchantApiKey = 'sandbox-FAXC123jF3qdtJw1rpL1FGAS521';
              final merchantSecretKey = 'sandbox-ZavaQFqTtasbAq41A';

              // Mesaj gönderimi
              final jsMessage = jsonEncode({
                'thirdPartyClientId': thirdPartyClientId,
                'thirdPartyClientSecret': thirdPartyClientSecret,
                'merchantApiKey': merchantApiKey,
                'merchantSecretKey': merchantSecretKey,
                'paymentBody': paymentBody,
                'sdkType': 'pwi',
              });

              _controller.runJavascript('window.postMessage($jsMessage)');
            }
          },

        ),
      ),
    );
  }
}
