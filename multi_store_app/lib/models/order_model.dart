// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OrderModel {
  final String id;
  final String productId;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String productName;
  final int productPrice;
  final int quantity;
  final String category;
  final String image;
  final String buyerId;
  final String vendorId;
  final bool processing;
  final bool delivered;
  final String paymentStatus;
  final String paymentIntentId;
  final String paymentMethod;

  OrderModel({
    required this.id,
    required this.productId,
    required this.fullName,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.category,
    required this.image,
    required this.buyerId,
    required this.vendorId,
    required this.processing,
    required this.delivered,
    required this.paymentStatus,
    required this.paymentIntentId,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'fullName': fullName,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'category': category,
      'image': image,
      'buyerId': buyerId,
      'vendorId': vendorId,
      'processing': processing,
      'delivered': delivered,
      'paymentStatus': paymentStatus,
      'paymentIntentId': paymentIntentId,
      'paymentMethod': paymentMethod,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> map) {
    return OrderModel(
      id: map['_id'] ?? '',
      productId: map['productId'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      locality: map['locality'] ?? '',
      productName: map['productName'] ?? '',
      productPrice: map['productPrice']?.toInt() ?? 0,
      quantity: map['quantity']?.toInt() ?? 0,
      category: map['category'] ?? '',
      image: map['image'] ?? '',
      buyerId: map['buyerId'] ?? '',
      vendorId: map['vendorId'] ?? '',
      processing: map['processing'] ?? false,
      delivered: map['delivered'] ?? false,
      paymentStatus: map['paymentStatus'] ?? '',
      paymentIntentId: map['paymentIntentId'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

}
