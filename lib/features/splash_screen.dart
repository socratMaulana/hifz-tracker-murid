import 'package:hifz_tracker/core_imports.dart';
import 'package:hifz_tracker/features/dashboard/dashboard_binding.dart';
import 'package:hifz_tracker/features/dashboard/dashboard_screen.dart';

import 'login/login_binding.dart';
import 'login/login_screen.dart';

class SplashScreen extends GetView<BaseController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 1),
      () async {
        await controller.isLoggedIn()
            ? Get.offAll(() => const DashboardScreen(),
                binding: DashboardBinding())
            : Get.offAll(() => const LoginScreen(), binding: LoginBinding());
      },
    );

    return Container(
      color: CustomColor.primaryColor,
      child: Center(
        child: Image.asset(
          'assets/logo.png',
          width: MediaQuery.of(context).size.width * .5,
        ),
      ),
    );
  }
}
