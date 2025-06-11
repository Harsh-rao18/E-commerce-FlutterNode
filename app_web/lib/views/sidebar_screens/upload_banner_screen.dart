import 'package:app_web/controller/banner_controller.dart';
import 'package:app_web/views/widgets/banner_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadBannerScreen extends StatefulWidget {
  static const String id = '\bannersupload-screen';
  const UploadBannerScreen({super.key});

  @override
  State<UploadBannerScreen> createState() => _UploadBannerScreenState();
}

class _UploadBannerScreenState extends State<UploadBannerScreen> {
  dynamic _image;
  final BannerController _controller = BannerController();
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: const Text(
                "Banners",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 2,
          ),
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
                    : const Center(
                        child: Text("banner image"),
                      ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _controller.uploadBanner(context: context, pickedImage: _image);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: pickImage,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text(
                "pick Image",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 2,
          ),
          const BannerWidget(),
        ],
      ),
    );
  }
}
