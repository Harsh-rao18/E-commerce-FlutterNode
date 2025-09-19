import 'package:flutter/material.dart';
import 'package:multi_store_app/controllers/product_controller.dart';
import 'package:multi_store_app/models/product_model.dart';
import 'package:multi_store_app/views/screens/nav_screens/widgets/product_item_widget.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductController _productController = ProductController();

  List<ProductModel> _searchProduct = [];
  bool isLoading = false;

  void _searchProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        final products = await _productController.searchProducts(query);
        setState(() {
          _searchProduct = products;
        });
      }
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
    final screenwidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenwidth < 600 ? 2 : 4;
    final childAspectratio = screenwidth  < 600 ? 3 / 4 : 4 / 5;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: "search products ....",
            suffixIcon: IconButton(
              onPressed: _searchProducts,
              icon: const Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (_searchProduct.isEmpty)
            const Center(
              child: Text("No Products Found"),
            )
          else
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectratio,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: _searchProduct.length,
                itemBuilder: (context , index){
                  final product = _searchProduct[index];
                  return ProductItemWidget(product: product);
                },
              ),
            ),
        ],
      ),
    );
  }
}
