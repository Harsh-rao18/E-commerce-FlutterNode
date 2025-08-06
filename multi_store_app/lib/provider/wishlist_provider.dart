import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app/models/wishlist_model.dart';

class WishlistProvider extends StateNotifier<Map<String, WishlistModel>> {
  WishlistProvider() : super({});

  void addProductToWishlist({
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
  }

  void removeWishlistItem(String productId){
    state.remove(productId);
    // Notify the listener that the state has changed
      state = {...state};
  }

  Map<String,WishlistModel> get getWishlistedItems => state;
}

final wishlistProvider = StateNotifierProvider<WishlistProvider,Map<String,WishlistModel>>((ref){
  return WishlistProvider();
});
