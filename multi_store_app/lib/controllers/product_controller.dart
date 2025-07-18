import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:multi_store_app/global_variable.dart';
import 'package:multi_store_app/models/product_model.dart';

class ProductController {
  // Define a function that returns a future containing list of product mpdel objetcs
  Future<List<ProductModel>> fetchPopularProducts() async {
    // use a try block to handle any exception sthat might occur in http request
    try {
      http.Response response =  await http.post(
        Uri.parse("$uri/api/popular-products"),
        // set the http headers for trh request , specifying that the content type is json with the UTF-8 encoding
        headers: <String,String>{
          "Content-Type":"application/json; charset=UTF-8",
        }
      );
      
      // check if the HTTP Response status code is 200 , which means the request is successfull
      if (response.statusCode == 200) {
        // Decode the json response body into a list of dynamic objects
        final List<dynamic> data =  json.decode(response.body) as List<dynamic>;

        // map each items in the list to product model objects which we can use

       List<ProductModel> products =  data.map((product)=> ProductModel.fromMap(product as Map<String,dynamic>)).toList();

      return products;
      } else {
        throw Exception("Failed to get products");
      }
    } catch (e) {
      throw Exception("Failed to get products");
    }
  }
}