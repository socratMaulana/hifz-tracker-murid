import 'package:hifz_tracker/core_imports.dart';

class ScoreDetailSurahController extends BaseController {
  final teachers = <Map<String, dynamic>>[].obs;
  final histories = <Map<String, dynamic>>[].obs;

  final surah = <String, dynamic>{}.obs;

  getTeachers() async {
    isLoading(true);

    try {
      final response = await FirebaseUtils()
          .getDataFromFirestore(collection: Constants.teacherRef);
      for (var element in response.docs) {
        final data = element.data();
        data['id'] = element.id;

        teachers.add(data);
      }

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Get.back();
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  Map<String, dynamic> getTeacher(String teacherId) {
    return teachers.where((p0) => p0['id'] == teacherId).first;
  }

  @override
  void onInit() async {
    final args = Get.arguments;
    final List<Map<String, dynamic>> histories = args['histories'];

    surah(args['surah']);
    this.histories(
      histories.where((element) => element['surah'] == surah['nama']).toList(),
    );

    await getTeachers();
    super.onInit();
  }
}
