import 'dart:convert';

class ProductReviewModel {
  final String id;
  final String buyerid;
  final String email;
  final String fullName;
  final String productId;
  final double rating;
  final String review;

  ProductReviewModel({
    required this.id,
    required this.buyerid,
    required this.email,
    required this.fullName,
    required this.productId,
    required this.rating,
    required this.review,
  });
  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buyerid': buyerid,
      'email': email,
      'fullName': fullName,
      'productId': productId,
      'rating': rating,
      'review': review,
    };
  }

  factory ProductReviewModel.fromMap(Map<String, dynamic> map) {
    return ProductReviewModel(
      id: map['_id'] ?? '',
      buyerid: map['buyerid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      productId: map['productId'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      review: map['review'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductReviewModel.fromJson(String source) => ProductReviewModel.fromMap(json.decode(source));
}
