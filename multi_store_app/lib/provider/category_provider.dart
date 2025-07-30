import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app/models/category.dart';

class CategoryProvider extends StateNotifier<List<Category>> {
  CategoryProvider() :super([]);

  // Method to set the list of category
  void setCategories(List<Category> category){
    state = category;
  }
}

final categoryProvider = StateNotifierProvider<CategoryProvider,List<Category>>((ref){
  return CategoryProvider();
});