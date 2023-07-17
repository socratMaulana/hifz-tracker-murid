

import 'package:hifz_tracker/features/update_profile/update_profile_controller.dart';

import '../../core_imports.dart';

class UpdateProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateProfileController());
  }
}
