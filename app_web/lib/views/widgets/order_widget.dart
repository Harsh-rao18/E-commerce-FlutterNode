import 'package:app_web/controller/order_controller.dart';
import 'package:app_web/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  // A Future that will hold the list orders once loaded from the api
  late Future<List<OrderModel>> futureOrders;
  @override
  void initState() {
    super.initState();
    futureOrders = OrderController().fetchOrder();
  }

  @override
  Widget build(BuildContext context) {
    Widget orderData(int flex, Widget widget) {
      return Expanded(
        flex: flex,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget,
          ),
        ),
      );
    }

    return FutureBuilder(
      future: futureOrders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error : ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('no orders'),
          );
        } else {
          // orders variable will contain all the orders
          final orders = snapshot.data;
          return SizedBox(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: orders!.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        orderData(
                            2,
                            Image.network(
                              order.image,
                              width: 50,
                              height: 50,
                            )),
                        orderData(
                            3,
                            Text(
                              order.productName,
                              style: GoogleFonts.montserrat(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            )),
                        orderData(
                            2,
                            Text(
                              order.productPrice.toStringAsFixed(2),
                              style: GoogleFonts.montserrat(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            )),
                        orderData(
                            1,
                            Text(
                              order.category,
                              style: GoogleFonts.montserrat(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            )),
                        orderData(
                            3,
                            Text(
                              order.fullName,
                              style: GoogleFonts.montserrat(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            )),
                        orderData(
                            2,
                            Text(
                              order.email,
                              style: GoogleFonts.montserrat(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            )),
                        orderData(
                            2,
                            Text(
                              "${order.state} ${order.city}",
                              style: GoogleFonts.montserrat(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            )),
                        orderData(
                            1,
                            order.processing == true
                                ? Text(
                                    "Processing",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  )
                                : order.processing == true
                                    ? Text(
                                        "Delivered",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        "Cancelled",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      )),
                      ],
                    ),
                  );
                }),
          );
        }
      },
    );
  }
}
