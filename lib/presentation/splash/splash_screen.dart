import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:pridesys_app/core/colors/app_colors.dart';
import 'package:pridesys_app/core/image_path/img_path.dart';
import 'controller/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final SplashScreenController controller = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: SizedBox(
        height: screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Image.asset(ImagePath.logo, width: screenWidth * 0.6),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: SpinKitCircle(color: AppColors.primaryColor, size: 70),
            ),
          ],
        ),
      ),
    );
  }
}
