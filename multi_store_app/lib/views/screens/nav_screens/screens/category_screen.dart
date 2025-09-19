import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/controllers/category_controller.dart';
import 'package:multi_store_app/controllers/subcategory_controller.dart';
import 'package:multi_store_app/models/category.dart';
import 'package:multi_store_app/provider/category_provider.dart';
import 'package:multi_store_app/provider/sub_category_provider.dart';
import 'package:multi_store_app/views/screens/details/widget/subcategory_tile_widget.dart';
import 'package:multi_store_app/views/screens/nav_screens/widgets/header_widget.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();

    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final categories = await CategoryController().fetchCategories();
    ref.read(categoryProvider.notifier).setCategories(categories);

    // set the default selected category
    for (var category in categories) {
      if (category.name == "Fashion") {
        setState(() {
          _selectedCategory = category;
        });

        // load the subcategories for the default category
        _fetchSubcategories(category.name);
      }
    }
  }

  Future<void> _fetchSubcategories(String categoryName) async {
    final subcategories =
        await SubcategoryController().getSubcatgoryByCategoryName(categoryName);
    ref.read(subCategoryProvider.notifier).setCategories(subcategories);
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    final subCategories = ref.watch(subCategoryProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
        child: const HeaderWidget(),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // left side - display categories
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade200,
              child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return ListTile(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                        _fetchSubcategories(category.name);
                      },
                      title: Text(
                        category.name,
                        style: GoogleFonts.quicksand(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _selectedCategory == category
                              ? Colors.blue
                              : Colors.black,
                        ),
                      ),
                    );
                  }),
            ),
          ),
          // right side - selected category display
          Expanded(
              flex: 5,
              child: _selectedCategory != null
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _selectedCategory!.name,
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.7,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        _selectedCategory!.banner,
                                      ),
                                      fit: BoxFit.cover)),
                            ),
                          ),

                          // display subcategories
                          subCategories.isNotEmpty
                              ? GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: subCategories.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 4,
                                          mainAxisSpacing: 4,
                                          childAspectRatio: 2 / 3),
                                  itemBuilder: (context, index) {
                                    final subcategory = subCategories[index];
                                    return SubcategoryTileWidget(
                                      image: subcategory.image,
                                      title: subcategory.subCategoryName,
                                    );
                                  })
                              : const Center(
                                  child: Text("no subcategories"),
                                )
                        ],
                      ),
                    )
                  : Container()),
        ],
      ),
    );
  }
}
