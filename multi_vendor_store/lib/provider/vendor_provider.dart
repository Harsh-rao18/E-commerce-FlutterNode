import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_vendor_store/models/vendor_model.dart';

// StateNotifier : StateNotifier is a class provided by riverpod package that helps in
// managing the state , it is also designed to notify the listeners about the state changes

class VendorProvider extends StateNotifier<VendorModel?> {
  VendorProvider()
    : super(
        VendorModel(
          id: '',
          fullName: '',
          email: '',
          city: '',
          state: '',
          locality: '',
          role: '',
          password: '',
          token: '',
        ),
      );

  // Getter Method to extract value from an object
  VendorModel? get vendor => state;

  // Method to set vendorUser state from json
  // purpose : upadate  the user state base on json String representation of the user vendor object

  void setVendor(String vendorJson) {
    state = VendorModel.fromJson(vendorJson);
  }

  // Method to clear the vendor user state
  void signOut() {
    state = null;
  }
}

// make the data accessible within the application
final vendorProvider = StateNotifierProvider<VendorProvider, VendorModel?>((
  ref,
) {
  return VendorProvider();
});
