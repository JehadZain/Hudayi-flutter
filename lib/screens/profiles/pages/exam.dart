import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:hudayi/ui/widgets/page_Header.dart';
import 'package:image_picker/image_picker.dart';

class Exam extends StatelessWidget {
  final ScrollController scrollController;
  final Map details;
  const Exam(
      {super.key, required this.scrollController, required this.details});

  @override
  Widget build(BuildContext context) {
    List viewExamFields = [
      {
        "type": "text",
        "value": details["id"].toString(),
        "title": translate(context).serial_number
      },
      {
        "type": "text",
        "value": details["name"]?.split(",")[0],
        "title": translate(context).testName
      },
      {
        "type": "text",
        "value": details["quiz_subject"],
        "title": translate(context).testSubject
      },
      {
        "type": "date",
        "value": details["date"],
        "title": translate(context).testDate
      },
      {
        "type": "time",
        "value": details["time"],
        "title": translate(context).testTime
      },
      {
        "type": "oneSelection",
        "value": details["type"],
        "title": translate(context).testType,
        "selections": [
          translate(context).pedagogical,
          translate(context).curriculum,
          translate(context).correctArabicReading
        ]
      },
      {
        "type": "text",
        "value": details["score"],
        "title": translate(context).testResult
      },
    ];
    FirebaseAnalytics.instance.logEvent(
      name: 'exam_student_profile_page',
      parameters: {
        'screen_name': "exam_student_profile_page",
        'screen_class': "profile",
      },
    );
    return Expanded(
      child: Column(
        children: [
          PageHeader(
            path: XFile(""),
            title: translate(context).testInformation,
            isCircle: false,
            checkedValue: "noDialog",
          ),
          Expanded(
              child: Padding(
            padding:
                const EdgeInsets.only(left: 8.0, right: 8, top: 0, bottom: 4),
            child: TextFieldFor(
                fields: viewExamFields,
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
