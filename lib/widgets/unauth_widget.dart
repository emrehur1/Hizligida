import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/login_page.dart';

class UnAuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity, // Ekranın tamamını kapla
        color: Colors.white, // Arka plan rengini beyaz olarak ayarlayın
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // İkon olarak logo eklendi
            Image.asset(
              'assets/img/logo.PNG',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 15),
            Text(
              "Öncelikle giriş yapmanız gerekiyor.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                fontFamily: "Poppins", // Poppins fontu kullanıldı
                color: Colors.black, // Yazı rengi siyah yapıldı
                height: 1.3,
                decoration: TextDecoration.none, // Alt çizgiyi kaldırmak için eklendi
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              child: Text(
                'Giriş Yap',
                style: TextStyle(
                  color: Colors.black, // Yazı rengi siyah yapıldı
                  fontFamily: 'Poppins', // Poppins fontu kullanıldı
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Kullanıcıyı önceki sayfaya geri götürür
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Buton rengi siyah yapıldı
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: StadiumBorder(),
              ),
              child: Text(
                'Geri',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Poppins', // Poppins fontu kullanıldı
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
