import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app/models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a StateNOtifierProvider to expose an instance of the cartNotifier
// Making it accesible within our app
final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, CartModel>>((ref) {
  return CartNotifier();
});

// A notifier class to manage the cart state , extending stateNotifier with an initial state of an  empty map
class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({}){
    _loadCartItems();
  }

  Future<void> _saveCartItems() async {
    // retrieving the sharedpreferences instance to store data
    final prefs = await SharedPreferences.getInstance();
    // encoding the current state(Map of favourite object) into json String
    final cartString = jsonEncode(state);
    // saving the json string to sharedprefernces with the key "favourites"
    await prefs.setString('cart_items', cartString);
  }

    // A private method that loads items from sharedprefernces
  Future<void> _loadCartItems()async {
    // retrieving the sharedpreferences instance to store data
    final prefs = await SharedPreferences.getInstance();
    // fetch the json String of  the items from sharedprefernces under the key favourited
    final cartString = prefs.getString('cart_items');
    // checking if the string is not null, meaning there is saved data to load
    if (cartString != null) {
      // decode the json string into a map of dynamic data
      final Map<String,dynamic> cartMap =  jsonDecode(cartString);

      // convert the dynamic map into a map of favourite objects using the 'fromjson' factory method
      final cartItems = cartMap.map((key,value)=> MapEntry(key, CartModel.fromJson(value)));

      // updating the state with the loaded favourite
      state = cartItems;
    }
  }

  // Method to add product  to the cart
  void addProductToCart({
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
    // check if the product is already  in the cart
    if (state.containsKey(productId)) {
      // if the product is already in the cart, update its quantity and other things
      state = {
        ...state,
        productId: CartModel(
          productName: state[productId]!.productName,
          productPrice: state[productId]!.productPrice,
          category: state[productId]!.category,
          image: state[productId]!.image,
          vendorId: state[productId]!.vendorId,
          productQuantity: state[productId]!.productQuantity,
          quantity: state[productId]!.quantity + 1,
          productId: state[productId]!.productId,
          description: state[productId]!.description,
          fullName: state[productId]!.fullName,
        )
      };
    } else {
      // if the product is not in the cart, add it with provided details
      state = {
        ...state,
        productId: CartModel(
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
        )
      };
    }
  }

  // Method to increment the quantity of a product in the cart
  void incrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity++;

      // Notify the listener that the state has changed
      state = {...state};
      _saveCartItems();
    }
  }

  // Method to decrement the quantity of a product in the cart
  void decrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity--;

      // Notify the listener that the state has changed
      state = {...state};
      _saveCartItems();
    }
  }

  // Method to remove the item from the cart
  void removeCartItem(String productId) {
    state.remove(productId);
    // Notify the listener that the state has changed
    state = {...state};
    _saveCartItems();
  }

  // Method to calculate toatal amount of items we have in cart
  double calculateTotalamount() {
    double totalAmount = 0.0;
    state.forEach((productId, cartItem) {
      totalAmount += cartItem.quantity * cartItem.productPrice;
    });
    return totalAmount;
  }

  // Method to clear all the cart items
  void clearCart(){
    state = {};
    // Notify Listeners that state has changed
    state = {...state};
    _saveCartItems();
  }

  Map<String, CartModel> get getCartItems => state;
}
