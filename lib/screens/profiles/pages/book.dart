import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';

class Book extends StatelessWidget {
  final ScrollController scrollController;
  final Map details;
  const Book({super.key, required this.scrollController, required this.details});

  @override
  Widget build(BuildContext context) {
    List viewBookFields = [
      {"type": "flutterText", "title": translate(context).book_information},
      {"type": "text", "value": details["id"].toString(), "title": translate(context).serial_number},
      {"type": "text", "value": details["name"] ?? translate(context).not_available, "title": translate(context).book_name},
      {
        "type": "oneSelection",
        "value": details["size"] ?? translate(context).not_available,
        "title": translate(context).book_size,
        "selections": ["A4", "A5"]
      },
      {
        "type": "oneSelection",
        "value": details["type"] ?? translate(context).not_available,
        "title": translate(context).activity_type,
        "selections": [translate(context).cultural, translate(context).methodological]
      },
      {"type": "text", "value": details["author_name"] ?? translate(context).not_available, "title": translate(context).book_author},
      {"type": "number", "value": details["paper_count"] ?? translate(context).not_available, "title": translate(context).book_pages_count},
      {"type": "text", "value": details["property_type"] ?? translate(context).not_available, "title": translate(context).center_type},
    ];
    FirebaseAnalytics.instance.logEvent(
      name: 'book_profile_page',
      parameters: {
        'screen_name': "book_profile_page",
        'screen_class': "profile",
      },
    );

    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 0, bottom: 4),
      child: TextFieldFor(
          fields: viewBookFields, deleteOnTap: () {}, galleryOnTap: () {}, cameraOnTap: () {}, scrollController: scrollController, readOnly: true),
    ));
  }
}
