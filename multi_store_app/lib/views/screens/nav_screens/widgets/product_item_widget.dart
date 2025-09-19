import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/models/product_model.dart';
import 'package:multi_store_app/provider/cart_provider.dart';
import 'package:multi_store_app/provider/user_provider.dart';
import 'package:multi_store_app/provider/wishlist_provider.dart';
import 'package:multi_store_app/services/manage_http_response.dart';
import 'package:multi_store_app/views/screens/details/screeens/product_detail_screen.dart';

class ProductItemWidget extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductItemWidget({super.key, required this.product});

  @override
  ConsumerState<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends ConsumerState<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    final wishlistProviderData = ref.read(wishlistProvider.notifier);
    ref.watch(wishlistProvider);
    final cartProviderData = ref.read(cartProvider.notifier);
    final cartData = ref.watch(cartProvider);
    final isInCart = cartData.containsKey(widget.product.id);
    final user = ref.read(userProvider)!.id;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductDetailScreen(productModel: widget.product)));
      },
      child: Container(
        height: 260,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 170,
              decoration: BoxDecoration(
                  color: const Color(0xffF2F2F2),
                  borderRadius: BorderRadius.circular(24)),
              child: Stack(
                children: [
                  Image.network(
                    widget.product.images[0],
                    height: 170,
                    width: 170,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 4),
                  Positioned(
                    top: 15,
                    right: 2,
                    child: InkWell(
                        onTap: () {
                          wishlistProviderData.addProductToWishlist(
                            userId: user,
                            productName: widget.product.productName,
                            productPrice: widget.product.productPrice,
                            category: widget.product.category,
                            image: widget.product.images,
                            vendorId: widget.product.vendorId,
                            productQuantity: widget.product.quantity,
                            quantity: 1,
                            productId: widget.product.id,
                            description: widget.product.description,
                            fullName: widget.product.fullName,
                          );
                          showSnackBar(context, "Product Wishlisted");
                        },
                        child: wishlistProviderData.getWishlistedItems
                                .containsKey(widget.product.id)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(Icons.favorite_border)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: isInCart
                          ? null
                          : () {
                              cartProviderData.addProductToCart(
                                productName: widget.product.productName,
                                productPrice: widget.product.productPrice,
                                category: widget.product.category,
                                image: widget.product.images,
                                vendorId: widget.product.vendorId,
                                productQuantity: widget.product.quantity,
                                quantity: 1,
                                productId: widget.product.id,
                                description: widget.product.description,
                                fullName: widget.product.fullName,
                              );
                              showSnackBar(context, widget.product.productName);
                            },
                      child: Image.asset(
                        'assets/icons/cart.png',
                        width: 26,
                        height: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.product.productName,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: const Color(0xFF212121),
                  fontWeight: FontWeight.bold),
            ),
            widget.product.averageRating == 0
                ? const SizedBox()
                : Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 12,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.product.averageRating.toStringAsFixed(1),
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      )
                    ],
                  ),
            Text(
              widget.product.category,
              style: GoogleFonts.quicksand(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff868D94)),
            ),
            Text(
              widget.product.productPrice.toStringAsFixed(2),
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
