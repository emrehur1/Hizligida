import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // SystemUiOverlayStyle için import
import 'package:hizligida/provider/load_provider.dart';
import 'package:hizligida/utils/ProgressHUD.dart'; // ProgressHUD için import
import 'package:hizligida/provider/load_provider.dart';
import 'package:provider/provider.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {
  bool isApiCallProcess = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(
      builder: (context, loaderModel, child) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: ProgressHUD(
            child: pageUI(),
            inAsyncCall: loaderModel.isApiCallProcess, // loaderModel düzeltilmiş
            opacity: 0.3,
          ),
        );
      },
    );
  }

  Widget? pageUI() {
    return null;
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light, // brightness yerine systemOverlayStyle kullanıldı
      elevation: 0,
      backgroundColor: Colors.redAccent,
      automaticallyImplyLeading: true,
      title: Text(
        "Hızlı Gıda",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        Icon(Icons.notifications_none, color: Colors.white),
        SizedBox(width: 10),
        Icon(Icons.shopping_cart, color: Colors.white),
        SizedBox(width: 10),
      ],
    );
  }
}
