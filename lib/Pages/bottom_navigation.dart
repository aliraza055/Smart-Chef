import 'package:flutter/material.dart';
import 'package:smart_chef/Pages/add_receipe.dart';
import 'package:smart_chef/Pages/home_page.dart';
import 'package:smart_chef/Pages/practice_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  // pages for each tab
  final List<Widget> _pages = const [Homepage(), AddReceipe(), PracticePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Bottom Navigation Demo')),
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // highlight the selected tab
        onTap: (index) {
          setState(() {
            _currentIndex = index; // change tab
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,

        // define your bottom items
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
