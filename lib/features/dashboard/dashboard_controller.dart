import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hifz_tracker/core_imports.dart';
import 'package:hifz_tracker/features/dashboard/widgets/chat_widget.dart';
import 'package:hifz_tracker/features/dashboard/widgets/home_widget.dart';
import 'package:hifz_tracker/features/dashboard/widgets/profile_widget.dart';
import 'package:image_picker/image_picker.dart';

import '../login/login_binding.dart';
import '../login/login_screen.dart';
import 'widgets/annoucement_widget.dart';

class DashboardController extends BaseController {
  final currentIndex = 0.obs;

  final Rx<Widget> currentWidget = Rx(const HomeWidget());
  final _widgets = <Widget>[
    const HomeWidget(),
    const ChatWidget(),
    // const AnnouncmentWidget(),
    const ProfileWidget()
  ];

  final loggedInUser = <String, dynamic>{}.obs;
  final selectedType = 'Hafalan'.obs;

  final historyDatas = <Map<String, dynamic>>[].obs;
  final progressDatas = <Map<String, dynamic>>[].obs;
  final surahs = <Map<String, dynamic>>[].obs;
  final chats = <Map<String, dynamic>>[].obs;

  DateTime selectedDate = DateTime.now();

  final updatePasswordLoading = false.obs;
  final updatePasswordKey = GlobalKey<FormState>();
  final updatePasswordOldCtr = TextEditingController();
  final updatePasswordCtr = TextEditingController();
  final updatePasswordConfirmCtr = TextEditingController();

  final updateEmailLoading = false.obs;
  final updateEmailKey = GlobalKey<FormState>();
  final updateEmailCtr = TextEditingController();
  final updateEmailPasswordCtr = TextEditingController();

  final teachers = <Map<String, dynamic>>[];
  String? userId = '';

  setWidget(int index) {
    currentIndex(index);
    currentWidget(_widgets[currentIndex.value]);
  }

  setSelectedDate({required DateTime dateTime}) {
    selectedDate = dateTime;

    getData();
  }

  getData() async {
    isLoading(true);

    final studentId = await Utils.readFromSecureStorage(key: Constants.token);
    final firestore = FirebaseUtils().firestore;
    final response = await firestore
        .collection(Constants.historyRef)
        .where('studentId', isEqualTo: studentId!)
        .where('type', isEqualTo: selectedType.value)
        .get();

    historyDatas.clear();
    progressDatas.clear();

    for (var element in response.docs) {
      final data = element.data();
      data['id'] = element.id;

      final fromAyat = int.parse(data['fromAyat']);
      final toAyat = int.parse(data['toAyat']);
      final ayatList = <int>[];

      for (var i = fromAyat; i <= toAyat; i++) {
        ayatList.add(i);
      }

      data['ayats'] = ayatList;

      progressDatas.add(data);
      final formattedDate =
          DateFormat('dd MMMM yyyy', 'id_ID').format(selectedDate);
      if (data['createdDate'] == formattedDate) {
        historyDatas.add(data);
      }
    }

    isLoading(false);
  }

  _initSurahs() async {
    final String response =
        await rootBundle.loadString('assets/files/surahs.json');
    final List<dynamic> data = await json.decode(response);

    for (var element in data) {
      surahs.add(element);
    }
  }

  double calculateProgress(Map<String, dynamic> surah) {
    final filteredHistory =
        progressDatas.where((p0) => p0['surah'] == surah['nama']).toList();

    if (filteredHistory.isEmpty) {
      return 0;
    }

    final rememberedAyats = <int>{};
    for (var element in filteredHistory) {
      element['ayats'].forEach((ayat) {
        rememberedAyats.add(ayat);
      });
    }

    final totalAyat = surah['ayat'];
    return (rememberedAyats.length / double.parse(totalAyat)) * 100;
  }

  logout() async {
    await FirebaseUtils().auth.signOut();
    Utils.clearSecureStorage();

    Get.offAll(
      () => const LoginScreen(),
      binding: LoginBinding(),
    );
  }

  //Change Image on Profile
  changeImage() async {
    final result = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (result != null) {
      isLoading(true);

      try {
        final currentUser = await getCurrentLoggedInUser();
        final response = await FirebaseUtils()
            .storeFile(currentUser['email'], File(result.path));
        final downloadUrl = await response.ref.getDownloadURL();

        await FirebaseUtils().updateDataToFirestore(
            collection: Constants.studentRef,
            docName: currentUser['id'],
            data: {'imageUrl': downloadUrl});

        currentUser['imageUrl'] = downloadUrl;
        setCurrentLoggedInUser(currentUser);

        isLoading(false);
      } catch (e) {
        isLoading(false);
        Utils.showGetSnackbar(e.toString(), false);
      }
    }
  }

  updatePassword() async {
    if (!updatePasswordKey.currentState!.validate()) return;
    if (updatePasswordCtr.text != updatePasswordConfirmCtr.text) {
      throw 'Password tidak sama!';
    }

    updatePasswordLoading(true);
    try {
      await FirebaseUtils().updatePassword(
        oldPassword: updatePasswordOldCtr.text,
        newPassword: updatePasswordConfirmCtr.text,
      );

      Get.back();

      updatePasswordLoading(false);
      Utils.showGetSnackbar('Password telah diubah!', true);
    } catch (e) {
      updatePasswordLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  updateEmail() async {
    if (!updateEmailKey.currentState!.validate()) return;

    updateEmailLoading(true);
    try {
      await FirebaseUtils().updateEmail(
        password: updateEmailPasswordCtr.text,
        newEmail: updateEmailCtr.text,
      );

      Get.back();

      final loggedInUsser = await getCurrentLoggedInUser();
      loggedInUser['email'] = updateEmailCtr.text;

      await FirebaseUtils().updateDataToFirestore(
          collection: Constants.studentRef,
          docName: loggedInUser['id'],
          data: {'email': updateEmailCtr.text});

      setCurrentLoggedInUser(loggedInUsser);

      updateEmailLoading(false);
      Utils.showGetSnackbar('Email telah diubah!', true);
    } catch (e) {
      updateEmailLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  _getTeachers() async {
    isLoading(true);

    try {
      final response = await FirebaseUtils()
          .getDataFromFirestore(collection: Constants.teacherRef);

      teachers.clear();
      for (var element in response.docs) {
        final data = element.data();
        data['id'] = element.id;

        teachers.add(data);
      }

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  getChats() async {
    isLoading(true);

    final studentId = await Utils.readFromSecureStorage(key: Constants.token);
    await _getTeachers();

    FirebaseUtils()
        .firestore
        .collection(Constants.chatRef)
        .where('studentId', isEqualTo: studentId)
        .orderBy('lastSent', descending: true)
        .snapshots()
        .listen((event) {
      isLoading(false);
      chats.clear();
      for (var element in event.docs) {
        final data = element.data();
        data['id'];

        final teacherData = teachers
            .firstWhere((teacher) => teacher['id'] == data['teacherId']);
        data['teacherData'] = teacherData;

        chats.add(data);
      }
    }).onError((e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    });
  }

  @override
  void onInit() async {
    loggedInUser(await getCurrentLoggedInUser());
    userId = await getUserId();

    await getData();
    await _initSurahs();

    super.onInit();
  }
}
