import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Pages/add_receipe.dart';
import 'package:smart_chef/Pages/favorite_item.dart';
import 'package:smart_chef/Pages/home_page.dart';
import 'package:smart_chef/Pages/setting.dart';
import 'package:smart_chef/Pages/user_info.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  List<Map<String, dynamic>> favoriteRecipes = [];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      Homepage(),

      FavoritePage(),

      const SizedBox(),

      const UserInfo(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: _pages[_currentIndex],

      // Floating Add Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        shape: const CircleBorder(),
        elevation: 6,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddReceipe()),
          );
        },
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 10,

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Row(
                children: [
                  _buildNavItem(Icons.home, 0, "Home"),
                  const SizedBox(width: 20),
                  _buildNavItem(Icons.favorite, 1, "Favorite"),
                ],
              ),

              Row(
                children: [
                  _buildNavItem(Icons.person, 3, "Profile"),
                  const SizedBox(width: 20),
                  _buildNavItem(Icons.settings, 4, "Settings"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, String label) {
    final bool isSelected = _currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppTheme.primary : Colors.grey,
            size: isSelected ? 28 : 24,
          ),

          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppTheme.primary : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
