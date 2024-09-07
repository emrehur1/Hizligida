import 'package:flutter/foundation.dart';
import 'package:hizligida/models/login_model.dart';
import 'package:hizligida/api_service.dart';

import '../models/customer_detail_model.dart'; // API fonksiyonunun tanımlandığı dosyayı import et

class UserModel with ChangeNotifier {
  APIService? _apiService;
  Data? _userData;

  UserModel() {
    _apiService = APIService();
  }

  Data? get userData => _userData;

  // Kullanıcı verilerini güncelle
  void updateUserData(Data newData) {
    if (newData != null) {
      _userData = newData;
      notifyListeners(); // Tüm dinleyicilere güncelleme olduğunu bildir
    } else {
      print('Gelen veri null, update yapılmadı.');
    }
  }

  // Kullanıcı verilerini yükle
  //void loadUserData(LoginResponseModel loginResponseModel) {
 //   if (loginResponseModel.data != null) {
  //    _userData = loginResponseModel.data;
 //     notifyListeners();
  //  } else {
 //     print('LoginResponseModel\'de veri yok.');
 //   }
 // }

  // API'den kullanıcı verilerini çek ve güncelle
  Future<void> fetchUserData() async {
    // APIService sınıfındaki customerDetails metodunu çağırıyoruz
    CustomerDetailsModel? customerDetails = await _apiService?.customerDetails();

    if (customerDetails != null) {
      _userData = customerDetails as Data?;
      notifyListeners(); // Tüm dinleyicilere güncelleme olduğunu bildir
    } else {
      // Hata durumunda gerekli işlemleri yap
      print('Müşteri verileri alınamadı.');
    }
  }
}
