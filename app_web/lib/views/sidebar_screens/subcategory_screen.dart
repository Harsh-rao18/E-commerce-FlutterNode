import 'package:app_web/controller/category_controller.dart';
import 'package:app_web/controller/subcategory_controller.dart';
import 'package:app_web/models/category.dart';
import 'package:app_web/views/widgets/subcategory_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SubcategoryScreen extends StatefulWidget {
  static const String id = '\subcategories-screen';
  const SubcategoryScreen({super.key});

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  late Future<List<Category>> futureCategory;
  Category? selectedCategory;
  @override
  void initState() {
    super.initState();
    futureCategory = CategoryController().fetchCategories();
  }

  late String subcategoryName;
  dynamic _image;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SubcategoryController _controller = SubcategoryController();

  void pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Subcategories',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(4.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              FutureBuilder(
                  future: futureCategory,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error : ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('no categories'),
                      );
                    } else {
                      return DropdownButton<Category>(
                        value: selectedCategory,
                        hint: const Text('Select category'),
                        items: snapshot.data!.map((Category category) {
                          return DropdownMenuItem(
                              value: category, child: Text(category.name));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      );
                    }
                  }),
              Row(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: _image != null
                        ? Image.memory(_image)
                        : const Center(child: Text("Subcategory image")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 200,
                      child: TextFormField(
                        onChanged: (value) {
                          subcategoryName = value;
                        },
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return "please enter subcategory name";
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: "Enter Subcategory Name",
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _controller.uploadSubcategory(
                          context: context,
                          categoryId: selectedCategory!.id,
                          categoryName: selectedCategory!.name,
                          subcategoryName: subcategoryName,
                          pickedImage: _image,
                        );
                        setState(() {
                          _formKey.currentState!.reset();
                          _image = null;
                        });
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: pickImage,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "pick image",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(4.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              const SubcategoryWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
