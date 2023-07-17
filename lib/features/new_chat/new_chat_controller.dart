import 'package:hifz_tracker/core_imports.dart';

class NewChatController extends BaseController {
  final teachers = <Map<String, dynamic>>[].obs;

  @override
  void onInit() async {
    teachers(Get.arguments);
    super.onInit();
  }
}
