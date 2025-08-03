import 'package:flutter/material.dart';
import 'package:multi_store_app/controllers/auth_controller.dart';
import 'package:multi_store_app/views/screens/details/screeens/order_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final AuthController controller = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    await controller.signOutUser(context: context);
                  },
                  child: Text("SignOut")),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderScreen()));
                  },
                  child: Text("My orders")),
            ),
          ],
        ));
  }
}
