import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:multi_vendor_store/global_variables.dart';
import 'package:multi_vendor_store/models/product_model.dart';
import 'package:multi_vendor_store/services/manage_http_response.dart';
import 'package:http/http.dart' as http;

class ProductController {
  void uploadProduct({
    required String productName,
    required int productPrice,
    required int quantity,
    required String description,
    required String category,
    required String subCategory,
    required String vendorId,
    required String fullName,
    required List<File>? pickedImages,
    required context,
  }) async {
    try {
      if (pickedImages != null) {
        final cloudinary = CloudinaryPublic("dhocbxkhv", 'vgcavzfe');
        List<String> images = [];

        // loop through each image in the list
        for (var i = 0; i < pickedImages.length; i++) {
          // await the upload of the current image to cloudinary
          CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(pickedImages[i].path, folder: productName),
          );
          // add the secured url to images list
          images.add(cloudinaryResponse.secureUrl);
        }
        if (category.isNotEmpty && subCategory.isNotEmpty) {
          final product = ProductModel(
            id: '',
            productName: productName,
            productPrice: productPrice,
            quantity: quantity,
            description: description,
            category: category,
            subCategory: subCategory,
            vendorId: vendorId,
            fullName: fullName,
            images: images,
          );
          http.Response response = await http.post(
            Uri.parse('$uri/api/product'),
            body: product.toJson(),
            headers: <String, String>{
              //set the headers for the request
              "Content-Type":
                  "application/json; charset=UTF-8", // specify the context type as json
            },
          );

          manageHttpResponse(response: response, context: context, onSuccess: (){
            showSnackBar(context, "Product Uploaded");
          });
        } else {
          showSnackBar(context, "Selecr catagory and subCategory");
        }
      } else {
        showSnackBar(context, 'Select Image');
      }
    } catch (e) {}
  }
}
