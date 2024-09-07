import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hizligida/pages/home_page.dart';
import 'package:hizligida/models/customer_detail_model.dart';
import 'package:hizligida/pages/base_page.dart';
import '../api_service.dart';
import '../utils/City.dart';

class EditAddressPage extends BasePage {
  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends BasePageState<EditAddressPage> {
  CustomerDetailsModel? model;
  APIService? apiService;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;

  String? selectedState;

  @override
  void initState() {
    super.initState();
    apiService = APIService();
    _fetchCustomerDetails();
  }

  void _fetchCustomerDetails() async {
    var details = await apiService!.customerDetails();
    setState(() {
      model = details;
      selectedState = model!.shipping?.state;
    });
  }

  @override
  Widget pageUI() {
    if (model == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }else{
      return Scaffold(
        body: Form(
          key: globalFormKey,
          child: _formUI(),
        ),
      );
    }
  }

  Widget _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Adresinizi giriniz.",style: TextStyle(fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
            fontSize: 24),
              textAlign: TextAlign.center,),
            SizedBox(height: 15),

            Text("First Name",style: TextStyle(fontWeight: FontWeight.bold,
                fontFamily: "Poppins"),),
            TextFormField(
              initialValue: model!.shipping?.firstName ?? "",
              onSaved: (value) {
                this.model!.shipping?.firstName = value;
                this.model!.billing?.firstName = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter First Name.';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            Text("Last Name",style: TextStyle(fontWeight: FontWeight.bold,
                fontFamily: "Poppins"),),
            TextFormField(
              initialValue: model!.shipping?.lastName ?? "",
              onSaved: (value) {
                this.model!.shipping?.lastName = value;
                this.model!.billing?.lastName = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter Last Name.';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            Text("Addres",style: TextStyle(fontWeight: FontWeight.bold,
                fontFamily: "Poppins"),),
            TextFormField(
              initialValue: model!.shipping?.address1 ?? "",
              onSaved: (value) {
                this.model!.shipping?.address1 = value;
                this.model!.billing?.address1 = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter Address.';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            Text("Apartman/daire (opsiyonel)",style: TextStyle(fontWeight: FontWeight.bold,
                fontFamily: "Poppins"),),
            TextFormField(
              initialValue: model!.shipping?.address2 ?? "",
              onSaved: (value) {
                this.model!.shipping?.address2 = value;
                this.model!.billing?.address2 = value;
              },
            ),
            SizedBox(height: 10),
            Text("Şehir",style: TextStyle(fontWeight: FontWeight.bold,
                fontFamily: "Poppins"),),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedState,
              onChanged: (String? newValue) {
                setState(() {
                  selectedState = newValue;
                  model!.shipping?.state = newValue;
                  model!.billing?.state = newValue;
                });
              },
              items: CityStateMapping.cityToStateCode.values.map<DropdownMenuItem<String>>((String stateCode) {
                return DropdownMenuItem<String>(
                  value: stateCode,
                  child: Text(CityStateMapping.cityToStateCode.entries.firstWhere((entry) => entry.value == stateCode).key),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Şehir Seçin",
              ),
            ),
            SizedBox(height: 10),
            Text("İlçe",style: TextStyle(fontWeight: FontWeight.bold,
                fontFamily: "Poppins"),),
            TextFormField(
              initialValue: model!.shipping?.city ?? "",
              onSaved: (value) {
                this.model!.shipping?.city = value;
                this.model!.billing?.city = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Lütfen ilçe yazın.';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            Text("Posta kodu",style: TextStyle(fontWeight: FontWeight.bold,
                fontFamily: "Poppins"),),
            TextFormField(
              initialValue: model!.shipping?.postcode ?? "",
              onSaved: (value) {
                this.model!.shipping?.postcode = value;
                this.model!.billing?.postcode = value;
              },
            ),
            SizedBox(height: 20),
            Text("Telefon Numarası",style: TextStyle(fontWeight: FontWeight.bold,
                fontFamily: "Poppins"),),
            TextFormField(
              initialValue: model!.shipping?.phone ?? "",
              onSaved: (value) {
                this.model!.shipping?.phone = value;
                this.model!.billing?.phone = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Lütfen telefon numarası girin.';
                }
                return null;
              },
            ),
            SizedBox(height: 30),
            Center(
              child: Container(
                width: 150, // Butonun genişliğini burada belirliyorsunuz
                child: ElevatedButton(
                  onPressed: () {
                    if (validateAndSave()) {
                      model!.shipping?.country = "TR";
                      model!.billing?.country = "TR";

                      print(jsonEncode(model!.toJson()));
                      setState(() {
                        isApiCallProcess = true;
                      });

                      apiService!.updateCustomerAddress(model!).then((ret) {
                        setState(() {
                          isApiCallProcess = false;
                        });

                        if (ret != null) {
                          print(ret.toJson());

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Adres kaydı başarılı.")),
                          );
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => HomePage()),
                                (Route<dynamic> route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Tekrar deneyin.")),
                          );
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Arka plan rengi siyah
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32), // Dikey padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Köşeleri yuvarlak yapar
                    ),
                    textStyle: TextStyle(
                      fontSize: 14, // Yazı boyutunu biraz küçülttük
                      fontFamily: "Poppins", // Yazı fontu
                      fontWeight: FontWeight.bold, // Yazı kalınlığı
                      color: Colors.white, // Yazı rengi beyaz
                    ),
                  ),
                  child: Center(
                    child: Text("Kaydet", style: TextStyle(color: Colors.white)), // Yazı rengi beyaz
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}