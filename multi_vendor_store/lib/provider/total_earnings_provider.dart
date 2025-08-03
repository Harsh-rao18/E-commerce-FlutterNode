
// A Class that manages the state of total earnings which extends the StateNotifier
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_vendor_store/models/order_model.dart';

class TotalEarningsProvider extends StateNotifier<Map<String,dynamic>> {
  // constructor which initalizes the state with 0.0(starting total earnings)
  TotalEarningsProvider() : super({'totalEarnings':0.0,'totalOrders':0});

  // Method to calculate the total earnings
  void calculateTotalEarnings(List<OrderModel> orders){
    // varibale to hold the earnings and total order delivered
    double earnings = 0.0;
    int orderCount = 0;

    // accumlate the total earnings by looping through list of orders
    for (OrderModel order in orders) {
      if (order.delivered) {
        orderCount++;
        earnings += order.productPrice * order.quantity;
      }
    }
    // Update the state with total earnings
    state = {
      'totalEarnings':earnings,
      'totalOrders':orderCount,
    };
  }
}

final totalEarningProvider = StateNotifierProvider<TotalEarningsProvider,Map<String,dynamic>>((ref){
  return TotalEarningsProvider();
});