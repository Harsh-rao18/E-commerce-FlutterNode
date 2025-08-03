import 'dart:convert';

class ProductModel {
  final String id;
  final String productName;
  final int productPrice;
  final int quantity;
  final String description;
  final String category;
  final String subCategory;
  final String vendorId;
  final String fullName;
  final List<String> images;
  final double averageRating;
  final int totalRatings;

  ProductModel({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.description,
    required this.category,
    required this.subCategory,
    required this.vendorId,
    required this.fullName,
    required this.images,
    required this.averageRating,
    required this.totalRatings,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'description': description,
      'category': category,
      'subCategory': subCategory,
      'vendorId': vendorId,
      'fullName': fullName,
      'images': images,
      'averageRating': averageRating,
      'totalRatings': totalRatings,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['_id'] ?? '',
      productName: map['productName'] ?? '',
      productPrice: map['productPrice']?.toInt() ?? 0,
      quantity: map['quantity']?.toInt() ?? 0,
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      subCategory: map['subCategory'] ?? '',
      vendorId: map['vendorId'] ?? '',
      fullName: map['fullName'] ?? '',
      images: List<String>.from(map['images']),
      averageRating: map['averageRating']?.toDouble() ?? 0.0,
      totalRatings: map['totalRatings']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source));
}
