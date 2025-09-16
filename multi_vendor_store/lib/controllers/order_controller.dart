import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:multi_vendor_store/global_variables.dart';
import 'package:multi_vendor_store/models/order_model.dart';
import 'package:multi_vendor_store/services/manage_http_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderController {
  // Methods to GET orders by Vendor Id
  Future<List<OrderModel>> fetchOrders({required String vendorId}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      http.Response response = await http.get(
        Uri.parse("$uri/api/orders/vendors/$vendorId"),
        headers: <String, String>{
          //set the headers for the request
          "Content-Type":
              "application/json; charset=UTF-8", // specify the context type as json
           "x-auth-token":token!,
        },
      );

      if (response.statusCode == 200) {
        // Parse the Json response body to dynamic list
        // This convert the json data into a format that can be further processed in dart
        List<dynamic> data = jsonDecode(response.body);

        //Map the dynamic list to a list of orders object using the fromjson factory
        // This converts the raw data to a list of the orders instances(objects) which are easier to work with
        List<OrderModel> orders = data
            .map((order) => OrderModel.fromJson(order))
            .toList();
        return orders;
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
      http.Response response = await http.delete(
        Uri.parse("$uri/api/orders/$id"),
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
          showSnackBar(context, "Order Deleted Successfully");
        },
      );
    } catch (e) {
      showSnackBar(context, "error");
    }
  }

  Future<void> updateDeliveryStatus({
    required String id,
    required context,
  }) async {
    try {
       http.Response response = await http.patch(
        Uri.parse("$uri/api/orders/$id/delivered"),
        body: jsonEncode({
          "delivered":true,
          "processing":false,
        }),
        headers: <String, String>{
          //set the headers for the request
          "Content-Type":
              "application/json; charset=UTF-8", // specify the context type as json
        },
      );
      manageHttpResponse(response: response, context: context, onSuccess: (){
        showSnackBar(context, "Order updated");
      });
    } catch (e) {
       showSnackBar(context, "error");
    }
  }
  Future<void> cancelOrder({
    required String id,
    required context,
  }) async {
    try {
       http.Response response = await http.patch(
        Uri.parse("$uri/api/orders/$id/processing"),
        body: jsonEncode({
          "processing":false,
          "delivered":false,
        }),
        headers: <String, String>{
          //set the headers for the request
          "Content-Type":
              "application/json; charset=UTF-8", // specify the context type as json
        },
      );
      manageHttpResponse(response: response, context: context, onSuccess: (){
        showSnackBar(context, "Order updated");
      });
    } catch (e) {
       showSnackBar(context, "error");
    }
  }
}
