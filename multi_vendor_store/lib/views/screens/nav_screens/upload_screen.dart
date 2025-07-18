import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_vendor_store/controllers/category_controller.dart';
import 'package:multi_vendor_store/controllers/product_controller.dart';
import 'package:multi_vendor_store/controllers/sub_category_controller.dart';
import 'package:multi_vendor_store/models/category.dart';
import 'package:multi_vendor_store/models/sub_category.dart';
import 'package:multi_vendor_store/provider/vendor_provider.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProductController _productController = ProductController();
  final ImagePicker picker = ImagePicker();
  List<File> images = [];

  late String productName;
  late int productPrice;
  late int quantity;
  late String description;

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

  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    futureCategory = CategoryController().fetchCategories();
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
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  productName = value;
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
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter product Price";
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  productPrice = int.parse(value);
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
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter product Quantity";
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  quantity = int.parse(value);
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
                    items: snapshot.data!.map((Category category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                        selectedSubCategory = null;
                        futureSubCategories = SubcategoryController()
                            .getSubcatgoryByCategoryName(value!.name);
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
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  description = value;
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
                  onPressed: () async {
                    final vendor = ref.read(vendorProvider);

                    if (vendor == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Vendor ID is required. Please log in again.',
                          ),
                        ),
                      );
                      return;
                    }

                    if (_formKey.currentState!.validate() &&
                        selectedCategory != null &&
                        selectedSubCategory != null) {

                          setState(() {
                            isLoading = true;
                          });
                      await _productController.uploadProduct(
                        productName: productName,
                        productPrice: productPrice,
                        quantity: quantity,
                        description: description,
                        category: selectedCategory!.name,
                        subCategory: selectedSubCategory!.subCategoryName,
                        vendorId: vendor.id,
                        fullName: vendor.fullName,
                        pickedImages: images,
                        context: context,
                      ).whenComplete((){
                        setState(() {
                        isLoading = false;
                      });
                      selectedCategory = null;
                      selectedSubCategory = null;
                      images.clear();
                      });
                      
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fill all fields and selections',
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading ? CircularProgressIndicator(color: Colors.white,) : Text('Upload'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
