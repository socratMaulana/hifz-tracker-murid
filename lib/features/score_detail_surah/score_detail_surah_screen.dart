import 'package:hifz_tracker/core_imports.dart';
import 'package:hifz_tracker/features/score_detail_surah/score_detail_surah_controller.dart';
import 'package:hifz_tracker/features/surah_detail/surah_detail_screen.dart';

class ScoreDetailSurahScreen extends GetView<ScoreDetailSurahController> {
  const ScoreDetailSurahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.transparent(
          title: 'Detail Penilaian ${controller.histories.first['type']}',
          centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Obx(
            () => Text(
              controller.surah['nama'],
              style: CustomTextStyle.black20w400(),
            ),
          ),
          InkWell(
            onTap: () => Get.to(
              () => SurahDetailScreen(
                  surah: controller.surah, histories: controller.histories),
            ),
            child: Text(
              'Lihat Semua',
              style: CustomTextStyle.primary(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? const ShimmerListWidget()
                  : controller.histories.isEmpty
                      ? const EmptyWidget()
                      : ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemCount: controller.histories.length,
                          itemBuilder: (context, index) =>
                              _buildListItem(index),
                        ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListItem(int index) {
    final history = controller.histories[index];
    final teacher = controller.getTeacher(history['teacherId']);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomColor.primaryColor.withAlpha(50),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tanggal Setoran',
                      style: CustomTextStyle.black5414w700(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${Utils.formatDateFromMillis(millis: history['createdAt'], pattern: 'dd MMMM yyyy')}\n'
                      'Jam ${Utils.formatDateFromMillis(millis: history['createdAt'], pattern: 'HH:mm')} WIB',
                      style: CustomTextStyle.black5412w400(),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ayat Al-Quran',
                      style: CustomTextStyle.black5414w700(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${history['ayats'].join(', ')}',
                      style: CustomTextStyle.black5412w400(),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Musyrif',
                      style: CustomTextStyle.black5414w700(),
                    ),
                    const SizedBox(height: 8),
                    Row(
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
                                ),
                              )
                            : CustomImageNetwork(
                                imageUrl: teacher['imageUrl'],
                                width: 48,
                                height: 48,
                                radius: 99,
                              ),
                        const SizedBox(width: 8),
                        Text(
                          teacher['fullName'],
                          style: CustomTextStyle.black5412w400(),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Nilai',
                      style: CustomTextStyle.black5414w700(),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: CustomColor.primaryColor,
                      ),
                      child: Text(
                        history['score'],
                        style: CustomTextStyle.white(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Review',
            style: CustomTextStyle.black5414w700(),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(history['review']),
          )
        ],
      ),
    );
  }
}
