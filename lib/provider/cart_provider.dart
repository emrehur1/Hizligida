import 'package:flutter/foundation.dart';
import 'package:hizligida/models/cart_response_model.dart';
import 'package:hizligida/models/cart_request_model.dart';
import 'package:hizligida/api_service.dart';

class CartProvider with ChangeNotifier {
  late APIService _apiService;
  late List<CartItem> _cartItems;

  List<CartItem> get cartItems => _cartItems;

  double get totalRecords => _cartItems.length.toDouble();

  CartProvider() {
    _apiService = APIService();
    _cartItems = [];
  }

  void resetStreams() {
    _apiService = APIService();
    _cartItems = [];
  }

  void addToCart(
      CartProducts product,
      Function onCallback
      ) async {
    CartRequestModel requestModel = CartRequestModel();
    requestModel.products = [];

    if (_cartItems.isEmpty) resetStreams();

    for (var element in _cartItems) {
      requestModel.products?.add(CartProducts(
        productId: element.productId,
        quantity: element.qty,
      ));
    }

    var isProductExist = requestModel.products?.firstWhere(
          (prd) => prd.productId == product.productId,
      orElse: () => CartProducts(productId: 0, quantity: 0),
    );

    if (isProductExist != null && isProductExist.productId != 0) {
      requestModel.products?.remove(isProductExist);
    }

    requestModel.products?.add(product);

    await _apiService.addToCart(requestModel).then((cartResponseModel) {
      if (cartResponseModel?.data != null) {
        _cartItems = [];
        _cartItems.addAll(cartResponseModel!.data!); // Null check with '!'
      }
      onCallback(cartResponseModel);
      notifyListeners();
    }).catchError((error) {
      // Handle error
    });
  }
}
