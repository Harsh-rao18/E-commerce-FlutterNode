import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_vendor_store/controllers/category_controller.dart';
import 'package:multi_vendor_store/controllers/sub_category_controller.dart';
import 'package:multi_vendor_store/models/category.dart';
import 'package:multi_vendor_store/models/sub_category.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  List<File> images = [];

  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        images.add(File(pickedFile.path));
      });
    } else {
      print("No image picked");
    }
  }

  late Future<List<Category>> futureCategory;
  Future<List<Subcategory>>? futureSubCategories;

  Category? selectedCategory;
  Subcategory? selectedSubCategory;

  @override
  void initState() {
    super.initState();
    futureCategory = CategoryController().fetchCategories();
  }

  getSubCategoryByCategory(Category value) {
    futureSubCategories =
        SubcategoryController().getSubcatgoryByCategoryName(value.name);
    
    // reset the selectedSubcategory
    selectedCategory = null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image Picker Grid
            SizedBox(
              height: 200,
              child: GridView.builder(
                itemCount: images.length + 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return index == 0
                      ? Center(
                          child: IconButton(
                            onPressed: chooseImage,
                            icon: Icon(Icons.add),
                          ),
                        )
                      : SizedBox(
                          width: 50,
                          height: 40,
                          child: Image.file(images[index - 1]),
                        );
                },
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
            const SizedBox(height: 10),
        
            /// Product Name
            SizedBox(
              width: 200,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter product Name";
                  } else{
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Enter Product',
                  hintText: 'Enter product name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
        
            /// Product Price
            SizedBox(
              width: 200,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter product Price";
                  } else{
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Enter Product Price',
                  hintText: 'Enter product price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
        
            /// Product Quantity
            SizedBox(
              width: 200,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter product Quantity";
                  } else{
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Enter Product Quantity',
                  hintText: 'Enter product quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            /// Category Dropdown
            FutureBuilder<List<Category>>(
              future: futureCategory,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No categories found.');
                } else {
                  return DropdownButton<Category>(
                    value: selectedCategory,
                    hint: const Text('Select Category'),
                    items: snapshot.data!.map((Category cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                        selectedSubCategory = null; // Reset subcategory
                        getSubCategoryByCategory(value!);
                      });
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 10),
        
            /// Subcategory Dropdown
            FutureBuilder<List<Subcategory>>(
              future: futureSubCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No subcategories found.');
                } else {
                  return DropdownButton<Subcategory>(
                    value: selectedSubCategory,
                    hint: const Text('Select Subcategory'),
                    items: snapshot.data!.map((Subcategory subCat) {
                      return DropdownMenuItem(
                        value: subCat,
                        child: Text(subCat.subCategoryName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSubCategory = value;
                      });
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 10),
        
        
            /// Description
            SizedBox(
              width: 400,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter product Description";
                  } else{
                    return null;
                  }
                },
                maxLines: 3,
                maxLength: 500,
                decoration: InputDecoration(
                  labelText: 'Enter Product Description',
                  hintText: 'Enter product description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
        
            /// Upload Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      debugPrint("Uploaded");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Upload'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
