import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';

class Activity extends StatelessWidget {
  final ScrollController scrollController;
  final Map activityDetails;
  const Activity({super.key, required this.scrollController, required this.activityDetails});

  @override
  Widget build(BuildContext context) {
    List participants = activityDetails["participants"] ?? [];
    String participant = participants.map((e) => '${e["student"]["user"]["first_name"]} ${e["student"]["user"]["last_name"]}').toList().join("  ,");

    FirebaseAnalytics.instance.logEvent(
      name: 'activity_profile_page',
      parameters: {
        'screen_name': "activity_profile_page",
        'screen_class': "profile",
      },
    );

    List viewActivityFields = [
      {"type": "flutterText", "title": translate(context).activity_information},
      {"type": "text", "value": activityDetails["id"].toString(), "title": translate(context).serial_number},
      {"type": "text", "value": activityDetails["name"], "title": translate(context).activity_name},
      {"type": "description", "value": activityDetails["description"], "title": translate(context).activity_description},
      {"type": "text", "value": activityDetails["place"], "title": translate(context).activity_location},
      {"type": "date", "value": activityDetails["date"], "title": translate(context).activity_date},
      {"type": "number", "value": activityDetails["cost"], "title": translate(context).activity_cost},
      {"type": "number", "value": activityDetails["type"], "title": translate(context).activity_type},
      {
        "type": "multipleSelection",
        "value": participant,
        "title": translate(context).present_students,
        "selections": [],
      },
      {
        "type": "multipleSelection",
        "value": activityDetails["examiner"],
        "title": translate(context).activity_teacher_supervisor,
        "selections": [translate(context).first_section]
      },
    ];

    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 0, bottom: 4),
      child: TextFieldFor(
          fields: viewActivityFields,
          deleteOnTap: () {},
          galleryOnTap: () {},
          cameraOnTap: () {},
          scrollController: scrollController,
          readOnly: true),
    ));
  }
}
