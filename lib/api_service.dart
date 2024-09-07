import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hizligida/models/customers.dart';
import 'package:hizligida/config.dart';
import 'package:hizligida/models/login_model.dart';
import 'package:hizligida/models/category.dart';
import 'package:hizligida/models/product.dart';
import 'package:hizligida/models/cart_response_model.dart';
import 'package:hizligida/models/cart_request_model.dart';
import 'package:hizligida/models/country.dart';
import 'package:hizligida/models/variable_product.dart';
import 'package:hizligida/shared_service.dart';

import 'models/customer_detail_model.dart';
import 'models/order.dart';
import 'models/order_detail.dart';
import 'models/shipping_method.dart';
class APIService {
  Future<bool> isEmailRegistered(String email) async {
    var authToken = base64.encode(
        utf8.encode('${Config.key}:${Config.secret}'));

    try {
      var response = await Dio().get(
        '${Config.url}${Config.customersURL}?email=$email',
        options: Options(headers: {
          HttpHeaders.authorizationHeader: 'Basic $authToken',
          HttpHeaders.contentTypeHeader: "application/json"
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> customers = response.data;
        return customers.isNotEmpty;
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return false;
  }

  Future<bool> createCustomer(CustomerModel model) async {
    var authToken = base64.encode(
        utf8.encode('${Config.key}:${Config.secret}'));

    bool ret = false;

    try {
      var response = await Dio().post(
        '${Config.url}${Config.customersURL}',
        data: model.toJson(),
        options: Options(headers: {
          HttpHeaders.authorizationHeader: 'Basic $authToken',
          HttpHeaders.contentTypeHeader: "application/json"
        }),
      );

      print(response.statusCode);

      if (response.statusCode == 201) {
        ret = true;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        print(e.response?.statusCode);
        ret = false;
      } else {
        print(e.message);
        ret = false;
      }
    }

    return ret;
  }

  Future<LoginResponseModel?> loginCustomer(String username,
      String password,) async {
    LoginResponseModel? model;

    try {
      var response = await Dio().post(
        Config.tokenURL,
        data: {
          "username": username,
          "password": password,
        },
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
          },
        ),
      );

      if (response.statusCode == 200) {
        model = LoginResponseModel.fromJson(response.data);
      } else {
        print('Hata: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('DioError: ${e.message}');
    } catch (e) {
      print('Genel hata: $e');
    }
    return model;
  }

  Future<List<Category>> getCategories() async {
    List<Category> data = [];

    try {
      String url = Config.url +
          Config.categoriesURL +
          "?consumer_key=${Config.key}&consumer_secret=${Config.secret}";
      print(url);
      var response = await Dio().get(
        url,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        data = (response.data as List)
            .map(
              (i) => Category.fromJson(i),
        )
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    } catch (e) {
      print(e.toString());
    }

    return data;
  }

  Future<List<Product>> getProducts({
    int? pageNumber,
    int? pageSize,
    String? strSearch,
    String? tagName,
    String? categoryId,
    List<int>? productIds,
    String? sortBy,
    String sortOrder = "asc",
  }) async {
    List<Product> data = [];

    try {
      String parameter = "";

      if (strSearch != null) {
        parameter += "&search=$strSearch";
      }

      if (pageSize != null) {
        parameter += "&per_page=$pageSize";
      }

      if (pageNumber != null) {
        parameter += "&page=$pageNumber";
      }

      if (tagName != null) {
        parameter += "&tag=$tagName";
      }

      if (categoryId != null && categoryId != "null") {
        parameter += "&category=$categoryId";
      }

      if (productIds != null) {
        parameter += "&include=${productIds.join(",").toString()}";
      }

      if (sortBy != null) {
        parameter += "&orderby=$sortBy";
      }

      if (sortBy != null) {
        parameter += "&order=$sortOrder";
      }

      String url =
          '${Config.url}${Config.productsURL}?consumer_key=${Config
          .key}&consumer_secret=${Config.secret}$parameter';

      print(url);

      var response = await Dio().get(
        url,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        data = (response.data as List)
            .map((i) => Product.fromJson(i))
            .toList();

        // Değişken ürünler için ayrı bir istek
        for (var product in data) {
          if (product.type == "variable") {
            List<VariableProduct> variableProducts = await getVariableProducts(
                product.id!);
            if (variableProducts.isNotEmpty) {
              product.variableProduct = variableProducts.first;
              product.regularPrice = variableProducts.first.regularPrice;
              product.salePrice = variableProducts.first.salePrice;
            }
          }
        }
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return data;
  }

  Future<List<VariableProduct>> getVariableProducts(int productId) async {
    List<VariableProduct> responseModel = [];

    try {
      String url = Config.url +
          Config.productsURL +
          "/${productId.toString()}/${Config
              .variableProductsURL}?consumer_key=${Config
              .key}&consumer_secret=${Config.secret}";

      print(url);

      var response = await Dio().get(
        url,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        responseModel = (response.data as List)
            .map(
              (i) => VariableProduct.fromJson(i),
        )
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return responseModel;
  }

  Future<CartResponseModel?> addToCart(CartRequestModel model) async {
    LoginResponseModel? loginResponseModel = await SharedService.loginDetails();

    if (loginResponseModel!.data != null) {
      model.userId = loginResponseModel.data!.id;
    }
    CartResponseModel? responseModel;

    try {
      var response = await Dio().post(
        Config.url + Config.addtoCartURL,
        data: model.toJson(),
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        responseModel = CartResponseModel.fromJson(response.data);
      } else {
        /*print('Unexpected status code: ${response.statusCode}');
        print('Response data: ${response.data}');*/
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      } else {
        /*print('DioError message: ${e.message}');
        print('Request options: ${e.requestOptions}');
        print('Response data: ${e.response?.data}');*/
      }
    } catch (e) {
      print('General error: $e');
    }

    // Gelen veriyi ve hatayı konsolda görmek için
    //print('Final response model: $responseModel');

    return responseModel;
  }


  Future<CartResponseModel?> getCartItems() async {
    CartResponseModel? responseModel;

    try {
      LoginResponseModel? loginResponseModel = await SharedService.loginDetails();
      if (loginResponseModel?.data != null) {
        int? userId = loginResponseModel?.data!.id;
        String url = "${Config.url}${Config.cartURL}?user_id=${userId}&consumer_key=${Config.key}&consumer_secret=${Config.secret}";
        print("Request URL: $url");

        var response = await Dio().get(
          url,
          options: Options(
            headers: {
              Headers.contentTypeHeader: "application/json",
            },
          ),
        );

        if (response.statusCode == 200) {
          responseModel = CartResponseModel.fromJson(response.data);
        } else {
          print("Error: Received invalid status code ${response.statusCode}");
        }
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print("DioError Response Data: ${e.response?.data}");
        print("DioError Status Code: ${e.response?.statusCode}");
        print("DioError Headers: ${e.response?.headers}");
      } else {
        print("DioError: ${e.message}");
      }
    } catch (e) {
      print("Unexpected Error: $e");
    }

    return responseModel;
  }

  Future<bool> clearCartItems() async {
    bool ret = false;
    try {
      LoginResponseModel? loginResponseModel = await SharedService.loginDetails();

      if (loginResponseModel?.data != null) {
        int? userId = loginResponseModel?.data!.id;

        String url = Config.url +
            Config.clearCartURL +
            "?user_id=$userId&consumer_key=${Config.key}&consumer_secret=${Config.secret}";

        print(url);

        try {
          var response = await Dio().get(
            url,
            options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
              },
            ),
          );

          if (response.statusCode == 200) {
            ret = true;
          }
        } on DioError catch (e) {
          print(e.response);
        }
      }
    } catch (e) {
      print("An error occurred: $e");
    }

    return ret;
  }


  Future<List<Country>> getCountries() async {
    List<Country> data = [];

    try {
      String url = Config.url +
          Config.countriesURL +
          "?consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      print(url);

      var response = await Dio().get(
        url,
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        data = (response.data as List)
            .map(
              (i) => Country.fromJson(i),
        )
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return data;
  }


  Future<CustomerDetailsModel?> customerDetails() async {
    CustomerDetailsModel? responseModel;

    try {
      LoginResponseModel? loginResponseModel = await SharedService.loginDetails();

      if (loginResponseModel!.data != null) {
        int? userId = loginResponseModel.data!.id;

        String url = Config.url +
            Config.customersURL +
            "/${userId}?consumer_key=${Config
                .key}&consumer_secret=${Config
                .secret}";

        var response = await Dio().get(
          url,
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            },
          ),
        );

        if (response.statusCode == 200) {
          responseModel = CustomerDetailsModel.fromJson(response.data);
        }
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print(e.response?.statusCode);
      } else {
        print(e.message);
        print(e.requestOptions);
      }
    }

    return responseModel;
  }

  Future<bool> createOrder(OrderModel model) async {
    LoginResponseModel? loginResponseModel = await SharedService.loginDetails();

    if (loginResponseModel!.data != null) {
      model.customerId = loginResponseModel.data!.id;
    }

    bool isOrderCreated = false;
    var authToken = base64.encode(
      utf8.encode(Config.key + ":" + Config.secret),
    );
   // print('Creating order with model: ${model.toJson()}'); // Log model data
    try {
      var response = await Dio().post(
        Config.url + Config.ordersURL,
        data: model.toJson(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      print('Response status: ${response.statusCode}'); // Log response status

      if (response.statusCode == 201) {
        isOrderCreated = true;
      } else {
        print('Unexpected status code: ${response.statusCode}');
        print('Response data: ${response.data}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        // Print response status code and data
        print('DioError: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      } else {
        // Print request options and error message
        print('DioError: ${e.message}');
        print('Request options: ${e.requestOptions}');
      }
    } catch (e) {
      print('Unexpected error: $e');
    }

    return isOrderCreated;
  }


  Future<List<OrderModel>> getOrders() async {
    List<OrderModel> data = [];
    LoginResponseModel? loginResponseModel = await SharedService.loginDetails();

    try {
      if (loginResponseModel?.data != null) {
        int? userId = loginResponseModel!.data!.id;
        String url = Config.url +
            Config.ordersURL +
            "?consumer_key=${Config.key}&consumer_secret=${Config.secret}&customer=$userId";

        print(url);

        var response = await Dio().get(
          url,
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            },
          ),
        );

        if (response.statusCode == 200) {
          data = (response.data as List)
              .map(
                (i) => OrderModel.fromJson(i),
          )
              .toList();
        }
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return data;
  }


  Future<OrderDetailModel?> getOrderDetails(int orderId,) async {
    OrderDetailModel responseModel = OrderDetailModel();

    try {
      String url = Config.url +
          Config.ordersURL +
          "/$orderId?consumer_key=${Config.key}&consumer_secret=${Config
              .secret}";

      print(url);

      var response = await Dio().get(
        url,
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        responseModel = OrderDetailModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return responseModel;
  }

  Future<CustomerDetailsModel?> updateCustomerAddress(CustomerDetailsModel requestModel,) async {
    CustomerDetailsModel? responseModel;


    try {
      LoginResponseModel? loginResponseModel =
      await SharedService.loginDetails();

      if (loginResponseModel!.data != null) {
        requestModel.id = loginResponseModel.data!.id;

        requestModel.billing!.email = loginResponseModel.data!.email;

        var authToken = base64.encode(
          utf8.encode(Config.key + ":" + Config.secret),
        );

        String url = Config.url + Config.customersURL + "/${requestModel.id}";

        print(jsonEncode(requestModel.toJson()));
        var response = await Dio().post(
          url,
          data: requestModel.toJson(),
          options: new Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Basic $authToken',
              HttpHeaders.contentTypeHeader: "application/json",
            },
          ),
        );

        if (response.statusCode == 200) {
          responseModel = CustomerDetailsModel.fromJson(response.data);


        }
      }
    } on DioError catch (e) {
      // if (e.response.statusCode == 404) {
      //   print(e.response.statusCode);
      // } else {
      //   print(e.message);
      //   print(e.request);
      // }
    }
     return responseModel;
  }

  Future<String?> getShippingCost(int zoneId, int methodId) async {
    String url =
        "${Config.url}shipping/zones/$zoneId/methods/$methodId?consumer_key=${Config.key}&consumer_secret=${Config.secret}";

    print("Request URL: $url");

    try {
      var response = await Dio().get(
        url,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        // JSON'u ShippingMethod modeline dönüştür
        ShippingMethod shippingMethod = ShippingMethod.fromJson(response.data);

        // Sadece kargo ücretini döndür
        return shippingMethod.cost;
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } on DioError catch (e) {
      print("Dio Error: ${e.response?.data}");
      return null;
    } catch (e) {
      print("General Error: $e");
      return null;
    }
  }

}