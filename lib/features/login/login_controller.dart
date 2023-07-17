import '../../core_imports.dart';
import '../dashboard/dashboard_binding.dart';
import '../dashboard/dashboard_screen.dart';

class LoginController extends BaseController {
  final key = GlobalKey<FormState>();
  final studentNo = TextEditingController();
  final passwordCtr = TextEditingController();

  login() async {
    if (!key.currentState!.validate()) {
      return;
    }

    isLoading(true);
    try {
      final studentResponse = await FirebaseUtils().getDataFromFirestoreWithArg(
        collection: Constants.studentRef,
        arg: 'studentNo',
        value: studentNo.text,
      );

      if (studentResponse.docs.isEmpty) {
        throw 'Nomor Murid / Password salah!';
      }

      final data = studentResponse.docs.first.data();
      data['id'] = studentResponse.docs.first.id;

      await FirebaseUtils().loginWithEmail(
        email: data['email'],
        password: passwordCtr.text,
      );

      Utils.storeToSecureStorage(key: Constants.token, data: data['id']);
      setCurrentLoggedInUser(data);

      isLoading(false);
      Get.offAll(() => const DashboardScreen(), binding: DashboardBinding());
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }
}
