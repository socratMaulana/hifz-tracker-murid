import 'package:hifz_tracker/core_imports.dart';
import 'package:hifz_tracker/features/history/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HistoryController());
  }
}
