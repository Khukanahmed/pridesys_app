import 'package:get/get.dart';
import 'package:pridesys_app/core/nav_bar/screen/nav_bar_screen.dart';
import 'package:pridesys_app/core/service/shared_preferences_helper.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final token = await SharedPreferencesHelper.getAccessToken();

    if (token != null && token.isNotEmpty) {
      Get.offAll(() => NavigationbarScreen());
    } else {
      Get.offAll(() => NavigationbarScreen());
    }
  }
}
