import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/country.dart';

class MastersProvider with ChangeNotifier {
  APIService? _apiService;
  List<Country>? _countryList;
  Country? _selectedShippingCountry;
  Country? _selectedBillingCountry;
  States? _selectedShippingState;
  States? _selectedBillingState;

  List<Country>? get allCountries => _countryList;
  Country? get selectedShippingCountry => _selectedShippingCountry;
  Country? get selectedBillingCountry => _selectedBillingCountry;
  States? get selectedShippingState => _selectedShippingState;
  States? get selectedBillingState => _selectedBillingState;

  MastersProvider() {
    _apiService = APIService();
  }

  resetStreams() {
    _countryList = List<Country>.empty(growable: true);
  }

  fetchAllMasters() async {
    // Listeyi sıfırla
    _countryList = [];

    List<Country> itemModel = await _apiService!.getCountries();
    if (itemModel.isNotEmpty) {
      _countryList!.addAll(itemModel);
    }
    notifyListeners();
  }

  setSelectedShippingCountry(Country country) {
    _selectedShippingCountry = country;
    _selectedShippingState = null; // State sıfırlanır
    notifyListeners();
  }

  setSelectedBillingCountry(Country country) {
    _selectedBillingCountry = country;
    _selectedBillingState = null; // State sıfırlanır
    notifyListeners();
  }

  setSelectedShippingState(States? state) {
    _selectedShippingState = state;
    notifyListeners();
  }

  setSelectedBillingState(States? state) {
    _selectedBillingState = state;
    notifyListeners();
  }
  notify() {
    notifyListeners();
  }
}
