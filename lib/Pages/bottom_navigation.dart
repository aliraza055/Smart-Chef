import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/Constants/app_theme.dart';
import 'package:smart_chef/Controller/bottom_navigation_controller.dart';
import 'package:smart_chef/Pages/add_receipe.dart';
import 'package:smart_chef/Pages/favorite_item.dart';
import 'package:smart_chef/Pages/home_page.dart';
import 'package:smart_chef/Pages/setting.dart';
import 'package:smart_chef/Pages/user_info.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({super.key});

  final controller = Get.put(BottomNavigationController());

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      Homepage(),
      FavoritePage(),
      const SizedBox(),
      const UserInfo(),
      SettingsPage(),
    ];

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Obx(() => pages[controller.currentIndex.value]),

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
        color: AppTheme.divider,
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
    return Obx(() {
      final bool isSelected = controller.currentIndex.value == index;

      return InkWell(
        onTap: () => controller.changeIndex(index),
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
    });
  }
}

