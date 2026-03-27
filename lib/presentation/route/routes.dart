import 'package:get/get.dart';
import 'package:pridesys_app/presentation/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';

  static List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
      transition: Transition.leftToRight,
    ),
  ];
}
