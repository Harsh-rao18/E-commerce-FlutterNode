import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:multi_store_app/global_variable.dart';
import 'package:multi_store_app/models/product_model.dart';

class ProductController {
  // Define a function that returns a future containing list of product model objetcs
  Future<List<ProductModel>> fetchPopularProducts() async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/popular-products"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Your backend returns: { product: [...] }
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsData = data['product'];

        List<ProductModel> products = productsData
            .map(
              (product) =>
                  ProductModel.fromMap(product as Map<String, dynamic>),
            )
            .toList();

        return products;
      } else {
        throw Exception("Failed to get products: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
      throw Exception("Failed to get products: $e");
    }
  }

  Future<List<ProductModel>> fetchProductByCategory(String category) async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/products-by-category/$category"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      if (response.statusCode == 200) {
        // Your backend returns: { product: [...] }
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsData = data['product'];

        List<ProductModel> products = productsData
            .map(
              (product) =>
                  ProductModel.fromMap(product as Map<String, dynamic>),
            )
            .toList();

        return products;
      } else {
        throw Exception("Failed to get products: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to get products");
    }
  }

// Method to display the related products by subcategory
  Future<List<ProductModel>> fetchRelatedProducts(String productId) async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/related-products-by-subcategory/$productId"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsData = data['product'];

        List<ProductModel> products = productsData
            .map((product) =>
                ProductModel.fromMap(product as Map<String, dynamic>))
            .toList();

        return products;
      } else {
        throw Exception("Failed to get products: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to get products");
    }
  }

  // method to get top rated products
  Future<List<ProductModel>> fetchTopRatedProducts() async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/top-rated-products"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsData = data['product'];

        List<ProductModel> products = productsData
            .map((product) =>
                ProductModel.fromMap(product as Map<String, dynamic>))
            .toList();

        return products;
      } else {
        throw Exception("Failed to get products: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to get products");
    }
  }

  
}
