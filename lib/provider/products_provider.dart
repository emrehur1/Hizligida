import 'package:flutter/material.dart';
import 'package:hizligida/models/product.dart';
import 'package:hizligida/api_service.dart';


import 'package:flutter/material.dart';
import 'package:hizligida/models/product.dart';
import 'package:hizligida/api_service.dart';

class SortBy {
  String value;
  String text;
  String sortOrder;

  SortBy(this.value, this.text, this.sortOrder);
}

enum LoadMoreStatus { INITIAL, LOADING, STABLE }

class ProductsProvider with ChangeNotifier {
  APIService? _apiService;
  List<Product> _allProducts = []; // Tüm ürünlerin saklandığı orijinal liste
  List<Product> _filteredProducts = []; // Filtrelenmiş ürünler
  List<Product> _productsList = []; // UI'da gösterilen ürünler
  SortBy? _sortBy;
  String? _currentCategoryId; // Mevcut kategori kimliği

  int totalPages = 0;
  int pageSize = 20;

  List<Product> get allProducts => _productsList;
  double get totalRecords => _productsList.length.toDouble();

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;
  LoadMoreStatus get getLoadMoreStatus => _loadMoreStatus;

  ProductsProvider() {
    resetStreams();
    _sortBy = SortBy("modified", "Latest", "asc");
  }

  void resetStreams() {
    _apiService = APIService();
    _allProducts = [];
    _filteredProducts = [];
    _productsList = [];
  }

  Future<void> fetchProducts(
      int pageNumber, {
        String? strSearch,
        String? tagName,
        String? categoryId,
        String? sortBy,
        String sortOrder = "asc",
      }) async {
    _currentCategoryId = categoryId; // Mevcut kategori kimliğini saklıyoruz

    List<Product> itemModel = await _apiService!.getProducts(
      strSearch: strSearch,
      pageNumber: pageNumber,
      pageSize: this.pageSize,
      tagName: tagName,
      categoryId: categoryId,
      sortBy: this._sortBy!.value,
      sortOrder: this._sortBy!.sortOrder,
    );

    if (itemModel.isNotEmpty) {
      _allProducts.addAll(itemModel);

      if (strSearch != null && strSearch.isNotEmpty) {
        // Arama teriminin ürün adında geçip geçmediğini kontrol eden filtreleme
        _filterSearchResults(_allProducts, strSearch);
      } else {
        _filteredProducts = _allProducts;
        _productsList = _filteredProducts; // İlk başta tüm ürünler gösterilir
      }
    }

    setLoadingState(LoadMoreStatus.STABLE);
    notifyListeners();
  }






  void setLoadingState(LoadMoreStatus loadMoreStatus) {
    _loadMoreStatus = loadMoreStatus;
    notifyListeners();
  }

  void setSortOrder(SortBy sortBy, {String? categoryId}) {
    _sortBy = sortBy;
    resetStreams();
    fetchProducts(1, categoryId: categoryId); // categoryId geçiliyor
  }

  void filterProductsByAttributes(
      List<String> selectedColors, // Seçilen renklerin listesi
      List<String> selectedSizes, // Seçilen bedenlerin listesi
      double minPrice, // Minimum fiyat
      double maxPrice) async { // Maksimum fiyat
    resetStreams(); // Filtreleme işleminden önce mevcut ürün listesini sıfırla
    await fetchProducts(1, categoryId: _currentCategoryId); // Belirtilen kategoriye göre ürünleri getir

    List<Product> filteredList = _allProducts.where((product) {
      bool matchesColor = selectedColors.isEmpty ? true : false; // Eğer renk seçilmemişse true, seçilmişse false olarak başla
      bool matchesSize = selectedSizes.isEmpty ? true : false; // Eğer beden seçilmemişse true, seçilmişse false olarak başla
      bool matchesPrice = false; // Fiyat eşleşmesi için başlangıçta false olarak ayarla

      if (product.attributes != null) { // Ürün özellikleri varsa
        for (var attribute in product.attributes!) { // Her bir özellik için döngü başlat
          if (attribute.name == "Renk" && attribute.options != null) { // Özellik ismi "Renk" ise ve seçenekler varsa
            for (var option in attribute.options!) { // Renk seçenekleri arasında dolaş
              if (selectedColors.contains(option)) { // Eğer seçilen renkler arasında mevcutsa
                matchesColor = true; // matchesColor'u true yap
              }
            }
          }
          if (attribute.name == "Beden" && attribute.options != null) { // Özellik ismi "Beden" ise ve seçenekler varsa
            for (var option in attribute.options!) { // Beden seçenekleri arasında dolaş
              if (selectedSizes.contains(option)) { // Eğer seçilen bedenler arasında mevcutsa
                matchesSize = true; // matchesSize'ı true yap
              }
            }
          }
        }
      }

      if (product.salePrice != null) { // Eğer ürün indirimli fiyata sahipse
        double price = double.tryParse(product.salePrice!) ?? 0.0; // İndirimli fiyatı double olarak al
        matchesPrice = price >= minPrice && price <= maxPrice; // Eğer fiyat belirtilen aralıkta ise matchesPrice'ı true yap
      } else if (product.regularPrice != null) { // Eğer ürünün normal fiyatı varsa
        double price = double.tryParse(product.regularPrice!) ?? 0.0; // Normal fiyatı double olarak al
        matchesPrice = price >= minPrice && price <= maxPrice; // Eğer fiyat belirtilen aralıkta ise matchesPrice'ı true yap
      }

      return matchesColor && matchesSize && matchesPrice; // Renk, beden ve fiyat kriterlerini sağlayan ürünleri döndür
    }).toList();

    _productsList = filteredList; // Filtrelenmiş ürün listesini _productsList'e ata
    notifyListeners(); // Dinleyicilere değişiklik olduğunu bildir
  }

  void _filterSearchResults(List<Product> allProducts, String searchTerm) {
    List<Product> matches = [];

    for (var product in allProducts) {
      if (product.name != null) {
        String productName = product.name!.toLowerCase();
        String lowerSearchTerm = searchTerm.toLowerCase();

        // Ürün adını kelimelere ayır ve her kelimenin arama terimi ile başlayıp başlamadığını kontrol et
        List<String> wordsInProductName = productName.split(' ');

        bool startsWithSearchTerm = wordsInProductName.any((word) => word.startsWith(lowerSearchTerm));

        if (startsWithSearchTerm) {
          matches.add(product);
        }
      }
    }

    // Eşleşen ürünlerle sonuçları güncelle
    _productsList = matches;
    notifyListeners();
  }






}


