import 'package:flutter/material.dart';
import 'package:multi_store_app/models/category.dart';
import 'package:multi_store_app/views/screens/details/widget/inner_category_content_widget.dart';
import 'package:multi_store_app/views/screens/nav_screens/screens/cart_screen.dart';
import 'package:multi_store_app/views/screens/nav_screens/screens/category_screen.dart';
import 'package:multi_store_app/views/screens/nav_screens/screens/favourite_screen.dart';
import 'package:multi_store_app/views/screens/nav_screens/screens/mart_screen.dart';
import 'package:multi_store_app/views/screens/nav_screens/screens/profile_screen.dart';

class InnerCategoryScreen extends StatefulWidget {
  final Category category;

  const InnerCategoryScreen({super.key, required this.category});

  @override
  State<InnerCategoryScreen> createState() => _InnerCategoryScreenState();
}

class _InnerCategoryScreenState extends State<InnerCategoryScreen> {

  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
  final List<Widget> pages = [
    InnerCategoryContentWidget(category: widget.category),
    const FavouriteScreen(),
    const CategoryScreen(),
    const MartScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];  
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: pageIndex,
        selectedItemColor: const Color.fromARGB(255, 43, 4, 171),
        unselectedItemColor: Colors.grey,
        onTap: (value) {
          setState(() {
            pageIndex = value;
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
          const BottomNavigationBarItem(
              icon: Icon(Icons.category,),
              label: "Category"),
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
      body: pages[pageIndex],
    );
  }
}
