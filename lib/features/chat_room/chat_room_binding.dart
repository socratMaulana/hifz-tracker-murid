import 'package:hifz_tracker/core_imports.dart';
import 'package:hifz_tracker/features/chat_room/chat_room_controller.dart';

class ChatRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatRoomController());
  }
}
