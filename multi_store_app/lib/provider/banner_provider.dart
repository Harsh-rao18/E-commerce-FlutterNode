import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app/models/banner.dart';

class BannerProvider extends StateNotifier<List<BannerModel>> {
  BannerProvider() :super([]);

  // Method to set the list of banner
  void setbanners(List<BannerModel> banners){
    state = banners;
  }
}

final bannerProvider = StateNotifierProvider<BannerProvider,List<BannerModel>>((ref){
  return BannerProvider();
});