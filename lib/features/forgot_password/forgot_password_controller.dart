import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core_imports.dart';

class ForgotPasswordControler extends BaseController {
  final key = GlobalKey<FormState>();
  final emailCtr = TextEditingController();

  sendResetPasswordEmail() async {
    try {
      if (!key.currentState!.validate()) return;

      isLoading(true);

      final response = await FirebaseUtils().getDataFromFirestoreWithArg(
          collection: Constants.studentRef, arg: 'email', value: emailCtr.text);
      if (response.docs.isEmpty) throw 'User tidak ditemukan!';

      await FirebaseUtils().auth.sendPasswordResetEmail(email: emailCtr.text);

      isLoading(false);
      Get.back();
      Utils.showGetSnackbar('Silahkan cek email / spam anda!', true);
    } on FirebaseException catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }
}
