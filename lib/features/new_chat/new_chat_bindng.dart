import 'package:hifz_tracker/core_imports.dart';
import 'package:hifz_tracker/features/new_chat/new_chat_controller.dart';

class NewChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewChatController());
  }
}
