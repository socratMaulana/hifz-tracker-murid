import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:hifz_tracker/core_imports.dart';
import 'package:hifz_tracker/features/dashboard/dashboard_controller.dart';
import 'package:hifz_tracker/features/history/history_screen.dart';
import 'package:hifz_tracker/features/score_detail/score_detail_binding.dart';
import 'package:hifz_tracker/features/score_detail/score_detail_screen.dart';
import 'package:hifz_tracker/features/surahs/surah_screen.dart';

import '../../history/history_binding.dart';
import '../../score_detail_surah/score_detail_surah_binding.dart';
import '../../score_detail_surah/score_detail_surah_screen.dart';

class HomeWidget extends GetView<DashboardController> {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: RefreshIndicator(
        onRefresh: () => controller.getData(),
        child: ListView(
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            Obx(
              () => Row(
                children: [
                  _buildChip(label: 'Hafalan'),
                  const SizedBox(width: 16),
                  _buildChip(label: 'Murroja\'ah'),
                  const Spacer(),
                  InkWell(
                    onTap: () => Get.to(
                      () => const HistoryScreen(),
                      binding: HistoryBinding(),
                      arguments: controller.selectedType.value,
                    ),
                    child: Text(
                      'Lihat Semua',
                      style: CustomTextStyle.primary(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // CustomTextFormField(
            //   width: MediaQuery.of(context).size.width * .4,
            //   textEditingController: controller.dateCtr,
            //   prefixIcon: const Icon(Icons.calendar_month_outlined),
            //   readOnly: true,
            //   onTap: () => _showMonthPicker(context: context),
            // ),
            CalendarTimeline(
              initialDate: controller.selectedDate,
              firstDate: DateTime(2019, 1, 15),
              lastDate: DateTime(2050),
              onDateSelected: (date) =>
                  controller.setSelectedDate(dateTime: date),
              leftMargin: 20,
              monthColor: Colors.black54,
              dayColor: Colors.black54,
              activeDayColor: Colors.white,
              activeBackgroundDayColor: CustomColor.primaryColor,
              dotsColor: Colors.white,
              selectableDayPredicate: (date) => date.day != 23,
              locale: 'id',
            ),
            const SizedBox(height: 16),
            Obx(
              () => controller.isLoading.value
                  ? const ShimmerListWidget()
                  : controller.historyDatas.isEmpty
                      ? const EmptyWidget()
                      : Column(
                          children: controller.historyDatas
                              .map(
                                (element) => _buildHistoryItem(element),
                              )
                              .toList(),
                        ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Surah Al - Quran',
                  style: CustomTextStyle.black15w700(),
                ),
                InkWell(
                  onTap: () => Get.to(
                    () => SurahScreen(
                        historyDatas: controller.progressDatas,
                        surahs: controller.surahs),
                  ),
                  child: Text(
                    'Lihat semua',
                    style: CustomTextStyle.primary(),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Obx(
              () => controller.surahs.isEmpty
                  ? const EmptyWidget()
                  : Column(
                      children: controller.surahs
                          .take(3)
                          .map(
                            (element) => _buildSurahItem(element),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(
      () => Row(
        children: [
          CircleAvatar(
            backgroundColor: CustomColor.primaryColor,
            child: controller.userController.loggedInUser['imageUrl'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: CustomImageNetwork(
                        imageUrl:
                            controller.userController.loggedInUser['imageUrl']),
                  )
                : const Icon(Icons.person_outline),
          ),
          const SizedBox(width: 16),
          Text(
            controller.userController.loggedInUser['fullName'] ?? '',
            style: CustomTextStyle.black15w400(),
          ),
          // const Spacer(),
          // InkWell(
          //   onTap: () => controller.logout(),
          //   child: const Icon(Icons.exit_to_app),
          // )
        ],
      ),
    );
  }

  ChoiceChip _buildChip({required String label}) {
    return ChoiceChip(
      label: Text(
        label,
        style: controller.selectedType.value == label
            ? CustomTextStyle.white()
            : CustomTextStyle.black(),
      ),
      selected: controller.selectedType.value == label,
      onSelected: (value) {
        controller.selectedType(label);
        controller.getData();
      },
      selectedColor: CustomColor.primaryColor,
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> history) {
    return Container(
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
                  '${history['surah']}',
                  style: CustomTextStyle.black16w700(),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ayat ${history['ayats'].join(', ')}',
                  style: CustomTextStyle.black(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Text(
                  'Jam ${Utils.formatDateFromMillis(pattern: 'HH:mm', millis: history['createdAt'])}'
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
                  history['score'],
                  style: CustomTextStyle.white(),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () => Get.to(() => const ScoreDetailScreen(),
                binding: ScoreDetailBinding(),
                arguments: {'title': history['surah'], 'history': history}),
            child: const Icon(Icons.arrow_forward_ios),
          )
        ],
      ),
    );
  }

  Widget _buildSurahItem(Map<String, dynamic> surah) {
    return InkWell(
      onTap: () => Get.to(
        () => const ScoreDetailSurahScreen(),
        binding: ScoreDetailSurahBinding(),
        arguments: {'surah': surah, 'histories': controller.progressDatas},
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${surah['nama']}',
              style: CustomTextStyle.black16w700(),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: controller.calculateProgress(surah) / 100,
              backgroundColor: Colors.grey,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${controller.calculateProgress(surah) == 0 ? '0' : controller.calculateProgress(surah).toStringAsFixed(0)}'
                  '%',
                  style: CustomTextStyle.black5412w400(),
                ),
                Visibility(
                  visible: controller.calculateProgress(surah) == 100,
                  child: Text(
                    'Completed',
                    style: CustomTextStyle.black5412w400(),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // _showMonthPicker({required BuildContext context}) async {
  //   final initialDate =
  //       DateFormat('MMM yyyy', 'id_ID').parse(controller.dateCtr.text);
  //   final selectedDate = await showMonthYearPicker(
  //     context: context,
  //     initialDate: initialDate,
  //     firstDate: DateTime(1990),
  //     lastDate: DateTime.now(),
  //     builder: (context, child) => Theme(data: appTheme, child: child!),
  //   );
  //   if (selectedDate != null) {
  //     final formattedDate =
  //         DateFormat('MMM yyyy', 'id_ID').format(selectedDate);
  //     controller.dateCtr.text = formattedDate;
  //   }
  // }
}
