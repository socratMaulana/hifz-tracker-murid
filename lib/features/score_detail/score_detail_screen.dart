import 'package:hifz_tracker/core_imports.dart';
import 'package:hifz_tracker/features/score_detail/score_detail_controller.dart';

class ScoreDetailScreen extends GetView<ScoreDetailController> {
  const ScoreDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.transparent(
          title: 'Detail Penilaian', centerTitle: true),
      body: Obx(
        () => controller.isLoading.value ? const ShimmerDetail() : _buildItem(),
      ),
    );
  }

  Widget _buildItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomColor.primaryColor.withAlpha(50),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            controller.title,
            style: CustomTextStyle.black20w400(),
          ),
          const SizedBox(height: 16),
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
                      '${Utils.formatDateFromMillis(millis: controller.history['createdAt'], pattern: 'dd MMMM yyyy')}\n'
                      'Jam ${Utils.formatDateFromMillis(millis: controller.history['createdAt'], pattern: 'HH:mm')} WIB',
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
                      '${controller.history['ayats'].join(', ')}',
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
                        controller.teacher['imageUrl'] == null
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
                                imageUrl: controller.teacher['imageUrl'],
                                width: 48,
                                height: 48,
                                radius: 99,
                              ),
                        const SizedBox(width: 8),
                        Text(
                          controller.teacher['fullName'],
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
                        controller.history['score'],
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
            child: Text(controller.history['review']),
          )
        ],
      ),
    );
  }
}
