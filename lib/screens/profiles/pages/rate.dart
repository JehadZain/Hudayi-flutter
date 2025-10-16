import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';

class Rates extends StatelessWidget {
  final ScrollController scrollController;
  final Map details;
  const Rates({super.key, required this.scrollController, required this.details});

  @override
  Widget build(BuildContext context) {
    List viewRatesFields = [
      {"type": "flutterText", "title": translate(context).teacherEvaluation},
      {"type": "text", "value": details["teacher_id"].toString(), "title": translate(context).teacherCount, "readOnly": true},
      {
        "type": "text",
        "value": "${details["teacher"]?["first_name"]} ${details["teacher"]?["last_name"]}",
        "title": translate(context).teacherName,
        "readOnly": true
      },
      {
        "type": "text",
        "value": "${details["admin"]?["user"]["first_name"]} ${details["admin"]?["user"]["last_name"]}",
        "title": translate(context).supervisor,
        "readOnly": true
      },
      {"type": "text", "value": details["date_1"], "title": translate(context).date, "readOnly": true},
      {"type": "flutterText", "title": translate(context).visitTime},
      {"type": "time", "value": details["start_date"], "title": translate(context).start_time},
      {"type": "time", "value": details["end_date"], "title": translate(context).end_time},
      {"type": "flutterText", "title": translate(context).lessons},
      {"type": "number", "value": details["correct_reading_skill"], "title": translate(context).correctArabicReadingScoreOutOf10},
      {"type": "number", "value": details["teaching_skill"], "title": translate(context).memorizationScoreOutOf10},
      {"type": "number", "value": details["academic_skill"], "title": translate(context).scientificLessonScoreOutOf10},
      {"type": "number", "value": details["following_skill"], "title": translate(context).individualFollowUpTimeScoreOutOf10},
      {"type": "flutterText", "title": translate(context).circleManagement},
      {"type": "number", "value": details["plan_commitment"], "title": translate(context).adherenceToPlanScoreOutOf10},
      {"type": "number", "value": details["time_commitment"], "title": translate(context).punctualityScoreOutOf10},
      {"type": "number", "value": details["student_commitment"], "title": translate(context).studentDisciplineScoreOutOf10},
      {"type": "flutterText", "title": translate(context).activities},
      {"type": "number", "value": details["activity"], "title": translate(context).activitiesScoreOutOf10},
      {"type": "flutterText", "title": translate(context).administrativeDiscipline},
      {
        "type": "number",
        "value": details["commitment_to_administrative_instructions"],
        "title": translate(context).administrativeDisciplineScoreOutOf10
      },
      {"type": "flutterText", "title": translate(context).tests},
      {"type": "number", "value": details["exam_and_quizzes"], "title": translate(context).testsAndStudyScoreOutOf10},
      {"type": "flutterText", "title": translate(context).total},
      {"type": "number", "value": details["score"], "title": translate(context).total},
      {"type": "flutterText", "title": translate(context).percentage},
      {"type": "number", "value": details["percentage"], "title": translate(context).percentage},
      {"type": "flutterText", "title": translate(context).notes},
      {"type": "description", "value": details["note"], "title": translate(context).notes},
      {"type": "number", "value": details["student_count"], "title": translate(context).studentsCount},
    ];
    FirebaseAnalytics.instance.logEvent(
      name: 'rates_profile_page',
      parameters: {
        'screen_name': "admin_profile_page",
        'screen_class': "profile",
      },
    );
    return Expanded(
      child: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 0, bottom: 4),
            child: TextFieldFor(
                fields: viewRatesFields,
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
