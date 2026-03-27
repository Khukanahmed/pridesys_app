import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pridesys_app/core/service/shared_preferences_helper.dart';

class ThemeController extends GetxController {
  final isDarkMode = false.obs; // default: light

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    isDarkMode.value = await SharedPreferencesHelper.getIsDarkMode();
    _applyTheme();
  }

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    await SharedPreferencesHelper.saveTheme(isDark: isDarkMode.value);
    _applyTheme();
  }

  void _applyTheme() {
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
