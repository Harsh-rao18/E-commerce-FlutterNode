import 'package:flutter/material.dart';
import 'package:multi_store_app/controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final AuthController controller = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: ElevatedButton(
              onPressed: () async {
                await controller.signOutUser(context: context);
              },
              child: Text("SignOut")),
        ));
  }
}
