import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app/models/user.dart';

class UserProvider extends StateNotifier<User?> {
  // constructor intializing with a defualt user object
  // purpose : Manage the state if the user object allowing updates
  UserProvider()
      : super(
          User(
              id: '',
              fullName: '',
              email: '',
              state: '',
              city: '',
              locality: '',
              password: '',
              token: ''),
        );

  // Getter Method to extracct values from an Object
  User? get user => state;

  // Method to ser user state from Json
  // purpose: updates the user state based on json String representation
  void setUser(String userJSon) {
    state = User.fromJson(userJSon);
  }

}
  // Make the data accessible within the  application
  final userProvider = StateNotifierProvider<UserProvider, User?>(
    (ref) => UserProvider(),
  );
