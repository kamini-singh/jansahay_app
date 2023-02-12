import 'package:flutter/material.dart';
import 'package:jansahay_app/screens/categories_page.dart';
import 'package:jansahay_app/screens/my_complaints.dart';
import 'package:jansahay_app/screens/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _pageOptions = [
    MyComplaints(),
    CategoriesPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: _pageOptions[_selectedIndex],
          
          //bottom navigation bar

        bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF5271ff),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'My Complaints',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
      ),
    );
  }
}