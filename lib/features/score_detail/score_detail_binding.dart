import 'package:hifz_tracker/core_imports.dart';
import 'package:hifz_tracker/features/score_detail/score_detail_controller.dart';

class ScoreDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScoreDetailController());
  }
}
