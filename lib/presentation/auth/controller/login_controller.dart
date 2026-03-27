import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pridesys_app/core/nav_bar/screen/nav_bar_screen.dart';
import 'package:pridesys_app/core/service/shared_preferences_helper.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxString errorMessage = ''.obs;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http
          .post(
            Uri.parse('https://dummyjson.com/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': usernameController.text.trim(),
              'password': passwordController.text.trim(),
              'expiresInMins': 30,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);
      if (kDebugMode) print('Login response: $data');

      if (response.statusCode == 200) {
        await SharedPreferencesHelper.saveUserSession(
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String,
          username: data['username'] as String,
          name: '${data['firstName']} ${data['lastName']}',
          email: data['email'] as String,
          image: data['image'] as String,
        );

        usernameController.clear();
        passwordController.clear();

        Get.offAll(() => NavigationbarScreen());
      } else {
        errorMessage.value = data['message'] ?? 'Login failed';
        _showErrorSnackbar(errorMessage.value);
      }
    } on SocketException {
      errorMessage.value = 'No internet connection. Check your network.';
      _showErrorSnackbar(errorMessage.value);
    } on TimeoutException {
      errorMessage.value = 'Request timed out. Please try again.';
      _showErrorSnackbar(errorMessage.value);
    } catch (e) {
      errorMessage.value = 'Something went wrong. Please try again.';
      _showErrorSnackbar(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  void togglePasswordVisibility() => obscurePassword.toggle();

  String? validateUsername(String? val) {
    if (val == null || val.trim().isEmpty) return 'Username is required';
    return null;
  }

  String? validatePassword(String? val) {
    if (val == null || val.trim().isEmpty) return 'Password is required';
    if (val.length < 4) return 'Password must be at least 4 characters';
    return null;
  }
}
