import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:multi_store_app/global_variable.dart';
import 'package:multi_store_app/models/category.dart';

class CategoryController {
// fetch the category
Future<List<Category>> fetchCategories() async {
  try {
    http.Response response = await http.get(
      Uri.parse('$uri/api/category'),
      headers: <String, String>{
        //set the headers for the request
        "Content-Type":
            "application/json; charset=UTF-8", // specify the context type as json
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      List<Category> categories =
          data.map((category) => Category.fromJson(category)).toList();

      return categories;
    } else {
      throw Exception("Failed o get categories");
    }
  } catch (e) {
    throw Exception("falied to get categories");
  }
}
}

