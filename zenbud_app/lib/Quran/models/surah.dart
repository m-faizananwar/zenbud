// To parse this JSON data, do
//
//     final surah = surahFromJson(jsonString);

import 'dart:convert';

import 'package:Zenbud/Quran/models/ayat.dart';

List<Surah> surahFromJson(String str) => List<Surah>.from(json.decode(str).map((x) => Surah.fromJson(x)));

String surahToJson(List<Surah> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Surah {
  Surah({required this.number, required this.name, required this.latinName, required this.totalAyat, required this.revelationPlace, required this.meaning, required this.description, required this.audio, this.ayat});

  late int number;
  late String name;
  late String latinName;
  late int totalAyat;
  late RevelationPlace revelationPlace;
  late String meaning;
  late String description;
  late String audio;
  late List<Ayat>? ayat;

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(number: json["nomor"], name: json["nama"], latinName: json["nama_latin"], totalAyat: json["jumlah_ayat"], revelationPlace: revelationPlaceValues.map[json["tempat_turun"]]!, meaning: json["arti"], description: json["deskripsi"], audio: json["audio"], ayat: json.containsKey('ayat') ? List<Ayat>.from(json["ayat"]!.map((x) => Ayat.fromJson(x))) : null);

  Map<String, dynamic> toJson() => {
        "nomor": number,
        "nama": name,
        "nama_latin": latinName,
        "jumlah_ayat": totalAyat,
        "tempat_turun": revelationPlaceValues.reverse[revelationPlace],
        "arti": meaning,
        "deskripsi": description,
        "audio": audio,
        "ayat": ayat != null ? List<dynamic>.from(ayat!.map((e) => e.toJson())) : []
      };
}

enum RevelationPlace {
  MECCA,
  MEDINA
}

final revelationPlaceValues = EnumValues({
  "mekah": RevelationPlace.MECCA,
  "madinah": RevelationPlace.MEDINA
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => new MapEntry(v, k));
    return reverseMap;
  }
}
