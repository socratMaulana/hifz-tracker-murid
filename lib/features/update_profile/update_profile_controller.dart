import 'dart:convert';

import '../../core_imports.dart';

class UpdateProfileController extends BaseController {
  final key = GlobalKey<FormState>();
  final fullNameCtr = TextEditingController();
  final phoneCtr = TextEditingController();
  final emailCtr = TextEditingController();

  String studentId = '';

  updateProfile() async {
    if (!key.currentState!.validate()) return;

    try {
      isLoading(true);

      final request = {
        'fullName': fullNameCtr.text,
        'phone': phoneCtr.text,
        'email': emailCtr.text,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      };

      await FirebaseUtils().updateDataToFirestore(
          collection: Constants.studentRef, docName: studentId, data: request);
    
      final userData = await FirebaseUtils().getDataFromFirestoreById(
          collection: Constants.studentRef, id: studentId);
      final data = userData.data();
      data!['id'] = userData.id;

      setCurrentLoggedInUser(data);

      isLoading(false);
      Get.back(result: true);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  @override
  void onInit() async {
    final userString =
        await Utils.readFromSecureStorage(key: Constants.userData);
    final args = jsonDecode(userString!);

    fullNameCtr.text = args['fullName'];
    phoneCtr.text = args['phone'] ?? '';
    emailCtr.text = args['email'];
    studentId = args['id'];

    super.onInit();
  }
}
