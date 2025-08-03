import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_vendor_store/models/order_model.dart';

class OrderProvider extends StateNotifier<List<OrderModel>> {
  OrderProvider() : super([]);

  // set the list of Orders
  void setOrders(List<OrderModel> orders) {
    state = orders;
  }

  void updateOrderStatus(String orderId, {bool? processing, bool? delivered}) {
    // update the state of the provider with a list of orders
    state = [
      // iterate through existing orders
      for (final order in state)
        if (order.id == orderId)
          OrderModel(
            id: order.id,
            fullName: order.fullName,
            email: order.email,
            state: order.state,
            city: order.city,
            locality: order.locality,
            productName: order.productName,
            productPrice: order.productPrice,
            quantity: order.quantity,
            category: order.category,
            image: order.image,
            buyerId: order.buyerId,
            vendorId: order.vendorId,
            processing: processing ?? order.processing,
            delivered: delivered ?? order.delivered,
          )
          else
          order
    ];
  }
}

final orderProvider = StateNotifierProvider<OrderProvider, List<OrderModel>>((
  ref,
) {
  return OrderProvider();
});
