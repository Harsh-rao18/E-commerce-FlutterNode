import 'dart:convert';

import 'package:app_web/global_variable.dart';
import 'package:app_web/models/banner.dart';
import 'package:app_web/services/manage_http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;

class BannerController {
  uploadBanner({required context, required dynamic pickedImage}) async {
    try {
      final cloudinary = CloudinaryPublic("dhocbxkhv", 'vgcavzfe');
      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedImage,
          identifier: 'pickedImage',
          folder: 'banners',
        ),
      );
      String image = imageResponse.secureUrl;

      BannerModel bannerModel = BannerModel(id: '', image: image);

      http.Response response = await http.post(
        Uri.parse('$uri/api/banner'),
        body: bannerModel.toJson(),
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
            showSnackBar(context, "Upload banner");
          });
    } catch (e) {
      print(e);
    }
  }

  //fetch banners
  Future<List<BannerModel>> fetchBanner() async {
    try {
      // send an http get request to fetch banner
      http.Response response = await http.get(
        Uri.parse('$uri/api/banner'),
        headers: <String, String>{
          //set the headers for the request
          "Content-Type":
              "application/json; charset=UTF-8", // specify the context type as json
        },
      );

      if (response.statusCode == 200) {
      // convert json into object
        List<dynamic> data = jsonDecode(response.body);

        List<BannerModel> banners =
            data.map((banner) => BannerModel.fromJson(banner)).toList();

        return banners;
      } else {
        // throw an exception if the server responded with error status code
        throw Exception('falied to load banners');
      }
    } catch (e) {
      throw Exception('Error loading banners');
    }
  }
}
