import 'package:flutter/foundation.dart'; // Flutter'ın foundation paketini import eder, ChangeNotifier sınıfını kullanmak için gereklidir.
import 'package:hizligida/models/cart_response_model.dart'; // Sepet yanıt modelini içe aktarır.
import 'package:hizligida/models/cart_request_model.dart'; // Sepet istek modelini içe aktarır.
import 'package:hizligida/api_service.dart';
import 'package:hizligida/models/customer_detail_model.dart';

import '../models/order.dart';
import '../shared_service.dart'; // API hizmetini içe aktarır, API isteklerini yönetmek için kullanılır.

class CartProvider with ChangeNotifier {
  // ChangeNotifier'ı extend eden CartProvider sınıfı, durum yönetimi için kullanılır.
  late APIService _apiService; // APIService nesnesi, API isteklerini yapmak için kullanılır.
  late List<CartItem> _cartItems; // Sepetteki öğeleri tutar.
  CustomerDetailsModel? _customerDetailsModel;
  OrderModel? _orderModel;
  bool _isOrderCreated = false;
  double? _shippingCost; // Kargo ücreti için bir alan oluştur
  // Sepetteki öğeleri döndüren getter.
  List<CartItem> get cartItems => _cartItems;
  double? get shippingCost => _shippingCost; // Getter

  // Sepetteki toplam öğe sayısını döndüren getter.
  double get totalRecords => _cartItems.length.toDouble();
  double get totalAmount => _cartItems.isNotEmpty
      ? _cartItems.map<double>((m) => m.lineSubtotal!).reduce((a, b) => a + b)
      : 0;

  CustomerDetailsModel? get customerDetailsModel => _customerDetailsModel;
  OrderModel? get orderModel => _orderModel;
  bool get isOrderCreated => _isOrderCreated;

  // CartProvider constructor'ı, _apiService ve _cartItems'ı başlatır.
  CartProvider() {
    _apiService = APIService(); // APIService nesnesi başlatılır.
    _cartItems = []; // Sepet öğeleri boş bir liste olarak başlatılır.
  }

  // API servisini ve sepet öğelerini sıfırlar.
  void resetStreams() {
    _apiService = APIService(); // APIService nesnesi yeniden başlatılır.
    _cartItems = []; // Sepet öğeleri boş bir liste olarak sıfırlanır.
  }

  // Sepete ürün eklemek için kullanılan fonksiyon.
  void addToCart(
      CartProducts product, // Sepete eklenmek istenen ürün.
      Function
          onCallback // Ürün eklendikten sonra çağrılacak geri çağırma fonksiyonu.
      ) async {
    CartRequestModel requestModel =
        CartRequestModel(); // Yeni bir CartRequestModel nesnesi oluşturur.
    requestModel.products =
        []; // requestModel içindeki products listesini boş bir liste olarak başlatır.

    // Eğer sepet boşsa, resetStreams fonksiyonunu çağırır.
    if (_cartItems.isEmpty) {
      await fetchCartItems();
    }

    // Mevcut sepet öğelerini requestModel.products listesine ekler.
    for (var element in _cartItems) {
      requestModel.products?.add(CartProducts(
        productId: element.productId, // Sepetteki ürünün ID'si.
        quantity: element.qty,
        variationId: element.variationId, // Sepetteki ürünün miktarı.
      ));
    }

    // Eklenmek istenen ürünün sepet içinde mevcut olup olmadığını kontrol eder.
    var isProductExist = requestModel.products?.firstWhere(
      (prd) =>
          prd.productId == product.productId &&
          prd.variationId ==
              product.variationId, // Aynı ürün ID'sine sahip bir ürün bulursa.
      orElse: () => CartProducts(
          productId: 0,
          quantity: 0,
          variationId:
              0), // Bulamazsa, varsayılan olarak ID'si 0 olan bir ürün döner.
    );

    // Eğer ürün mevcutsa, sepetten çıkarır.
    if (isProductExist != null && isProductExist.productId != 0) {
      requestModel.products?.remove(isProductExist);
    }

    // Yeni ürünü products listesine ekler.
    requestModel.products?.add(product);

    // API'ye istek yapar ve sepeti günceller.
    await _apiService.addToCart(requestModel).then((cartResponseModel) {
      if (cartResponseModel?.data != null) {
        _cartItems = []; // Sepet öğelerini temizler.
        _cartItems
            .addAll(cartResponseModel!.data!); // Yeni sepet öğelerini ekler.
      }
      onCallback(cartResponseModel); // Geri çağırma fonksiyonunu çalıştırır.
      notifyListeners(); // Dinleyicilere durumu günceller.
    }).catchError((error) {
      // Hata durumunu ele alır.
    });
  }

  fetchCartItems() async {
    bool isLoggedIn = await SharedService.isLoggedIn();

    if (_cartItems == null) resetStreams();

    if (isLoggedIn) {
      await _apiService.getCartItems().then((cartResponseModel) {
        if (cartResponseModel != null && cartResponseModel.data != null) {
          _cartItems.addAll(cartResponseModel.data!);
        }
        notifyListeners();
      }).catchError((error) {
        print(
            "fetchCartItems hatası: $error");
      });
    }
  }

  void updateQty(int productId, int qty, {int variationId = 0}) {
    var isProductExist = _cartItems.firstWhere(
      (prd) => prd.productId == productId && prd.variationId == variationId,
    );

    if (isProductExist != null) {
      isProductExist.qty = qty;
    }

    notifyListeners();
  }

  void updateCart(Function onCallback) async {
    // _cartItems'ın null olmadığından emin olun
    _cartItems ??= [];

    // Yeni bir CartRequestModel oluştur
    CartRequestModel requestModel = CartRequestModel();
    requestModel.products = [];

    // _cartItems'tan gelen öğelerle requestModel.products'ı doldur
    _cartItems.forEach((element) {
      requestModel.products?.add(CartProducts(
        productId: element.productId,
        quantity: element.qty,
        variationId: element.variationId,
      ));
    });

    // Eğer requestModel.products boşsa, clearCartItems API çağrısını yapın
    if (requestModel.products!.isEmpty) {
      bool result = await _apiService.clearCartItems();
      onCallback(result ? 'Cart cleared successfully' : 'Failed to clear cart');
    } else {
      // API servis çağrısını bekleyin ve yanıtı işleyin
      var cartResponseModel = await _apiService.addToCart(requestModel);

      // cartResponseModel ve onun data'sının null olmadığından emin olun
      if (cartResponseModel != null && cartResponseModel.data != null) {
        _cartItems.clear(); // _cartItems'ı temizle
        _cartItems.addAll(cartResponseModel.data ??
            []); // cartResponseModel.data null değilse ekle
      }

      // Geri çağırmayı yürütün ve dinleyicilere bildirin
      onCallback(cartResponseModel);
    }

    notifyListeners();
  }


  void removeItem(int productId) {
    var isProductExist = _cartItems.firstWhere(
        (prd) => prd.productId == productId,
        orElse: () => CartItem(
            productId: 0,
            productName: '',
            productSalePrice: 0,
            qty: 0,
            thumbnail: ''));

    if (isProductExist.productId != 0) {
      _cartItems.remove(isProductExist);
    }

    notifyListeners();
  }

  fetchShippingDetails() async {
    if (_customerDetailsModel == null) {
      _customerDetailsModel = CustomerDetailsModel();
    }

    _customerDetailsModel = (await _apiService!.customerDetails())!;
    notifyListeners();
  }

  processOrder(OrderModel orderModel) {
    this._orderModel = orderModel;
    notifyListeners();
  }

  Future<bool> createOrder() async {
    print('createOrder fonksiyonu çağrıldı');

    try {
      if (_orderModel == null) {
        _orderModel = OrderModel();
      }

      if (_orderModel!.shipping == null) {
        _orderModel!.shipping = Shipping();
      }

      if (_orderModel!.billing == null) {
        _orderModel!.billing = Billing();
      }

      if (_customerDetailsModel == null) {
        _customerDetailsModel = CustomerDetailsModel();
        _customerDetailsModel = await _apiService!.customerDetails();
      }

      if (this.customerDetailsModel!.shipping != null) {
        _orderModel!.shipping = this.customerDetailsModel!.shipping;
      }

      if (this.customerDetailsModel!.billing != null) {
        _orderModel!.billing = this.customerDetailsModel!.billing;
      }

      if (_orderModel!.lineItems == null) {
        _orderModel!.lineItems = [];
      }

      _cartItems.forEach((v) {
        _orderModel!.lineItems!.add(
          LineItems(
            productId: v.productId,
            quantity: v.qty,
            variationId: v.variationId,
          ),
        );
      });

      _orderModel!.shippingLines = [
        ShippingLines(
          methodId: "flat_rate",
          methodTitle: "Flat Rate",
          total: _shippingCost?.toString() ?? "0.0", // Doğrudan _shippingCost değişkenini kullan
        ),
      ];


      bool orderResponse = await _apiService!.createOrder(_orderModel!);
      if (orderResponse) {
        _isOrderCreated = true;
        bool clearCartResponse = await _apiService!.clearCartItems();
        if (clearCartResponse) {
          _cartItems.clear();
          notifyListeners();
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Hata: $e');
      return false;
    }
  }
  Future<void> fetchShippingCost(int zoneId, int methodId) async {
    String? cost = await _apiService.getShippingCost(zoneId, methodId);
    if (cost != null) {
      _shippingCost = double.tryParse(cost) ?? 0.0;
      notifyListeners(); // Dinleyicilere değişiklik olduğunu bildir
    } else {
      _shippingCost = 0.0; // Eğer çekilemezse 0 olarak ayarla
      notifyListeners();
    }
  }

}
