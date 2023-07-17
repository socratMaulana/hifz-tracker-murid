import 'package:hifz_tracker/core_imports.dart';
import 'package:hifz_tracker/features/chat_room/chat_room_screen.dart';

import '../chat_room/chat_room_binding.dart';
import 'new_chat_controller.dart';

class NewChatScreen extends GetView<NewChatController> {
  const NewChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.transparent(title: 'Pilih Guru', centerTitle: true),
      body: Obx(
        () => controller.isLoading.value
            ? const ShimmerListWidget()
            : controller.teachers.isEmpty
                ? const EmptyWidget()
                : ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8,
                    ),
                    itemCount: controller.teachers.length,
                    itemBuilder: (context, index) =>
                        _buildListItem(index: index),
                  ),
      ),
    );
  }

  InkWell _buildListItem({required int index}) {
    final teacher = controller.teachers[index];

    return InkWell(
      onTap: () => Get.to(
        () => const ChatRoomScreen(),
        binding: ChatRoomBinding(),
        arguments: teacher,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0x14A1A1A1),
              spreadRadius: 1,
              blurRadius: 16,
              offset: Offset(0, 7), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            teacher['imageUrl'] == null
                ? Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                        color: CustomColor.primaryColor,
                        shape: BoxShape.circle),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 16,
                    ))
                : CustomImageNetwork(
                    imageUrl: teacher['imageUrl'],
                    width: 48,
                    height: 48,
                    radius: 99,
                  ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${teacher['fullName']}',
                  style: CustomTextStyle.black14w700(),
                ),
                const SizedBox(height: 2),
                Text(
                  'Username: ${teacher['username']}',
                  style: CustomTextStyle.grey12w400(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
