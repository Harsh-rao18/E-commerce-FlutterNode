import 'dart:convert';

import 'package:multi_store_app/global_variable.dart';
import 'package:multi_store_app/models/order_model.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store_app/services/manage_http_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderController {
  // function to upload orders
  uploadOrders({
    required context,
    required String id,
    required String productId,
    required String fullName,
    required String email,
    required String state,
    required String city,
    required String locality,
    required String productName,
    required int productPrice,
    required int quantity,
    required String category,
    required String image,
    required String buyerId,
    required String vendorId,
    required bool processing,
    required bool delivered,
  }) async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      String? token = preference.getString('auth_token');

      final OrderModel order = OrderModel(
        id: id,
        productId: productId,
        fullName: fullName,
        email: email,
        state: state,
        city: city,
        locality: locality,
        productName: productName,
        productPrice: productPrice,
        quantity: quantity,
        category: category,
        image: image,
        buyerId: buyerId,
        vendorId: vendorId,
        processing: processing,
        delivered: delivered,
      );

      http.Response response = await http.post(
        Uri.parse("$uri/api/orders"),
        body: order.toJson(),
        headers: <String, String>{
          //set the headers for the request
          "Content-Type":
              "application/json; charset=UTF-8", // specify the context type as json
          'x-auth-token': token!,
        },
      );

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "You have placed an order");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Methods to GET orders by Buyer Id
  Future<List<OrderModel>> fetchOrders({required String buyerId}) async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      String? token = preference.getString('auth_token');

      http.Response response = await http.get(
        Uri.parse("$uri/api/orders/$buyerId"),
        headers: <String, String>{
          //set the headers for the request
          "Content-Type":
              "application/json; charset=UTF-8", // specify the context type as json
          'x-auth-token': token!,
        },
      );

      if (response.statusCode == 200) {
        // Parse the Json response body to dynamic list
        // This convert the json data into a format that can be further processed in dart
        List<dynamic> data = jsonDecode(response.body);

        //Map the dynamic list to a list of orders object using the fromjson factory
        // This converts the raw data to a list of the orders instances(objects) which are easier to work with
        List<OrderModel> orders =
            data.map((order) => OrderModel.fromJson(order)).toList();
        return orders;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        // throw an exception
        throw Exception("Failed to load Orders");
      }
    } catch (e) {
      throw Exception("Error loading Orders");
    }
  }

  // Method to delete order by Id
  Future<void> deleteOrder({required String id, required context}) async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      String? token = preference.getString('auth_token');

      http.Response response = await http.delete(
        Uri.parse("$uri/api/orders/$id"),
        headers: <String, String>{
          //set the headers for the request
          "Content-Type":
              "application/json; charset=UTF-8", // specify the context type as json
          'x-auth-token': token!,
        },
      );

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Order Deleted Successfully");
          });
    } catch (e) {
      showSnackBar(context, "error");
    }
  }

  // Method to count delivered orders
  Future<int> getDeliveredOrderedCount({required String buyerId}) async {
    try {
      // load all orders
      List<OrderModel> orders = await fetchOrders(buyerId: buyerId);

      // Filter only delivered orders
      int count = orders.where((order) => order.delivered).length;

      return count;
    } catch (e) {
      throw Exception("Error counting delivered Orders");
    }
  }
}
