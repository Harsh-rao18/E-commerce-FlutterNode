import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app/models/product_model.dart';

class RelatedProductProvider extends StateNotifier<List<ProductModel>> {
  RelatedProductProvider():super([]);

  // set the list of related products
  void setProducts(List<ProductModel> products ){
    state = products;
  }
}

final relatedProductsprovider = StateNotifierProvider<RelatedProductProvider,List<ProductModel>>((ref){
  return RelatedProductProvider();
});