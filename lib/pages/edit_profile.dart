import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hizligida/models/customer_detail_model.dart';
import 'package:hizligida/pages/base_page.dart';
import 'package:hizligida/utils/form_helper.dart';
import '../api_service.dart';
import 'home_page.dart';

class EditNamePage extends BasePage {
  @override
  _EditNamePageState createState() => _EditNamePageState();
}

class _EditNamePageState extends BasePageState<EditNamePage> {
  CustomerDetailsModel? model;
  APIService? apiService;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
    apiService = APIService();
    model = CustomerDetailsModel(billing: Billing(), shipping: Shipping());
  }

  @override
  Widget pageUI() {
    return FutureBuilder<CustomerDetailsModel?>(
      future: apiService!.customerDetails(),
      builder: (BuildContext context,
          AsyncSnapshot<CustomerDetailsModel?> snapshot) {
        if (snapshot.hasData) {
          model = snapshot.data!;
          return Form(
            key: globalFormKey,
            child: _formUI(),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormHelper.fieldLabel("First Name"),
                          TextFormField(
                            initialValue: model!.firstName ?? "",
                            onChanged: (value) => model!.firstName = value,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter First Name.';
                              }
                              return null;
                            },
                            style: TextStyle(
                              fontFamily: 'Roboto',
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 20.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FormHelper.fieldLabel("Last Name"),
                            TextFormField(
                              initialValue: model!.lastName ?? "",
                              onChanged: (value) => model!.lastName = value,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter Last Name.';
                                }
                                return null;

                              },
                              style: TextStyle(
                                fontFamily: 'Roboto',
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 20.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                FormHelper.fieldLabel("E mail"),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: TextFormField(
                          initialValue: model?.email ?? '',
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 20.0),
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: FormHelper.saveButton(
                    "Update",
                        () {
                      if (validateAndSave()) {
                        setState(() {
                          isApiCallProcess = true;
                        });

                        apiService!.updateCustomerAddress(model!).then((ret) {
                          setState(() {
                            isApiCallProcess = false;
                          });

                          if (ret != null) {
                            print(ret.toJson());

                            FormHelper.showMessage(
                              context,
                              "Başarılı",
                              "Name Updated Successfully!!",
                              "Ok",
                                  () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                      (Route<dynamic> route) => false,
                                );
                              },
                            );
                          } else {
                            FormHelper.showMessage(
                              context,
                              "Hata",
                              "Name Could Not Be Updated. Please Try Again.",
                              "Ok",
                                  () {
                                Navigator.of(context).pop();
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
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
