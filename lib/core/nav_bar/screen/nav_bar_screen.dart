import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pridesys_app/core/nav_bar/controller/nav_bar_controller.dart';
import 'package:pridesys_app/presentation/character_screen/view/character_screen.dart';
import 'package:pridesys_app/presentation/favorite_screen/view/product_screen.dart';

class NavigationbarScreen extends StatelessWidget {
  NavigationbarScreen({super.key});

  final NavigationbarController controller = Get.put(NavigationbarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.selectedIndex.value == 0) {
          return CharacterListScreen();
        } else {
          return FavoritesView();
        }
      }),

      // Bottom Navigation Bar
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Characters",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favorites",
            ),
          ],
        ),
      ),
    );
  }
}
