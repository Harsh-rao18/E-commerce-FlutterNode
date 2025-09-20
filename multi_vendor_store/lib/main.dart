import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_vendor_store/controllers/vendor_auth_controller.dart';
import 'package:multi_vendor_store/provider/vendor_provider.dart';
import 'package:multi_vendor_store/views/screens/auth_screens/login_screen.dart';
import 'package:multi_vendor_store/views/screens/main_vendor_screen.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> checkTokenAndSetUser(WidgetRef ref) async {
      await VendorAuthController().getUserData(context, ref);
    ref.watch(vendorProvider);
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

          return vendor!.token.isNotEmpty ? MainVendorScreen() : LoginScreen();
        },
      ),
    );
  }
}
