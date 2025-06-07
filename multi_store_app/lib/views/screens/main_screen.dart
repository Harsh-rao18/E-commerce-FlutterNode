import 'package:flutter/material.dart';
import 'package:multi_store_app/views/screens/nav_screens/screens/cart_screen.dart';
import 'package:multi_store_app/views/screens/nav_screens/screens/favourite_screen.dart';
import 'package:multi_store_app/views/screens/nav_screens/screens/home_screen.dart';
import 'package:multi_store_app/views/screens/nav_screens/screens/mart_screen.dart';
import 'package:multi_store_app/views/screens/nav_screens/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  final List<Widget> _pages = [
    HomeScreen(),
    FavouriteScreen(),
    MartScreen(),
    CartScreen(),
    ProfileScreen(),
  ];  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _pageIndex,
        selectedItemColor: const Color.fromARGB(255, 43, 4, 171),
        unselectedItemColor: Colors.grey,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/home.png',
                width: 25,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/love.png',
                width: 25,
              ),
              label: "Favourite"),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/mart.png',
                width: 25,
              ),
              label: "Stores"),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/cart.png',
                width: 25,
              ),
              label: "Cart"),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/user.png',
                width: 25,
              ),
              label: "Account"),
        ],
      ),
      body: _pages[_pageIndex],
    );
  }
}
