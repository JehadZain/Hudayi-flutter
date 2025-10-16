import 'package:hudayi/ui/helper/app_consts.dart';

class Thekr {
  late final String id;
  late final String text;
  late final String sectionName;
  late final int section;
  late final List athkar;

  late final bool isTitle;
  late bool isFav;

  late int counter;

  final HudayiCategory category = HudayiCategory.athkar;

  Thekr._(
    this.id,
    this.text,
    this.counter,
    this.isTitle,
    this.section,
    this.athkar,
    this.isFav, {
    this.sectionName = '',
  }) : super();

  factory Thekr.fromMap(Map<String, dynamic> map) => Thekr._(
        map['id'] ?? '',
        map['text'] ?? '',
        map['counter'] ?? 0,
        map['isTitle'] ?? false,
        map['section'] ?? 0,
        map["athkar"] ?? [],
        map['isFav'] ?? false,
        sectionName: map['sectionName'] ?? '',
      );

  factory Thekr.title(Map<String, dynamic> map) => Thekr._(
        '',
        map['text'] as String,
        map['counter'] as int,
        map['isTitle'] as bool,
        map['section'] as int,
        map["athkar"] ?? [],
        false,
        sectionName: map['sectionName'] ?? '',
      );
}
