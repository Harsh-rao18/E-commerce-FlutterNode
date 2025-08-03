import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/models/product_model.dart';
import 'package:multi_store_app/views/screens/details/screeens/product_detail_screen.dart';

class ProductItemWidget extends StatelessWidget {
  final ProductModel product;

  const ProductItemWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductDetailScreen(productModel: product)));
      },
      child: Container(
        height: 170,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 170,
              decoration: BoxDecoration(
                  color: const Color(0xffF2F2F2),
                  borderRadius: BorderRadius.circular(24)),
              child: Stack(
                children: [
                  Image.network(
                    product.images[0],
                    height: 170,
                    width: 170,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 15,
                    right: 2,
                    child: Image.asset(
                      'assets/icons/love.png',
                      width: 26,
                      height: 26,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/icons/cart.png',
                      width: 26,
                      height: 26,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              product.productName,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: const Color(0xFF212121),
                  fontWeight: FontWeight.bold),
            ),
            product.averageRating == 0
                ? const SizedBox()
                : Row(
                    children: [
                     const  Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 12,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(product.averageRating.toStringAsFixed(1),style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 12),)
                    ],
                  ),
            Text(
              product.category,
              style: GoogleFonts.quicksand(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff868D94)),
            ),
            Text(
              product.productPrice.toStringAsFixed(2),
              style: GoogleFonts.quicksand(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff868D94)),
            ),
          ],
        ),
      ),
    );
  }
}
