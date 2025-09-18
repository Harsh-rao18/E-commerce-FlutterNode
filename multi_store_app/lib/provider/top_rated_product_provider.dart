import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app/models/product_model.dart';

class TopRatedProductProvider extends StateNotifier<List<ProductModel>> {
  TopRatedProductProvider() : super([]);

  void setProducts(List<ProductModel> products){
    state = products;
  }

}

final topRatedProductProvider = StateNotifierProvider<TopRatedProductProvider,List<ProductModel>>((ref){
  return TopRatedProductProvider();
});