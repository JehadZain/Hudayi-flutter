import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/widgets/pageHeader.dart';
import 'package:image_picker/image_picker.dart';

class QuranProfile extends StatelessWidget {
  final ScrollController scrollController;
  final Map details;
  const QuranProfile({super.key, required this.scrollController, required this.details});

  @override
  Widget build(BuildContext context) {
    List viewQuranFields = [
      {"type": "text", "value": details["id"].toString(), "title": translate(context).serial_number},
      {"type": "text", "value": details["juz"], "title": translate(context).juz, "selections": List<int>.generate(30, (i) => i + 1)},
      {"type": "text", "value": details["page"], "title": translate(context).page, "selections": []},
      {"type": "date", "value": details["date"], "title": translate(context).recitationDate},
      {
        "type": "oneSelection",
        "value": details["examiner"],
        "title": translate(context).laboratory,
        "selections": ["عامر", "علي", "الأستاذ أحمد"]
      },
      {
        "type": "oneSelection",
        "value": details["type"],
        "title": translate(context).recitationType,
        "selections": [translate(context).saved, translate(context).readFromQuran, translate(context).correctArabicReading]
      },
      {
        "type": "oneSelection",
        "value": "${details["score"]}",
        "title": translate(context).recitationGrade,
        "selections": [translate(context).excellent, translate(context).veryGood, translate(context).good, translate(context).fail]
      },
    ];
    FirebaseAnalytics.instance.logEvent(
      name: 'quran_student_profile_page',
      parameters: {
        'screen_name': "quran_student_profile_page",
        'screen_class': "profile",
      },
    );
    return Expanded(
      child: Column(
        children: [
          PageHeader(
            path: XFile(""),
            title: translate(context).recitationInformation,
            isCircle: false,
            checkedValue: "noDialog",
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 0, bottom: 4),
            child: TextFieldFor(
                fields: viewQuranFields,
                deleteOnTap: () {},
                galleryOnTap: () {},
                cameraOnTap: () {},
                scrollController: scrollController,
                readOnly: true),
          )),
        ],
      ),
    );
  }
}
