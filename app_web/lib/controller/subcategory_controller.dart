import 'dart:convert';

import 'package:app_web/global_variable.dart';
import 'package:app_web/models/subcategory.dart';
import 'package:app_web/services/manage_http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;

class SubcategoryController {
  uploadSubcategory({
    required context,
    required String categoryId,
    required String categoryName,
    required String subcategoryName,
    required dynamic pickedImage,
  }) async {
    try {
      // Using cloudinary to store the images and banners
      final cloudinary = CloudinaryPublic("dhocbxkhv", 'vgcavzfe');
      // upload the image
      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage,
            identifier: 'pickedImage', folder: 'SubcategoryImages'),
      );

      // getting the url so that we can store in DB
      String image = imageResponse.secureUrl;

      Subcategory subcategory = Subcategory(
        id: '',
        categoryId: categoryId,
        categoryName: categoryName,
        image: image,
        subCategoryName: subcategoryName,
      );

      http.Response response = await http.post(
        Uri.parse(
          '$uri/api/subcategories',
        ),
        body: subcategory.toJson(),
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
            showSnackBar(context, "Upload SubCategory");
          });
    } catch (e) {
      throw Exception("something went wrong");
    }
  }

  Future<List<Subcategory>> fetchSubCategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/subcategories'),
        headers: <String, String>{
          //set the headers for the request
          "Content-Type":
              "application/json; charset=UTF-8", // specify the context type as json
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        List<Subcategory> subcategories =
            data.map((subcategory) => Subcategory.fromJson(subcategory)).toList();

        return subcategories;
      } else {
        throw Exception("Failed o get categories");
      }
    } catch (e) {
      throw Exception("falied to get categories");
    }
  }
}
