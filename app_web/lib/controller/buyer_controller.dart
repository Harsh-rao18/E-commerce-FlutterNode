import 'dart:convert';

import 'package:app_web/global_variable.dart';
import 'package:app_web/models/buyer_model.dart';
import 'package:http/http.dart' as http;

class BuyerController {
  
    Future<List<BuyerModel>> fetchBuyer() async {
    try {
      // send an http get request to fetch banner
      http.Response response = await http.get(
        Uri.parse('$uri/api/users'),
        headers: <String, String>{
          //set the headers for the request
          "Content-Type":
              "application/json; charset=UTF-8", // specify the context type as json
        },
      );

      if (response.statusCode == 200) {
      // convert json into object
        List<dynamic> data = jsonDecode(response.body);

        List<BuyerModel> buyers =
            data.map((buyer) => BuyerModel.fromMap(buyer)).toList();

        return buyers;
      } else {
        // throw an exception if the server responded with error status code
        throw Exception('falied to load buyers');
      }
    } catch (e) {
      throw Exception('Error loading buyers');
    }
  }
}