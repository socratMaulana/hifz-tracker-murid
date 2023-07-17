import 'package:hifz_tracker/core_imports.dart';
import 'package:hifz_tracker/features/score_detail_surah/score_detail_surah_binding.dart';
import 'package:hifz_tracker/features/score_detail_surah/score_detail_surah_screen.dart';

class SurahScreen extends StatelessWidget {
  final List<Map<String, dynamic>> historyDatas;
  final List<Map<String, dynamic>> surahs;

  const SurahScreen(
      {super.key, required this.historyDatas, required this.surahs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.transparent(
        title: 'Surah',
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemCount: surahs.length,
          itemBuilder: (context, index) {
            final surah = surahs[index];

            return InkWell(
              onTap: () => Get.to(
                () => const ScoreDetailSurahScreen(),
                binding: ScoreDetailSurahBinding(),
                arguments: {'surah': surah, 'histories': historyDatas},
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
                      value: calculateProgress(surah) / 100,
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${calculateProgress(surah) == 0 ? '0' : calculateProgress(surah).toStringAsFixed(0)}'
                          '%',
                          style: CustomTextStyle.black5412w400(),
                        ),
                        Visibility(
                          visible: calculateProgress(surah) == 100,
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
          },
        ),
      ),
    );
  }

  double calculateProgress(Map<String, dynamic> surah) {
    final filteredHistory =
        historyDatas.where((p0) => p0['surah'] == surah['nama']).toList();

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
}
