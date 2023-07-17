import 'package:hifz_tracker/core_imports.dart';

class SurahDetailScreen extends StatelessWidget {
  final Map<String, dynamic> surah;
  final List<Map<String, dynamic>> histories;

  const SurahDetailScreen(
      {super.key, required this.surah, required this.histories});

  @override
  Widget build(BuildContext context) {
    final memorizedAyat = <int>{};
    //tambah ayat yang kurang lancar
    final unmemorizedAyat = <int>{};

    //cek jika ayat sudah lancar atau belum, lalu looping
    for (var element in histories) {
      final ayats = element['ayats'];
      ayats.forEach((ayat) {
        if (element["isFluent"]) {
          memorizedAyat.add(ayat);
        } else {
          unmemorizedAyat.add(ayat);
        }
      });
    }

    return Scaffold(
      appBar: CustomAppbar.transparent(
          title: 'Detail ${histories.first['type']} Surah', centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                surah['nama'],
                style: CustomTextStyle.black20w400(),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 24),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CustomColor.primaryColor.withAlpha(50),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    int.parse(surah['ayat']),
                    (index) => Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          color: unmemorizedAyat.contains(index + 1)
                              ? memorizedAyat.contains(index + 1)
                                  ? CustomColor.primaryColor
                                  : CustomColor.errorColor
                              : memorizedAyat.contains(index + 1)
                                  ? CustomColor.primaryColor
                                  : Colors.transparent,
                          shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            color: memorizedAyat.contains(index + 1) ||
                                    unmemorizedAyat.contains(index + 1)
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              CustomElevatedButton(
                text: 'Kembali',
                onPressed: () => Get.back(),
                borderRadius: 16,
              ),
              const SizedBox(height: 32)
            ],
          ),
        ),
      ),
    );
  }
}
