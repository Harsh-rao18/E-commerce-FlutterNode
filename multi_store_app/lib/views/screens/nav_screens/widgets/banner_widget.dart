import 'package:flutter/material.dart';
import 'package:multi_store_app/controllers/banner_controller.dart';
import 'package:multi_store_app/models/banner.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
    // A Future that will hold the list banners once loaded from the api
  late Future<List<BannerModel>> futureBanners;
  @override
  void initState() {
    super.initState();
    futureBanners = BannerController().fetchBanner();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(4),
      ),
    child: FutureBuilder(
    future: futureBanners,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error : ${snapshot.error}'),
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(
          child: Text('no banners'),
        );
      } else {
        // banners variable will contain all the banners
        final banners = snapshot.data;
        return PageView.builder(
            itemCount: banners!.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Image.network(
                banner.image,
                fit: BoxFit.cover,
              );
            });
      }
    },
        ),
    );
  }
}
