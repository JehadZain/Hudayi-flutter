import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';

class Interview extends StatelessWidget {
  final ScrollController scrollController;
  final Map details;
  const Interview(
      {super.key, required this.scrollController, required this.details});

  @override
  Widget build(BuildContext context) {
    List viewInterviewFields = [
      {
        "type": "text",
        "value": details["id"].toString(),
        "title": translate(context).serial_number
      },
      {
        "type": "text",
        "value": details["name"],
        "title": translate(context).interviewName
      },
      {
        "type": "text",
        "value": details["goal"],
        "title": translate(context).interviewReason
      },
      {
        "type": "text",
        "value": details["event_place"],
        "title": translate(context).interviewLocation
      },
      {
        "type": "date",
        "value": details["date"].split(" / ")[0],
        "title": translate(context).interviewDate
      },
      {
        "type": "date",
        "value": details["time"],
        "title": translate(context).interviewTime
      },
      {
        "type": "date",
        "value": details["date"].split(" / ")[1],
        "title": translate(context).interviewer
      },
      {
        "type": "oneSelection",
        "value": details["type"] == "book"
            ? translate(context).book
            : details["type"],
        "title": translate(context).interviewType,
        "selections": [translate(context).pedagogical]
      },
      {
        "type": "number",
        "value": details["score"],
        "title": translate(context).interviewScore
      },
      {
        "type": "description",
        "value": details["comment"],
        "title": translate(context).interviewResult
      },
    ];
    if (details["student"] != null &&
        viewInterviewFields[6]["title"] != translate(context).studentName) {
      viewInterviewFields.insert(
        6,
        {
          "type": "text",
          "value": details["student"],
          "title": translate(context).studentName
        },
      );
    }
    FirebaseAnalytics.instance.logEvent(
      name: 'interview_student_profile_page',
      parameters: {
        'screen_name': "interview_student_profile_page",
        'screen_class': "profile",
      },
    );
    return Expanded(
      child: Column(
        children: [
          // PageHeader(
          //   path: XFile(""),
          //   title: "معلومات المقابلة",
          //   isCircle: false,
          //   checkedValue: "noDialog",
          // ),
          Expanded(
              child: Padding(
            padding:
                const EdgeInsets.only(left: 8.0, right: 8, top: 0, bottom: 4),
            child: TextFieldFor(
                fields: viewInterviewFields,
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
