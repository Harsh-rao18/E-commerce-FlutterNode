import 'package:app_web/controller/buyer_controller.dart';
import 'package:app_web/models/buyer_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuyerWidget extends StatefulWidget {
  const BuyerWidget({super.key});

  @override
  State<BuyerWidget> createState() => _BuyerWidgetState();
}

class _BuyerWidgetState extends State<BuyerWidget> {
  // A Future that will hold the list buyers once loaded from the api
  late Future<List<BuyerModel>> futureBuyers;
  @override
  void initState() {
    super.initState();
    futureBuyers = BuyerController().fetchBuyer();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buyerData(int flex, Widget widget) {
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
      future: futureBuyers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error : ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('no buyers'),
          );
        } else {
          // buyers variable will contain all the buyers
          final buyers = snapshot.data;
          return SizedBox(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: buyers!.length,
                itemBuilder: (context, index) {
                  final buyer = buyers[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        _buyerData(
                          1,
                          CircleAvatar(
                            child: Text(
                              buyer.fullName[0],
                              style: GoogleFonts.montserrat(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        _buyerData(
                          3,
                          Text(
                            buyer.fullName,
                            style: GoogleFonts.montserrat(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        _buyerData(
                          2,
                          Text(
                            buyer.email,
                            style: GoogleFonts.montserrat(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        _buyerData(
                          2,
                          Text(
                            "${buyer.state} ${buyer.city}",
                            style: GoogleFonts.montserrat(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        _buyerData(
                          1,
                          TextButton(
                              onPressed: () {}, child: const Text("Delete")),
                        ),
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
