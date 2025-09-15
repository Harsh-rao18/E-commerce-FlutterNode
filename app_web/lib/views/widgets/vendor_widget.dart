import 'package:app_web/controller/vendor_controller.dart';
import 'package:app_web/models/vendor_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorWidget extends StatefulWidget {
  const VendorWidget({super.key});

  @override
  State<VendorWidget> createState() => _VendorWidgetState();
}

class _VendorWidgetState extends State<VendorWidget> {
  // A Future that will hold the list vendors once loaded from the api
  late Future<List<VendorModel>> futureVendors;
  @override
  void initState() {
    super.initState();
    futureVendors = VendorController().fetchVendor();
  }
  @override
  Widget build(BuildContext context) {
      Widget _vendorData(int flex, Widget widget) {
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
      future: futureVendors,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error : ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('no vendors'),
          );
        } else {
          // vendors variable will contain all the vendors
          final vendors = snapshot.data;
          return SizedBox(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: vendors!.length,
                itemBuilder: (context, index) {
                  final vendor = vendors[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        _vendorData(
                          1,
                          CircleAvatar(
                            child: Text(
                              vendor.fullName[0],
                              style: GoogleFonts.montserrat(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        _vendorData(
                          3,
                          Text(
                            vendor.fullName,
                            style: GoogleFonts.montserrat(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        _vendorData(
                          2,
                          Text(
                            vendor.email,
                            style: GoogleFonts.montserrat(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        _vendorData(
                          2,
                          Text(
                            "${vendor.state} ${vendor.city}",
                            style: GoogleFonts.montserrat(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        _vendorData(
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