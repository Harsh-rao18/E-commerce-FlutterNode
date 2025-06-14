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

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print('Decoded Data: $data');

      List<BannerModel> banners =
          data.map((banner) => BannerModel.fromJson(banner)).toList();

      return banners;
    } else {
      throw Exception('Failed to load banners: ${response.statusCode}');
    }
  } catch (e) {
    print('Error loading banners: $e');
    throw Exception('Error loading banners: $e');
  }
}

}
