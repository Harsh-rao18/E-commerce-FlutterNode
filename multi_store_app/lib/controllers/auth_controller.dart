import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multi_store_app/global_variable.dart';
import 'package:multi_store_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store_app/services/manage_http_response.dart';
import 'package:multi_store_app/views/screens/auth_screens/login_screen.dart';
import 'package:multi_store_app/views/screens/main_screen.dart';

class AuthController {
  // SignUp User
  Future<void> signUpUsers({
    required context,
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        fullName: fullName,
        email: email,
        state: '',
        city: '',
        locality: '',
        password: password,
        token: '',
      );
      http.Response response = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(), // convert User object to json for the request body
        headers: <String, String>{
          //set the headers for the request
          "Content-Type":
              "application/json; charset=UTF-8", // specify the context type as json
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
          showSnackBar(context, "Account has been created for you");
        },
      );
    } catch (e) {
      print(e);
    }
  }

  // SignIn User
  Future<void> signInUsers({
    required context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode(
          {
            // include email and password in request body
            'email': email,
            "password": password,
          },
        ),
        headers: <String, String>{
          //set the headers for the request
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (_) => false,
          );
          showSnackBar(context, "Logged In");
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
