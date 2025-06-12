import 'package:app_web/controller/subcategory_controller.dart';
import 'package:app_web/models/subcategory.dart';
import 'package:flutter/material.dart';

class SubcategoryWidget extends StatefulWidget {
  const SubcategoryWidget({super.key});

  @override
  State<SubcategoryWidget> createState() => _SubcategoryWidgetState();
}

class _SubcategoryWidgetState extends State<SubcategoryWidget> {
  late Future<List<Subcategory>> futureSubcategory;
  @override
  void initState() {
    super.initState();
    futureSubcategory = SubcategoryController().fetchSubCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureSubcategory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error:${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Subcategories'),
            );
          } else {
            final subcategories = snapshot.data!;
            return SizedBox(
              height: 400,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: subcategories.length,
                  itemBuilder: (context, index) {
                    final subcategory = subcategories[index];
                    return Column(
                      children: [
                        Image.network(subcategory.image,
                        height: 100,
                        width: 100,
                        ),
                        Text(subcategory.subCategoryName),
                      ],
                    );
                  }),
            );
          }
        });
  }
}
