class Ayat {
  Ayat({
    required this.id,
    required this.surahNumber,
    required this.verseNumber,
    required this.arabicText,
    required this.translation,
    required this.indonesianTranslation,
  });

  late int id;
  late int surahNumber;
  late int verseNumber;
  late String arabicText;
  late String translation;
  late String indonesianTranslation;

  factory Ayat.fromJson(Map<String, dynamic> json) => Ayat(
        id: json["id"],
        surahNumber: json["surah"],
        verseNumber: json["nomor"],
        arabicText: json["ar"],
        translation: json["tr"],
        indonesianTranslation: json["idn"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "surah": surahNumber,
        "nomor": verseNumber,
        "ar": arabicText,
        "tr": translation,
        "idn": indonesianTranslation,
      };
}
