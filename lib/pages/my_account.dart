import 'package:flutter/material.dart';
import 'package:hizligida/models/customer_detail_model.dart';
import 'package:hizligida/pages/edit_adress.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart'; // UserModel'inizi import edin
import '../shared_service.dart';
import 'edit_profile.dart';
import 'home_page.dart';
import 'orders_page.dart';
import '../widgets/unauth_widget.dart';
import 'package:hizligida/utils/cart_icons.dart';
import 'package:hizligida/provider/cart_provider.dart';
import 'package:hizligida/api_service.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class OptionList {
  String optionTitle;
  String optionSubTitle;
  IconData optionIcon;
  Function onTap;

  OptionList(
      this.optionIcon,
      this.optionTitle,
      this.optionSubTitle,
      this.onTap,
      );
}

class _MyAccountState extends State<MyAccount> {
  List<OptionList> options = [];
  String firstName = "";
  String lastName = "";
  late APIService _apiService;
  late CustomerDetailsModel _model;

  @override
  void initState() {
    super.initState();
    _apiService = APIService(); // _apiService örneğini başlat
    _loadUserDetails();

    options.add(
      OptionList(
        Icons.inventory_2,
        "Siparişlerim",
        "Siparişlerini kontrol edebilirsin.",
            () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrdersPage(),
            ),
          );
        },
      ),
    );

    options.add(
      OptionList(
        Icons.edit,
        "Profilim",
        "Bilgilerini güncelleyebilirsin.",
            () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditNamePage(),
            ),
          );
        },
      ),
    );
    options.add(
      OptionList(
        Icons.location_on,
        "Adresim",
        "Adresini güncelleyebilirsin.",
            () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditAddressPage(),
            ),
          );
        },
      ),
    );

    options.add(
      OptionList(
        Icons.power_settings_new,
        "Çıkış Yap",
        "Hesabından çıkış yapabilirsin.",
            () async {
          await SharedService.logout();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
                (Route<dynamic> route) => false,
          );
        },
      ),
    );
  }

  Future<void> _loadUserDetails() async {
    try {
      _model = (await _apiService
          .customerDetails())!; // customerDetails çağrısını yap ve sonucu al

      // Verileri state içine set et
      setState(() {
        firstName = _model.firstName ?? "";
        lastName = _model.lastName ?? "";
      });
    } catch (error) {
      print("Hata oluştu: $error");
      setState(() {
        firstName = "Error";
        lastName = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hesabım',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: SharedService.isLoggedIn(),
        builder: (
            BuildContext context,
            AsyncSnapshot<bool> loginModel,
            ) {
          if (loginModel.hasData) {
            if (loginModel.data!) {
              return Container(
                color: Colors.white,
                child: _listView(context),
              );
            } else {
              return UnAuthWidget();
            }
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildRow(OptionList optionList, int index) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Card(
        color: Colors.blueGrey[50], // Kutunun iç rengi burada belirleniyor
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Yuvarlak köşeler
        ),
        elevation: 0, // Gölge seviyesi (eğer istemiyorsanız sıfır yapabilirsiniz)
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              optionList.optionIcon,
              color: Colors.black,
              size: 30,
            ),
          ),
          onTap: () {
            return optionList.onTap();
          },
          title: Text(
            optionList.optionTitle,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              optionList.optionSubTitle,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ),
    );
  }


  Widget _listView(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hoşgeldin ${firstName} ${lastName}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          itemCount: options.length,
          physics: ScrollPhysics(),
          padding: EdgeInsets.all(8.0),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0,
              child: _buildRow(options[index], index),
            );
          },
        ),
      ],
    );
  }
}
