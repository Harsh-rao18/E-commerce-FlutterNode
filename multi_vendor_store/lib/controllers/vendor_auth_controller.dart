import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multi_vendor_store/global_variables.dart';
import 'package:multi_vendor_store/models/vendor_model.dart';
import 'package:http/http.dart' as http;
import 'package:multi_vendor_store/services/manage_http_response.dart';
import 'package:multi_vendor_store/views/screens/main_vendor_screen.dart';

class VendorAuthController {
  Future<void> signUpVendor({
    required String fullName,
    required String email,
    required String password,
    required context,
  }) async {
    try {
      VendorModel vendorModel = VendorModel(
        id: "",
        fullName: fullName,
        email: email,
        city: "",
        state: "",
        locality: "",
        role: "",
        password: password,
      );

      http.Response response = await http.post(
        Uri.parse("$uri/api/vendor/signup"),
        body: vendorModel.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Vendor Account Created");
        },
      );
    } catch (e) {
      showSnackBar(context, '$e');
    }
  }

  Future<void> signInVendor({
    required context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response =  await http.post(Uri.parse("$uri/api/vendor/signin"),
      body: jsonEncode({
        "email":email,
        "password":password
      }),
      headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(response: response, context: context, onSuccess: (){
        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => MainVendorScreen()),(route)=> false);
        showSnackBar(context, "Vendor login successfully");
      });
    } catch (e) {
      showSnackBar(context, '$e');
    }
  }
}
