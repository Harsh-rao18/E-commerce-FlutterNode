import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/models/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel productModel;
  const ProductDetailScreen({super.key, required this.productModel});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productModel.productName,
          style:
              GoogleFonts.quicksand(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 260,
              height: 275,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    top: 50,
                    child: Container(
                      width: 260,
                      height: 260,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: const Color(0XFFD8DDFF),
                          borderRadius: BorderRadius.circular(130)),
                    ),
                  ),
                  Positioned(
                    left: 22,
                    top: 0,
                    child: Container(
                      width: 216,
                      height: 274,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: const Color(0XFF9CABFF),
                          borderRadius: BorderRadius.circular(14)),
                          child: SizedBox(
                            height: 300,
                            child: PageView.builder(
                              itemCount: widget.productModel.images.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context,index){
                                return Image.network(widget.productModel.images[index],
                                width: 198,
                                height: 225,
                                fit: BoxFit.cover,
                                );
                              }),
                          ),
                    ),
                  ),

                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.productModel.productName,style: GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.bold,letterSpacing: 1,color: const Color(0xFF3C55Ef)),),
                Text("\$${widget.productModel.productPrice}",style: GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.bold,letterSpacing: 1,color: const Color(0xFF3C55Ef)),),
              ],
            ),
          ),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Text(widget.productModel.category,style: GoogleFonts.roboto(fontSize: 17,fontWeight: FontWeight.w700,letterSpacing: 1,color: const Color(0xFF3C55Ef)),),
         ),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Column(
            children: [
              Text("About",style: GoogleFonts.lato(fontSize: 17,fontWeight: FontWeight.bold,letterSpacing: 1.7,color: const Color(0xFF363330)),),
              Text(widget.productModel.description,style: GoogleFonts.radley(fontSize: 17,fontWeight: FontWeight.bold,letterSpacing: 2,color: const Color(0xFF3C55Ef)),),
            ],
           ),
         )
        ],
      ),
      bottomSheet:  Padding(padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: (){},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3C55Ef),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          )
        ),
         child: Text("Add to Cart",style: GoogleFonts.mochiyPopOne(fontSize: 12,color: Colors.white,fontWeight: FontWeight.bold),)),
      ),
      
    );
  }
}
