import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app/models/subcategory_model.dart';

class SubCategoryProvider extends StateNotifier<List<Subcategory>> {
  SubCategoryProvider() :super([]);

  // Method to set the list of subcategory
  void setCategories(List<Subcategory> subcategory){
    state = subcategory;
  }
}

final subCategoryProvider = StateNotifierProvider<SubCategoryProvider,List<Subcategory>>((ref){
  return SubCategoryProvider();
});