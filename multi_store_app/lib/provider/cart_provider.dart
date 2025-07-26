import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app/models/cart_model.dart';

// Define a StateNOtifierProvider to expose an instance of the cartNotifier
// Making it accesible within our app
final cartProvider = StateNotifierProvider<CartNotifier,Map<String,CartModel>>((ref){
  return CartNotifier();
});



// A notifier class to manage the cart state , extending stateNotifier with an initial state of an  empty map
class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});

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
  void incrementCartItem(String productId){
    if (state.containsKey(productId)) {
      state[productId]!.quantity++;

      // Notify the listener that the state has changed
      state = {...state};
    }
  }

  // Method to decrement the quantity of a product in the cart
  void decrementCartItem(String productId){
    if (state.containsKey(productId)) {
      state[productId]!.quantity--;

      // Notify the listener that the state has changed
      state = {...state};
    }
  }

  // Method to remove the item from the cart
  void removeCartItem(String productId){
    state.remove(productId);
    // Notify the listener that the state has changed
      state = {...state};
  }

  // Method to calculate toatal amount of items we have in cart
  double calculateTotalamount(){
    double totalAmount = 0.0;
    state.forEach((productId,cartItem){
      totalAmount += cartItem.quantity * cartItem.productPrice;
    });  
    return totalAmount;
  }
}
