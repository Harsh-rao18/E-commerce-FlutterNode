import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app/global_variable.dart';
import 'package:multi_store_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store_app/provider/user_provider.dart';
import 'package:multi_store_app/services/manage_http_response.dart';
import 'package:multi_store_app/views/screens/auth_screens/login_screen.dart';
import 'package:multi_store_app/views/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final providerContainer = ProviderContainer();

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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
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
        onSuccess: () async {
          // Access sharedPreferences for token and user data Storage
          SharedPreferences preferences = await SharedPreferences.getInstance();

          // Extract the unique auth token from the response body
          String token = jsonDecode(response.body)['token'];

          // Store the auth token Securly in shared prefernce
          await preferences.setString('auth_token', token);

          // Encode the user data receive from backend as json
          final userJson = jsonEncode(jsonDecode(response.body)['user']);

          // Update the apllication state with the user data using riverpod
          providerContainer.read(userProvider.notifier).setUser(userJson);

          // Store the data in sharedPreferences for future use

          await preferences.setString("user", userJson);

          // Navigate to main Screen
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

  // SignOut
  Future<void> signOutUser({required context}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // clear the token and user from sharedprefernces
      await preferences.remove('auth_token');
      await preferences.remove('user');

      // clear the user state
      providerContainer.read(userProvider.notifier).signOut();

      // navigate the user back to login-screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
      showSnackBar(context, "signOut succesfully");
    } catch (e) {
      showSnackBar(context, " error signOut");
    }
  }
}
