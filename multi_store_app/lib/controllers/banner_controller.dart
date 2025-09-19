import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:multi_store_app/global_variable.dart';
import 'package:multi_store_app/models/banner.dart';

class BannerController {
  //fetch banners
  Future<List<BannerModel>> fetchBanner() async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/banner'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<BannerModel> banners =
            data.map((banner) => BannerModel.fromJson(banner)).toList();

        return banners;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load banners: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading banners: $e');
    }
  }
}
