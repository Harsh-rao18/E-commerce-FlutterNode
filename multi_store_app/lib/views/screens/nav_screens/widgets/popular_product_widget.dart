import 'package:flutter/material.dart';
import 'package:multi_store_app/controllers/product_controller.dart';
import 'package:multi_store_app/models/product_model.dart';
import 'package:multi_store_app/views/screens/nav_screens/widgets/product_item_widget.dart';

class PopularProductWidget extends StatefulWidget {
  const PopularProductWidget({super.key});

  @override
  State<PopularProductWidget> createState() => _PopularProductWidgetState();
}

class _PopularProductWidgetState extends State<PopularProductWidget> {
  late Future<List<ProductModel>> futurePopularProducts;
  @override
  void initState() {
    super.initState();
    futurePopularProducts = ProductController().fetchPopularProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futurePopularProducts,
      builder: (context,snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        } else if(snapshot.hasError) {
          return Center(child: Text("Error ${snapshot.error}"),);
        } else if (!snapshot.hasData || snapshot.data!.isEmpty){
          return Text("No Products found");
        } else {
          final products = snapshot.data;
          return SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: products!.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,index){
                final product = products[index];
                return ProductItemWidget(product: product,);
            }),
          );
        }
      },
    );
  }
}
