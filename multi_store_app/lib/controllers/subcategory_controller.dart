import 'dart:convert';

import 'package:multi_store_app/global_variable.dart';
import 'package:multi_store_app/models/subcategory_model.dart';
import 'package:http/http.dart' as http;

class SubcategoryController {
  Future<List<Subcategory>> getSubcatgoryByCategoryName(
      String categoryName) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/category/$categoryName/subcategories'),
        headers: <String, String>{
          //set the headers for the request
          "Content-Type":
              "application/json; charset=UTF-8", // specify the context type as json
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return data
              .map((subcategory) => Subcategory.fromJson(subcategory))
              .toList();
        } else {
          print("subcategories not found");
          return [];
        }
      } else if (response.statusCode == 404) {
        print("subcategories not found");
        return [];
      } else {
        print("failed to fetch subcategories");
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
