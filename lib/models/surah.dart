class Surah {
  int? id;
  String? revelationPlace;
  int? revelationOrder;
  String? name;
  String? arabicName;
  int? versesCount;
  int startPage;
  Surah({
    this.arabicName,
    this.id,
    this.name,
    this.revelationOrder,
    this.revelationPlace,
    this.versesCount,
    required this.startPage,
  });
  factory Surah.fromMap(Map<String, dynamic> json) {
    return Surah(
      id: int.parse(json["index"].toString().replaceAll("0", "")),
      revelationPlace: json["type"],
      versesCount: json["count"],
      arabicName: json["titleAr"],
      name: json["title"],
      startPage: int.parse(json["pages"]),
    );
  }
}
