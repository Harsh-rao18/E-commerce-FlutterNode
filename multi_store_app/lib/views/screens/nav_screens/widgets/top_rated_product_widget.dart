import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app/controllers/product_controller.dart';
import 'package:multi_store_app/provider/product_provider.dart';
import 'package:multi_store_app/provider/top_rated_product_provider.dart';
import 'package:multi_store_app/views/screens/nav_screens/widgets/product_item_widget.dart';

class TopRatedProductWidget extends ConsumerStatefulWidget {
  const TopRatedProductWidget({super.key});

  @override
  ConsumerState<TopRatedProductWidget> createState() =>
      _TopRatedProductWidgetState();
}

class _TopRatedProductWidgetState extends ConsumerState<TopRatedProductWidget> {
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
      final products = await productController.fetchTopRatedProducts();
      ref.read(topRatedProductProvider.notifier).setProducts(products);
    } catch (e) {
      debugPrint(e.toString());
    } finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final topRatedProducts = ref.watch(topRatedProductProvider);
    return SizedBox(
      height: 250,
      child: isLoading ? const Center(child: CircularProgressIndicator(color: Colors.blue,))  : ListView.builder(
          itemCount: topRatedProducts.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final product = topRatedProducts[index];
            return ProductItemWidget(
              product: product,
            );
          }),
    );
  }
}
