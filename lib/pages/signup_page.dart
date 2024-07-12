import 'package:flutter/material.dart';
import 'package:hizligida/models/customers.dart';
import '../api_service.dart';
import '../utils/validator_service.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  APIService? apiService;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  CustomerModel? model;
  bool hidePassword = true;
  bool isApiCallProcess = false;

  @override
  void initState() {
    apiService = APIService();
    model = CustomerModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        title: Text("Register"),
      ),
      body: Stack(
        children: [
          _formUI(),
          if (isApiCallProcess)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: globalFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kayıt Ol",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Ad",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Adınızı giriniz.",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  model!.firstName = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir ad giriniz.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                "Soyad",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Lütfen Soyadınızı Giriniz.",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  model!.lastName = value;
                },
              ),
              SizedBox(height: 16),
              Text(
                "Email",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Email adresinizi giriniz.",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  model!.email = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen email adresinizi giriniz.';
                  }
                  if (value.isNotEmpty && !value.isValidEmail()) {
                    return 'Lütfen geçerli bir email giriniz.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                "Şifre",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Lütfen şifrenizi giriniz.",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
                obscureText: hidePassword,
                onSaved: (value) {
                  model!.password = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen şifre giriniz.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (validateAndSave()) {
                      setState(() {
                        isApiCallProcess = true;
                      });

                      bool emailExists = await apiService!.isEmailRegistered(model!.email!);
                      setState(() {
                        isApiCallProcess = false;
                      });

                      if (emailExists) {
                        showMessage(
                          context,
                          "Hızlı Gıda",
                          "Email zaten kayıtlı",
                          "Tamam",
                              () {
                            Navigator.of(context).pop();
                          },
                        );
                      } else {
                        setState(() {
                          isApiCallProcess = true;
                        });

                        bool ret = await apiService!.createCustomer(model!);
                        setState(() {
                          isApiCallProcess = false;
                        });

                        if (ret) {
                          showMessage(
                            context,
                            "Hızlı Gıda",
                            "Kayıt Başarılı!",
                            "Tamam",
                                () {
                              Navigator.of(context).pop();
                            },
                          );
                        } else {
                          showMessage(
                            context,
                            "Hızlı Gıda",
                            "Kayıt Başarısız :(",
                            "Tamam",
                                () {
                              Navigator.of(context).pop();
                            },
                          );
                        }
                      }
                    }
                  },
                  child: Text("Kayıt Ol"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
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

  void showMessage(BuildContext context, String title, String message, String buttonText, VoidCallback onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text(buttonText),
              onPressed: onPressed,
            ),
          ],
        );
      },
    );
  }
}
