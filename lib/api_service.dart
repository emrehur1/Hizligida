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

class APIService {
  Future<bool> isEmailRegistered(String email) async {
    var authToken = base64.encode(utf8.encode('${Config.key}:${Config.secret}'));

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
    var authToken = base64.encode(utf8.encode('${Config.key}:${Config.secret}'));

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
  Future<LoginResponseModel?> loginCustomer(
      String username,
      String password,
      ) async {
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
          Config.categoriesURL+
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

     // if (categoryId != null && categoryId != "null") {
      //  parameter += "&category=$categoryId";
      //}

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
          '${Config.url}${Config.productsURL}?consumer_key=${Config.key}&consumer_secret=${Config.secret}$parameter';

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
              (i) => Product.fromJson(i),
        )
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return data;
  }


  Future<CartResponseModel?> addToCart(CartRequestModel model) async {
    model.userId = int.parse(Config.userId);
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
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        print(e.response?.statusCode);
      } else {
        print(e.message);
        print(e.requestOptions);
      }
    }

    return responseModel;
  }

  Future<CartResponseModel?> getCartItems() async {
    CartResponseModel? responseModel;

    try {
      String url = "${Config.url}${Config.cartURL}?user_id=${Config.userId}&consumer_key=${Config.key}&consumer_secret=${Config.secret}";
      print(url);

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
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return responseModel;
  }



}