import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_vendor_store/global_variables.dart';
import 'package:multi_vendor_store/models/vendor_model.dart';
import 'package:http/http.dart' as http;
import 'package:multi_vendor_store/provider/vendor_provider.dart';
import 'package:multi_vendor_store/services/manage_http_response.dart';
import 'package:multi_vendor_store/views/screens/main_vendor_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final providerContainer = ProviderContainer();

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
        token: "",
      );

      http.Response response = await http.post(
        Uri.parse("$uri/api/v2/vendor/signup"),
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
    required WidgetRef ref,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/v2/vendor/signin"),
        body: jsonEncode({"email": email, "password": password}),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () async {
            // Access sharedPreferences for token and user data Storage
            SharedPreferences preferences =
                await SharedPreferences.getInstance();

            // Extract the unique auth token from the response body
            String token = jsonDecode(response.body)['token'];

            // Store the auth token securely in shared preference
            await preferences.setString('auth_token', token);

            // Extract user data from response
            final userMap = jsonDecode(response.body);

            // Encode user data
            final userJson = jsonEncode(userMap);

            // Update Riverpod state
            ref.read(vendorProvider.notifier).setVendor(response.body);

            // Store in SharedPreferences
            await preferences.setString("user", userJson);

            if (ref.read(vendorProvider)!.token.isNotEmpty) {
              // Navigate to main screen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainVendorScreen()),
                (_) => false,
              );
            showSnackBar(context, "Logged In");
            }

          });

    } catch (e) {
      showSnackBar(context, 'Error: $e');
    }
  }

  getUserData(context, WidgetRef ref) async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      String? token = preference.getString('auth_token');
      if (token == null) {
        showSnackBar(context, "You Need to login toperform this action");
        return;
      }
      http.Response tokenResponse = await http.post(
        Uri.parse('$uri/vendor/tokenisvalid'),
        headers: <String, String>{
          //set the headers for the request
          "Content-Type":
              "application/json; charset=UTF-8", // specify the context type as json
          'x-auth-token': token,
        },
      );

      var response = jsonDecode(tokenResponse.body);
      if (response == true) {
        http.Response userResponse = await http.get(
          Uri.parse('$uri/get-vendor'),
          headers: <String, String>{
            //set the headers for the request
            "Content-Type":
                "application/json; charset=UTF-8", // specify the context type as json
            'x-auth-token': token,
          },
        );
        ref.read(vendorProvider.notifier).setVendor(userResponse.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
