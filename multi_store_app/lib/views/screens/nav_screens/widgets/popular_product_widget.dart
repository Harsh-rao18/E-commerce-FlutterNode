import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app/controllers/product_controller.dart';
import 'package:multi_store_app/provider/product_provider.dart';
import 'package:multi_store_app/views/screens/nav_screens/widgets/product_item_widget.dart';

class PopularProductWidget extends ConsumerStatefulWidget {
  const PopularProductWidget({super.key});

  @override
  ConsumerState<PopularProductWidget> createState() =>
      _PopularProductWidgetState();
}

class _PopularProductWidgetState extends ConsumerState<PopularProductWidget> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final products = ref.read(productProvider);
    if (products.isEmpty) {
      _fetchProduct();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProduct() async {
    final ProductController productController = ProductController();
    try {
      final products = await productController.fetchPopularProducts();
      ref.read(productProvider.notifier).setProducts(products);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);
    return SizedBox(
      height: 260,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.blue,
            ))
          : ListView.builder(
              itemCount: products.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductItemWidget(
                  product: product,
                );
              }),
    );
  }
}
