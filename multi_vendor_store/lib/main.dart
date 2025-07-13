import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_vendor_store/provider/vendor_provider.dart';
import 'package:multi_vendor_store/views/screens/auth_screens/login_screen.dart';
import 'package:multi_vendor_store/views/screens/main_vendor_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> checkTokenAndSetUser(WidgetRef ref) async {
      // Obtain an instance of SharedPreferences
      SharedPreferences preferences = await SharedPreferences.getInstance();

      // retrive the authentication token and user data stored locally
      String? token = preferences.getString('auth_token');
      String? vendorJson = preferences.getString('vendor');

      // if both token and data are avialbale, update the vendor state
      if (token != null && vendorJson != null) {
        ref.read(vendorProvider.notifier).setVendor(vendorJson);
      } else {
        ref.read(vendorProvider.notifier).signOut();
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder(
        future: checkTokenAndSetUser(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final vendor = ref.watch(vendorProvider);

          return vendor != null ? MainVendorScreen() : LoginScreen();
        },
      ),
    );
  }
}
