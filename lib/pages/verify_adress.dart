import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hizligida/models/customer_detail_model.dart';
import 'package:hizligida/pages/checkout_base.dart';
import 'package:hizligida/pages/payment_methods.dart';
import 'package:hizligida/provider/cart_provider.dart';
import 'package:hizligida/utils/form_helper.dart';
import '../api_service.dart';
import '../utils/City.dart'; // City.dart dosyası import edildi

class VerifyAddress extends CheckoutBasePage {
  @override
  _VerifyAddressState createState() => _VerifyAddressState();
}

class _VerifyAddressState extends CheckoutBasePageState<VerifyAddress> {
  APIService? apiService;

  // Shipping Controllers
  TextEditingController? firstNameController;
  TextEditingController? lastNameController;
  TextEditingController? address1Controller;
  TextEditingController? address2Controller;
  TextEditingController? cityController;
  TextEditingController? postcodeController;
  TextEditingController? phoneController;

  // Billing Controllers
  TextEditingController? billingFirstNameController;
  TextEditingController? billingLastNameController;
  TextEditingController? billingAddress1Controller;
  TextEditingController? billingAddress2Controller;
  TextEditingController? billingCityController;
  TextEditingController? billingPostcodeController;
  TextEditingController? billingPhoneController;

  bool isShippingEditMode = false;
  bool isBillingEditMode = false;
  bool isBillingSameAsShipping = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    this.currentPage = 0;
    apiService = APIService();
    var productsList = Provider.of<CartProvider>(context, listen: false);
    productsList.fetchShippingDetails();
  }

  @override
  Widget pageUI() {
    return Consumer<CartProvider>(
      builder: (context, customerDetailsModel, child) {
        if (customerDetailsModel.customerDetailsModel!.id != null) {
          return _formUI(customerDetailsModel.customerDetailsModel!);
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _formUI(CustomerDetailsModel model) {
    // Shipping Controllers
    firstNameController = TextEditingController(text: model.shipping?.firstName ?? "");
    lastNameController = TextEditingController(text: model.shipping?.lastName ?? "");
    address1Controller = TextEditingController(text: model.shipping?.address1 ?? "");
    address2Controller = TextEditingController(text: model.shipping?.address2 ?? "");
    cityController = TextEditingController(text: model.shipping?.city ?? "");
    postcodeController = TextEditingController(text: model.shipping?.postcode ?? "");
    phoneController = TextEditingController(text: model.shipping?.phone ?? "");

    // Billing Controllers
    billingFirstNameController = TextEditingController(text: model.billing?.firstName ?? "");
    billingLastNameController = TextEditingController(text: model.billing?.lastName ?? "");
    billingAddress1Controller = TextEditingController(text: model.billing?.address1 ?? "");
    billingAddress2Controller = TextEditingController(text: model.billing?.address2 ?? "");
    billingCityController = TextEditingController(text: model.billing?.city ?? "");
    billingPostcodeController = TextEditingController(text: model.billing?.postcode ?? "");
    billingPhoneController = TextEditingController(text: model.billing?.phone ?? "");

    InputDecoration _inputDecoration(String labelText) {
      return InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      );
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isShippingEditMode)
                _addressBox(
                  title: "Teslimat Adresi",
                  details: _addressDetails(model.shipping),
                  onEdit: () {
                    setState(() {
                      isShippingEditMode = true;
                    });
                  },
                ),
              if (isShippingEditMode) _shippingForm(model, _inputDecoration),

              SizedBox(height: 30),

              CheckboxListTile(
                title: Text("Faturam farklı bir adrese gönderilsin."),
                value: !isBillingSameAsShipping,
                onChanged: (bool? value) {
                  setState(() {
                    isBillingSameAsShipping = !(value ?? false);
                    if (isBillingSameAsShipping) {
                      _copyShippingToBilling(model); // Fatura adresini teslimat adresiyle eşitle
                      isBillingEditMode = false; // Fatura adresini düzenlemeyi kapat
                    } else {
                      isBillingEditMode = true; // Fatura adresini düzenlemeye aç
                    }
                  });
                },
              ),


              if (!isBillingSameAsShipping && isBillingEditMode)
                _billingForm(model, _inputDecoration),

              SizedBox(height: 30),
              Center(
                child: FormHelper.saveButton(
                  "Devam",
                      () {
                        if (_formKey.currentState!.validate()) {
                          var updatedModel = model;

                          // Teslimat adresini güncelle
                          updatedModel.shipping?.firstName = firstNameController?.text;
                          updatedModel.shipping?.lastName = lastNameController?.text;
                          updatedModel.shipping?.address1 = address1Controller?.text;
                          updatedModel.shipping?.address2 = address2Controller?.text;
                          updatedModel.shipping?.city = cityController?.text;
                          updatedModel.shipping?.postcode = postcodeController?.text;
                          updatedModel.shipping?.phone = phoneController?.text;

                          // Fatura adresini güncelle veya son siparişin teslimat adresiyle aynı yap
                          if (!isBillingSameAsShipping) {
                            updatedModel.billing?.firstName = billingFirstNameController?.text;
                            updatedModel.billing?.lastName = billingLastNameController?.text;
                            updatedModel.billing?.address1 = billingAddress1Controller?.text;
                            updatedModel.billing?.address2 = billingAddress2Controller?.text;
                            updatedModel.billing?.city = billingCityController?.text;
                            updatedModel.billing?.postcode = billingPostcodeController?.text;
                            updatedModel.billing?.phone = billingPhoneController?.text;
                          } else {
                            if (updatedModel.billing?.firstName == null || updatedModel.billing!.firstName!.isEmpty) {
                              // Eğer fatura adresi hiç güncellenmemişse, son siparişin teslimat adresini kullan
                              _copyShippingToBilling(updatedModel);
                            }

                          }

                          // API çağrısını gerçekleştir
                          apiService!.updateCustomerAddress(updatedModel).then((response) {
                            if (response != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentMethodsWidget(),
                                ),
                              );
                            } else {
                              // Hata durumunda kullanıcıya bir mesaj göster
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Hata"),
                                    content: Text("Adres güncellenirken bir sorun oluştu."),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("Tamam"),
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
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

  Widget _addressBox({required String title, required String? details, required VoidCallback onEdit}) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(details ?? "", style: TextStyle(fontFamily: "Poppins")),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onEdit,
              child: Text("Düzenle", style: TextStyle(fontFamily: "Poppins")),
            ),
          ),
        ],
      ),
    );
  }

  String? _addressDetails(dynamic address) {
    if (address == null) return "";

    String? stateCode = address?.state;
    String? stateName;

    if (stateCode != null) {
      stateName = CityStateMapping.cityToStateCode.entries
          .firstWhere((entry) => entry.value == stateCode, orElse: () => MapEntry("", ""))
          .key;
    }

    return [
      if (address?.firstName != null && address?.lastName != null)
        "${address.firstName} ${address.lastName}",
      if (address?.address1 != null) address.address1!,
      if (address?.address2 != null) address.address2!,
      if (address?.city != null && address?.postcode != null)
        "${address.city}, ${address.postcode}",
      if (stateName != null && stateName.isNotEmpty) stateName,
      "Türkiye", // Ülke sabit olarak "Türkiye" ayarlandı
      if (address?.phone != null) address.phone!,
    ].where((line) => line.isNotEmpty).join("\n");
  }

  Widget _shippingForm(CustomerDetailsModel model, InputDecoration Function(String) inputDecoration) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Teslimat Adresi", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins")),
        SizedBox(height: 10),
        _formFields(
          model.shipping,
          firstNameController!,
          lastNameController!,
          address1Controller!,
          address2Controller!,
          cityController!,
          postcodeController!,
          phoneController!,
          inputDecoration,
          isBilling: false,
        ),
      ],
    );
  }

  Widget _billingForm(CustomerDetailsModel model, InputDecoration Function(String) inputDecoration) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Fatura Adresi", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins")),
        SizedBox(height: 10),
        _formFields(
          model.billing,
          billingFirstNameController!,
          billingLastNameController!,
          billingAddress1Controller!,
          billingAddress2Controller!,
          billingCityController!,
          billingPostcodeController!,
          billingPhoneController!,
          inputDecoration,
          isBilling: true,
        ),
      ],
    );
  }

  Widget _formFields(
      dynamic address,
      TextEditingController firstNameController,
      TextEditingController lastNameController,
      TextEditingController address1Controller,
      TextEditingController address2Controller,
      TextEditingController cityController,
      TextEditingController postcodeController,
      TextEditingController phoneController,
      InputDecoration Function(String) inputDecoration, {
        required bool isBilling,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: firstNameController,
                decoration: inputDecoration("İsim"),
                onChanged: (value) {
                  address?.firstName = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bu alanı doldurmak zorunludur';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: lastNameController,
                decoration: inputDecoration("Soyisim"),
                onChanged: (value) {
                  address?.lastName = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bu alanı doldurmak zorunludur';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: address1Controller,
          decoration: inputDecoration("Adres"),
          onChanged: (value) {
            address?.address1 = value;
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Bu alanı doldurmak zorunludur';
            }
            return null;
          },
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: address2Controller,
          decoration: inputDecoration("Apartman/Daire"),
          onChanged: (value) {
            address?.address2 = value;
          },
        ),
        SizedBox(height: 20),
        DropdownButtonFormField<String>(
          hint: Text("Şehir Seçin"),
          value: CityStateMapping.cityToStateCode.containsValue(address?.state) ? address?.state : null,
          onChanged: (String? newState) {
            setState(() {
              address?.state = newState;
            });
          },
          items: CityStateMapping.cityToStateCode.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.value,
              child: Text(entry.key),
            );
          }).toList(),
          isDense: true,
          decoration: inputDecoration("Şehir"),
          validator: (value) {
            if (value == null) {
              return 'Bu alanı doldurmak zorunludur';
            }
            return null;
          },
        ),

        SizedBox(height: 20),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: TextFormField(
                controller: cityController,
                decoration: inputDecoration("İlçe"),
                onChanged: (value) {
                  address?.city = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bu alanı doldurmak zorunludur';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              flex: 1,
              child: TextFormField(
                controller: postcodeController,
                decoration: inputDecoration("Posta Kodu"),
                onChanged: (value) {
                  address?.postcode = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bu alanı doldurmak zorunludur';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: phoneController,
          decoration: inputDecoration("Telefon Numarası"),
          onChanged: (value) {
            address?.phone = value;
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Bu alanı doldurmak zorunludur';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _copyShippingToBilling(CustomerDetailsModel model) {
    model.billing?.firstName = model.shipping?.firstName;
    model.billing?.lastName = model.shipping?.lastName;
    model.billing?.address1 = model.shipping?.address1;
    model.billing?.address2 = model.shipping?.address2;
    model.billing?.city = model.shipping?.city;
    model.billing?.postcode = model.shipping?.postcode;
    model.billing?.phone = model.shipping?.phone;
    model.billing?.country = "TR";
    model.billing?.state = model.shipping?.state;

    billingFirstNameController?.text = model.shipping?.firstName ?? "";
    billingLastNameController?.text = model.shipping?.lastName ?? "";
    billingAddress1Controller?.text = model.shipping?.address1 ?? "";
    billingAddress2Controller?.text = model.shipping?.address2 ?? "";
    billingCityController?.text = model.shipping?.city ?? "";
    billingPostcodeController?.text = model.shipping?.postcode ?? "";
    billingPhoneController?.text = model.shipping?.phone ?? "";
  }
}
