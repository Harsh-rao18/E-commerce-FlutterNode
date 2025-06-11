import 'dart:convert';

import 'package:app_web/global_variable.dart';
import 'package:app_web/models/category.dart';
import 'package:app_web/services/manage_http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  uploadCategory({
    required context,
    required String name,
    required dynamic pickedImage,
    required dynamic pickedBanner,
  }) async {
    try {
      // Using cloudinary to store the images and banners
      final cloudinary = CloudinaryPublic("dhocbxkhv", 'vgcavzfe');
      // upload the image
      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage,
            identifier: 'pickedImage', folder: 'categoryImages'),
      );
      // upload the banner
      CloudinaryResponse bannerResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedBanner,
            identifier: 'pickedBanner', folder: 'categoryImages'),
      );

      // getting the url so that we can store in DB
      String image = imageResponse.secureUrl;
      String banner = bannerResponse.secureUrl;

      Category category = Category(
        id: '',
        name: name,
        image: image,
        banner: banner,
      );
      http.Response response = await http.post(
        Uri.parse('$uri/api/category'),
        body: category.toJson(),
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
          showSnackBar(context, "Upload Category");
        },
      );
    } catch (e) {
      print(e);
    }
  }
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

