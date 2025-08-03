import 'package:multi_store_app/global_variable.dart';
import 'package:multi_store_app/models/product_review_model.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store_app/services/manage_http_response.dart';

class ProductReviewController {
  // Method to upload review

  uploadReview({
    required String buyerid,
    required String email,
    required String fullName,
    required String productId,
    required double rating,
    required String review,
    required context
  }) async {
    try {
      ProductReviewModel productReviewModel = ProductReviewModel(
        id: '',
        buyerid: buyerid,
        email: email,
        fullName: fullName,
        productId: productId,
        rating: rating,
        review: review,
      );

      http.Response response =  await http.post(
        Uri.parse("$uri/api/product-review"),
        body: productReviewModel.toJson(),
        headers: <String, String>{
          //set the headers for the request
          "Content-Type":
              "application/json; charset=UTF-8", // specify the context type as json
        },
        );

        manageHttpResponse(response: response, context: context, onSuccess: (){
          showSnackBar(context, "Review uploaded successfully");
        });
    } catch (e) {
      showSnackBar(context, "something went wrong");
    }
  }
}
