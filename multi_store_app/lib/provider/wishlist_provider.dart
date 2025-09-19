import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app/models/wishlist_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider extends StateNotifier<Map<String, WishlistModel>> {
  WishlistProvider() : super({});

  // 🔹 Save favourites for a specific user
  Future<void> _saveFavourite(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final favouriteString = jsonEncode(state);
    await prefs.setString('favourites_$userId', favouriteString);
  }

  // 🔹 Load favourites for a specific user
  Future<void> loadFavourite(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final favouriteString = prefs.getString('favourites_$userId');

    if (favouriteString != null) {
      final Map<String, dynamic> favouriteMap = jsonDecode(favouriteString);
      final favourites = favouriteMap.map(
        (key, value) => MapEntry(key, WishlistModel.fromJson(value)),
      );
      state = favourites;
    } else {
      state = {};
    }
  }

  // 🔹 Add product to wishlist (per user)
  void addProductToWishlist({
    required String userId,
    required String productName,
    required int productPrice,
    required String category,
    required List<String> image,
    required String vendorId,
    required int productQuantity,
    required int quantity,
    required String productId,
    required String description,
    required String fullName,
  }) {
    state[productId] = WishlistModel(
      productName: productName,
      productPrice: productPrice,
      category: category,
      image: image,
      vendorId: vendorId,
      productQuantity: productQuantity,
      quantity: quantity,
      productId: productId,
      description: description,
      fullName: fullName,
    );
    state = {...state};
    _saveFavourite(userId);
  }

  // 🔹 Remove product from wishlist (per user)
  void removeWishlistItem(String userId, String productId) {
    state.remove(productId);
    state = {...state};
    _saveFavourite(userId);
  }

  // 🔹 Clear wishlist for a specific user (on logout, if needed)
  Future<void> clearWishList() async {
    state = {};
  }

  // Getter
  Map<String, WishlistModel> get getWishlistedItems => state;
}

final wishlistProvider =
    StateNotifierProvider<WishlistProvider, Map<String, WishlistModel>>((ref) {
  return WishlistProvider();
});
