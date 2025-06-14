import 'package:flutter/material.dart';

class InnerBannerWidget extends StatelessWidget {
  final String banner;
  const InnerBannerWidget({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 170,
        width: MediaQuery.of(context).size.width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            banner,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
