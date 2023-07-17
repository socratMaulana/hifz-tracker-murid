import 'package:hifz_tracker/core_imports.dart';
import 'package:hifz_tracker/features/dashboard/dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() => controller.currentWidget.value),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    return Obx(
      () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          backgroundColor: Colors.white,
          onTap: (value) => controller.setWidget(value),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_outlined), label: 'Chat'),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.assistant_photo), label: 'Pengumuman'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined), label: 'Profil'),
          ]),
    );
  }
}
