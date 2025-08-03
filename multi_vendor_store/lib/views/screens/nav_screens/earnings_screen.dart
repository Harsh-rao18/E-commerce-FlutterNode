import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_vendor_store/controllers/order_controller.dart';
import 'package:multi_vendor_store/provider/order_provider.dart';
import 'package:multi_vendor_store/provider/total_earnings_provider.dart';
import 'package:multi_vendor_store/provider/vendor_provider.dart';

class EarningsScreen extends ConsumerStatefulWidget {
  const EarningsScreen({super.key});

  @override
  ConsumerState<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends ConsumerState<EarningsScreen> {
  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final vendor = ref.read(vendorProvider);
    if (vendor != null) {
      final OrderController orderController = OrderController();
      try {
        final orders = await orderController.fetchOrders(vendorId: vendor.id);
        ref.read(orderProvider.notifier).setOrders(orders);
        ref.read(totalEarningProvider.notifier).calculateTotalEarnings(orders);
      } catch (e) {
        debugPrint("Error Fetching Orders");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendor = ref.watch(vendorProvider);
    final totalEarnings = ref.watch(totalEarningProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              child: Text(
                vendor!.fullName[0].toUpperCase(),
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 300,
              child: Text(
                "Welcome, ${vendor.fullName}!!",
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total Earnings",
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  color: Colors.grey
                ),
              ),
              const SizedBox(height: 8,),
              Text(
                "\$${totalEarnings['totalEarnings'].toStringAsFixed(2)}",
                style: GoogleFonts.montserrat(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.green
                ),
              ),
              const SizedBox(height: 16,),
              Text(
                "Total Orders",
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  color: Colors.grey
                ),
              ),
              const SizedBox(height: 8,),
              Text(
                "${totalEarnings['totalOrders']}",
                style: GoogleFonts.montserrat(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
