import 'package:hifz_tracker/core_imports.dart';
import 'package:hifz_tracker/features/history/history_controller.dart';

import '../score_detail/score_detail_binding.dart';
import '../score_detail/score_detail_screen.dart';

class HistoryScreen extends GetView<HistoryController> {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.transparent(
        titleWidget: Obx(
          () => Text('Riwayat ${controller.type.value}'),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: RefreshIndicator(
          child: Obx(
            () => controller.isLoading.value
                ? const ShimmerListWidget()
                : ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: controller.historyDatas.length,
                    itemBuilder: (context, index) => _buildHistoryItem(index),
                  ),
          ),
          onRefresh: () => controller.getHistories(),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(int index) {
    final data = controller.historyDatas[index];

    return data['type'] == 'date'
        ? Text(data['date'])
        : Container(
            padding: const EdgeInsets.all(16),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data['surah']}',
                        style: CustomTextStyle.black16w700(),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ayat ${data['ayats'].join(', ')}',
                        style: CustomTextStyle.black(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Jam ${Utils.formatDateFromMillis(pattern: 'HH:mm', millis: data['createdAt'])}'
                        ' WIB',
                        maxLines: 1,
                        style: CustomTextStyle.grey10w400(),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const Text('Nilai'),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: CustomColor.primaryColor,
                      ),
                      child: Text(
                        data['score'],
                        style: CustomTextStyle.white(),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => Get.to(() => const ScoreDetailScreen(),
                      binding: ScoreDetailBinding(),
                      arguments: {'title': data['surah'], 'history': data}),
                  child: const Icon(Icons.arrow_forward_ios),
                )
              ],
            ),
          );
  }
}
