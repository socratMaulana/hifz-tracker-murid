import 'package:hifz_tracker/core_imports.dart';

class ScoreDetailController extends BaseController {
  final teacher = <String, dynamic>{}.obs;
  final Map<String, dynamic> history = Get.arguments['history'];
  final String title = Get.arguments['title'];

  getTeacher() async {
    isLoading(true);

    try {
      final response = await FirebaseUtils().getDataFromFirestoreById(
          collection: Constants.teacherRef, id: history['teacherId']);

     teacher(response.data());

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Get.back();
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  @override
  void onInit() async {
    await getTeacher();
    super.onInit();
  }
}
