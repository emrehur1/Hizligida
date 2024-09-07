import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hizligida/models/customers.dart';
import '../api_service.dart';
import '../shared_service.dart';
import '../utils/validator_service.dart';
import 'home_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String? username;
  String? password;
  APIService? apiService;

  @override
  void initState() {
    apiService = new APIService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arka planı beyaz yap
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 50), // Logonun üstte kalması için boşluk
                Image.asset(
                  'assets/img/logo.PNG', // Üstteki logo
                  width: 150,
                  height: 150,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Form(
                    key: globalKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 25),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => username = input,
                          validator: (input) {
                            if (input != null && input.contains('@')) {
                              return null;
                            } else {
                              return "Email geçersiz.";
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Email Adresi",
                            hintStyle: TextStyle(
                              color: Colors.black, // Siyah yazı rengi
                              fontFamily: 'Poppins',
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black, // İkon rengi siyah
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                          ),
                          keyboardType: TextInputType.text,
                          onSaved: (input) => password = input,
                          validator: (input) {
                            if (input!.length < 3) {
                              return "Şifre 3 karakterden uzun olmalı.";
                            } else {
                              return null;
                            }
                          },
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                            hintText: "Şifre",
                            hintStyle: TextStyle(
                              color: Colors.black, // Siyah yazı rengi
                              fontFamily: 'Poppins',
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black, // İkon rengi siyah
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              color: Colors.black,
                              icon: Icon(
                                hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (validateAndSave()) {
                              setState(() {
                                isApiCallProcess = true;
                              });

                              apiService!.loginCustomer(username!, password!)
                                  .then((ret) async {
                                setState(() {
                                  isApiCallProcess = false;
                                });

                                if (ret != null && ret.success == true) {
                                  SharedService.setLoginDetails(ret);
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(selectedPage: 3),
                                    ),
                                    ModalRoute.withName("/Home"),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("AJIO"),
                                        content: Text("Hatalı Giriş"),
                                        actions: [
                                          TextButton(
                                            child: Text("Ok"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // Buton rengi siyah yapıldı
                            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0), // Köşeleri yuvarlat
                            ),
                            shadowColor: Colors.black.withOpacity(0.2),
                            elevation: 5, // Gölge efekti
                          ),
                          child: Text(
                            "Giriş",
                            style: TextStyle(
                              color: Colors.white, // Yazı rengi beyaz
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              fontFamily: 'Poppins', // Yazı fontu olarak Poppins kullan
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 25,
                            ),
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontFamily: 'Poppins',
                                ),
                                children: <TextSpan>[
                                  const TextSpan(
                                    text: 'Hesabınız yok mu? ',
                                  ),
                                  TextSpan(
                                    text: 'Kayıt olun',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SignupPage(),
                                          ),
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40, // İkonu üst kısma yerleştirme
            right: 20, // İkonu sağ kısma yerleştirme
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black, // İkon rengi siyah
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(selectedPage: 0)),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ),
          if (isApiCallProcess)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
