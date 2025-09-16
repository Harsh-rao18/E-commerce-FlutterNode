import 'dart:convert';

import 'package:app_web/global_variable.dart';
import 'package:app_web/models/order_model.dart';
import 'package:http/http.dart' as http;


class OrderController{
   Future<List<OrderModel>> fetchOrder() async {
    try {
      // send an http get request to fetch orders
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders'),
        headers: <String, String>{
          //set the headers for the request
          "Content-Type":
              "application/json; charset=UTF-8", // specify the context type as json
        },
      );

      if (response.statusCode == 200) {
      // convert json into object
        List<dynamic> data = jsonDecode(response.body);

        List<OrderModel> orders =
            data.map((order) => OrderModel.fromJson(order)).toList();

        return orders;
      } else {
        // throw an exception if the server responded with error status code
        throw Exception('failed to load orders');
      }
    } catch (e) {
      throw Exception('Error loading orders');
    }
  }
}