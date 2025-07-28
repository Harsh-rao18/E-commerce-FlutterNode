import 'package:multi_store_app/global_variable.dart';
import 'package:multi_store_app/models/order_model.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store_app/services/manage_http_response.dart';

class OrderController {
  // function to upload orders
  uploadOrders({
    required context,
    required String id,
    required String fullName,
    required String email,
    required String state,
    required String city,
    required String locality,
    required String productName,
    required int productPrice,
    required int quantity,
    required String category,
    required String image,
    required String buyerId,
    required String vendorId,
    required bool processing,
    required bool delivered,
  }) async {
    try {
      final OrderModel order = OrderModel(
        id: id,
        fullName: fullName,
        email: email,
        state: state,
        city: city,
        locality: locality,
        productName: productName,
        productPrice: productPrice,
        quantity: quantity,
        category: category,
        image: image,
        buyerId: buyerId,
        vendorId: vendorId,
        processing: processing,
        delivered: delivered,
      );
    
    http.Response response =  await http.post(
      Uri.parse("$uri/api/orders"),
      body: order.toJson(),
      headers: <String, String>{
        //set the headers for the request
        "Content-Type":
            "application/json; charset=UTF-8", // specify the context type as json
      },
    );

    manageHttpResponse(response: response, context: context, onSuccess:(){
      showSnackBar(context, "You have placed an order");
    });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
