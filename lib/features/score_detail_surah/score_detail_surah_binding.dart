import 'package:hifz_tracker/core_imports.dart';
import 'package:hifz_tracker/features/score_detail_surah/score_detail_surah_controller.dart';

class ScoreDetailSurahBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScoreDetailSurahController());
  }
}
