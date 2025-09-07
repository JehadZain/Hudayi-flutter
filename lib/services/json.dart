import 'dart:convert';

import 'package:flutter/services.dart';

class JsonService {
  JsonService._();
  static JsonService instance = JsonService._();

  Future<List<dynamic>> init() async {
    List<String> files = <String>[
      'assets/json/1_athkar.json',
      'assets/json/2_quraan_ad3yah.json',
      'assets/json/3_sunnah_ad3yah.json',
      'assets/json/4_ruqiya.json',
      'assets/json/6_allah_names.json',
    ];
    final List<dynamic> content = <dynamic>[];
    for (String f in files) {
      final String load = await rootBundle.loadString(f);
      final dynamic decode = json.decode(load);

      content.add(decode);
    }

    return content;
  }

  Future<List<String>> loadDefaultSubhaList() async {
    return json.decode(await rootBundle.loadString('assets/json/default_subha_list.json'))['default'].cast<String>().toList();
  }
}
