import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app/models/wishlist_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider extends StateNotifier<Map<String, WishlistModel>> {
  WishlistProvider() : super({}) {
    _loadFavourite();
  }

  // A private method that saves the current list of favourite items to sharedpreferences
  Future<void> _saveFavourite() async {
    // retrieving the sharedpreferences instance to store data
    final prefs = await SharedPreferences.getInstance();
    // encoding the current state(Map of favourite object) into json String
    final favouriteString = jsonEncode(state);
    // saving the json string to sharedprefernces with the key "favourites"
    await prefs.setString('favourites', favouriteString); 
  }

  // A private method that loads items from sharedprefernces
  Future<void> _loadFavourite()async {
    // retrieving the sharedpreferences instance to store data
    final prefs = await SharedPreferences.getInstance();
    // fetch the json String of  the items from sharedprefernces under the key favourited
    final favouriteString = prefs.getString('favourites');
    // checking if the string is not null, meaning there is saved data to load
    if (favouriteString != null) {
      // decode the json string into a map of dynamic data
      final Map<String,dynamic> favouriteMap =  jsonDecode(favouriteString);

      // convert the dynamic map into a map of favourite objects using the 'fromjson' factory method
      final favourites = favouriteMap.map((key,value)=> MapEntry(key, WishlistModel.fromJson(value)));

      // updating the state with the loaded favourite
      state = favourites;
    }
  }


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
  _saveFavourite();
  }

  void removeWishlistItem(String productId){
    state.remove(productId);
    // Notify the listener that the state has changed
      state = {...state};
      _saveFavourite();
  }

  Map<String,WishlistModel> get getWishlistedItems => state;
}

final wishlistProvider = StateNotifierProvider<WishlistProvider,Map<String,WishlistModel>>((ref){
  return WishlistProvider();
});
