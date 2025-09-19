import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app/global_variable.dart';
import 'package:multi_store_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store_app/provider/deliver_order_count_provider.dart';
import 'package:multi_store_app/provider/user_provider.dart';
import 'package:multi_store_app/provider/wishlist_provider.dart';
import 'package:multi_store_app/services/manage_http_response.dart';
import 'package:multi_store_app/views/screens/auth_screens/login_screen.dart';
import 'package:multi_store_app/views/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    required WidgetRef ref,
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
            SharedPreferences preferences =
                await SharedPreferences.getInstance();

            // Extract the unique auth token from the response body
            String token = jsonDecode(response.body)['token'];

            // Store the auth token securely in shared preference
            await preferences.setString('auth_token', token);

            // Extract user data from response
            final userMap = jsonDecode(response.body)['user'];

            // Encode user data
            final userJson = jsonEncode(userMap);

            // Update Riverpod state
            ref.read(userProvider.notifier).setUser(userJson);

            // Store in SharedPreferences
            await preferences.setString("user", userJson);

            // ✅ Use user ID from response directly
            final userId = userMap['_id']; // or 'id' depending on backend field
            await ref.read(wishlistProvider.notifier).loadFavourite(userId);

            // Navigate to main screen
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
              (_) => false,
            );

            showSnackBar(context, "Logged In");
          });
    } catch (e) {
      print(e);
    }
  }

  // SignOut
  Future<void> signOutUser({
    required context,
    required WidgetRef ref,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // clear the token and user from sharedprefernces
      await preferences.remove('auth_token');
      await preferences.remove('user');

      // clear the user state
      ref.read(userProvider.notifier).signOut();
      ref.read(deliverOrderCountProvider.notifier).resetCount();
      ref.read(wishlistProvider.notifier).clearWishList();

      // navigate the user back to login-screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
      showSnackBar(context, "signOut succesfully");
    } catch (e) {
      showSnackBar(context, " error signOut");
    }
  }

  // Update user city , locality and state
  Future<void> updateUser({
    required context,
    required String id,
    required String state,
    required String city,
    required String locality,
    required WidgetRef ref,
  }) async {
    try {
      // make a http put request
      final http.Response response = await http.put(
        Uri.parse("$uri/api/users/$id"),
        //Encode the update data as Json Object
        body: jsonEncode({
          "state": state,
          "city": city,
          "locality": locality,
        }),
        headers: <String, String>{
          //set the headers for the request
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () async {
            // Decode the updated user data from the response body
            // this converts the json string response into dart map
            final updatedUser = jsonDecode(response.body);

            // Access sharedPreference for local data storage
            SharedPreferences preferences =
                await SharedPreferences.getInstance();

            // Encode the update the user data as json String
            // purpose : this prepares the data for storage in shared prefernces

            final userJson = jsonEncode(updatedUser);

            // update the application state with the updated user data using Riverpod
            // this ensures the app refelcts the most recent data
            ref.read(userProvider.notifier).setUser(userJson);

            // store the updated user data in sharedpreference for future use
            // this allows the app to retrive the user data even after the app restarts
            await preferences.setString('user', userJson);
          });
    } catch (e) {
      showSnackBar(context, "error updating location");
    }
  }
}
