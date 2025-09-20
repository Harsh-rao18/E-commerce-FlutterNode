import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:multi_store_app/provider/user_provider.dart';
import 'package:multi_store_app/views/screens/auth_screens/login_screen.dart';
import 'package:multi_store_app/views/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51S8yVoFDs5Pc77CJAZ3ZMaNFlDiiJF5YQLMEGfrI1IGWDoM60pNpZRcqQSQ0JreriRKX7CKiG0qRovLr1uioqMlg009TC5ulrT";
  await Stripe.instance.applySettings();
  
  // Run the flutter app wrapped in a ProviderScope for managing state
  runApp(const ProviderScope(child: MyApp()));
}

// Root widget of the application , a consumerWidget to consume the state change
class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  // Method to check the token ans set the user data if avialable
  Future<void> _checkTokenAndSetUser(WidgetRef ref) async {
    // obtain the instance of shared prefernce for local data storage
    SharedPreferences preferences = await SharedPreferences.getInstance(); 

    // retrive the auth token and user data which is stored locally
    String? token = preferences.getString('auth_token');
    String? userJson = preferences.getString('user');

    // if both token and user data is avialble , update the user state
    if (token != null && userJson != null) {
      ref.read(userProvider.notifier).setUser(userJson);
    } else {
      ref.read(userProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      title: 'MSA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
          future: _checkTokenAndSetUser(ref),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final user = ref.watch(userProvider);
            return user != null ? const MainScreen() : const LoginScreen();
          }),
    );
  }
}
