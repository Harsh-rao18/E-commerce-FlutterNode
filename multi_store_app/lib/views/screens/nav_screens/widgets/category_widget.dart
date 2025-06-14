import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/controllers/category_controller.dart';
import 'package:multi_store_app/models/category.dart';
import 'package:multi_store_app/views/screens/details/screeens/inner_category_screen.dart';
import 'package:multi_store_app/views/screens/nav_screens/widgets/reusable_text_widget.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  late Future<List<Category>> futureCategory;
  @override
  void initState() {
    super.initState();
    futureCategory = CategoryController().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReusableTextWidget(title: "Categories", subtitle: "view all"),
        FutureBuilder(
            future: futureCategory,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error:${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No Categories'),
                );
              } else {
                final categories = snapshot.data!;
                return SizedBox(
                  height: 400,
                  child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InnerCategoryScreen(
                                  category: category,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Image.network(
                                category.image,
                                height: 60,
                                width: 60,
                              ),
                              Text(
                                category.name,
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                            ],
                          ),
                        );
                      }),
                );
              }
            }),
      ],
    );
  }
}
