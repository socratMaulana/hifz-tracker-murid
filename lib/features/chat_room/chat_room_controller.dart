import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hifz_tracker/core_imports.dart';

class ChatRoomController extends BaseController {
  final chats = <dynamic>[].obs;
  final showSendIcon = false.obs;

  final messageCtr = TextEditingController();
  final teacherData = <String, dynamic>{}.obs;

  String? userId = '';

  getChats() async {
    isLoading(true);

    final studentId = await Utils.readFromSecureStorage(key: Constants.token);

    FirebaseUtils()
        .firestore
        .collection(Constants.chatRef)
        .doc('$studentId${teacherData['id']}')
        .snapshots()
        .listen((event) {
      isLoading(false);

      this.chats.clear();
      String currentDate = Utils.getCurrentDateddMMMMyyyy();

      final data = event.data();
      if (data == null) return;

      data['id'];

      final List<dynamic> chats = data['chats'];
      for (var element in chats) {
        final sentDate = Utils.formatDateFromMillis(
            millis: element['sendAt'], pattern: 'dd MMMM yyyy');

        bool showDate = false;
        if (currentDate != sentDate) {
          showDate = true;
          currentDate = sentDate;
        } else {
          showDate = false;
        }

        element['showDate'] = showDate;
      }

      this.chats(chats);

      bool isUnreadExist = false;
      for (var element in chats) {
        if (element['status'] == 'unread' && element['sendBy'] != userId) {
          isUnreadExist = true;
          element['status'] = 'read';
        }
      }

      if (isUnreadExist) {
        FirebaseUtils()
            .firestore
            .collection(Constants.chatRef)
            .doc('$studentId${teacherData['id']}')
            .update({'chats': chats});
      }
    }).onError((e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    });
  }

  sendChat() async {
    final studentId = await Utils.readFromSecureStorage(key: Constants.token);

    try {
      final firestore = FirebaseUtils().firestore;
      final chatRef = firestore.collection(Constants.chatRef);
      final doc = chatRef.doc('$studentId${teacherData['id']}');

      await doc.set(
        {
          'studentId': studentId,
          'teacherId': teacherData['id'],
          'lastSent': DateTime.now(),
          'chats': FieldValue.arrayUnion([
            {
              'message': messageCtr.text,
              'sendBy': studentId,
              'sendAt': DateTime.now().millisecondsSinceEpoch,
              'status': 'unread'
            }
          ]),
        },
        SetOptions(merge: true),
      );
      // await FirebaseUtils().updateDataToFirestore(
      //     collection: Constants.chatRef,
      //     docName: '$studentId${teacherData['id']}',
      //     data: {
      //       'studentId': studentId,
      //       'teacherId': teacherData['id'],
      //       'message': messageCtr.text,
      //       'sendBy': studentId,
      //       'sendAt': DateTime.now().millisecondsSinceEpoch
      //     });

      messageCtr.clear();
    } catch (e) {
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  @override
  void onInit() async {
    userId = await getUserId();
    teacherData(Get.arguments);
    await getChats();
    super.onInit();
  }
}
