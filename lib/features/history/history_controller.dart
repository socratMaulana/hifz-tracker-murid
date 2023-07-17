import 'package:hifz_tracker/core_imports.dart';

class HistoryController extends BaseController {
  final historyDatas = <Map<String, dynamic>>[].obs;
  final type = ''.obs;

  getHistories() async {
    isLoading(true);

    try {
      final studentId = await Utils.readFromSecureStorage(key: Constants.token);
      final firestore = FirebaseUtils().firestore;
      final response = await firestore
          .collection(Constants.historyRef)
          .where('studentId', isEqualTo: studentId!)
          .where('type', isEqualTo: type.value)
          .orderBy('createdAt', descending: true)
          .get();

      historyDatas.clear();

      final responseDatas = <Map<String, dynamic>>[];
      for (var element in response.docs) {
        final data = element.data();
        data['id'] = element.id;
        data['type'] = 'entry';

        final fromAyat = int.parse(data['fromAyat']);
        final toAyat = int.parse(data['toAyat']);
        final ayatList = <int>[];

        for (var i = fromAyat; i <= toAyat; i++) {
          ayatList.add(i);
        }

        data['ayats'] = ayatList;

        responseDatas.add(data);
      }

      historyDatas(processData(datas: responseDatas));

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  List<Map<String, dynamic>> processData(
      {required List<Map<String, dynamic>> datas}) {
    final List<Map<String, dynamic>> newDatas = [
      {'date': datas.first['createdDate'], 'type': 'date'}
    ];

    String currentDate = datas.first['createdDate'];

    for (var element in datas) {
      final date = element['createdDate'];

      if (currentDate != date) {
        currentDate = date;
        newDatas.add({'date': currentDate, 'type': 'date'});
      }

      final history = element;
      history['type'] = 'entry';
      newDatas.add(history);
    }

    return newDatas;
  }

  @override
  void onInit() {
    type(Get.arguments);

    getHistories();
    super.onInit();
  }
}
