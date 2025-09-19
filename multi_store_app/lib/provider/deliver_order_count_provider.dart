import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app/controllers/order_controller.dart';

class DeliverOrderCountProvider extends StateNotifier<int> {
  DeliverOrderCountProvider() : super(0);

  //Method to fetch the delivered order count
  Future<void> fetchDeliveredCount(String buyerId) async {
    try {
      OrderController orderController = OrderController();
      int count =
          await orderController.getDeliveredOrderedCount(buyerId: buyerId);

      state = count;
    } catch (e) {
      throw Exception("Error counting delivered Orders");
    }
  }

  // Method to reset the count
  void resetCount() {
    state = 0;
  }
}

final deliverOrderCountProvider =
    StateNotifierProvider<DeliverOrderCountProvider, int>((ref) {
  return DeliverOrderCountProvider();
});
