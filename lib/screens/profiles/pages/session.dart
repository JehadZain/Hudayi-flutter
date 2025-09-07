import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/screens/profiles/pages/subClass.dart';
import 'package:hudayi/services/API/api.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/widgets/CirculeProgress.dart';
import 'package:hudayi/ui/widgets/pageHeader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Session extends StatefulWidget {
  final ScrollController scrollController;
  final Map details;
  const Session({Key? key, required this.details, required this.scrollController}) : super(key: key);

  @override
  State<Session> createState() => _SessionState();
}

class _SessionState extends State<Session> {
  Map session = {};
  bool isError = false;
  var authService;
  List viewLessonFields = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  getSessions() {
    try {
      session.clear();
      ApiService().getSessionDetails(widget.details["id"], jsonDecode(authService.user.toUser())["token"]).then((data) {
        if (data != null && data["api"] != "NO_DATA") {
          session.addAll(data["data"]);
          setState(() {
            viewLessonFields = fillSessionData(session);
          });
        } else {
          setState(() {
            isError = true;
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  fillSessionData(session) {
    List participants = session["session_attendances"];
    String participant = participants.map((e) => '${e["student"]["user"]["first_name"]} ${e["student"]["user"]["last_name"]}').toList().join("  ,");

    viewLessonFields = [
      {"type": "text", "value": session["name"], "title": translate(context).lessonName},
      {"type": "description", "value": session["description"], "title": translate(context).lessonDescription},
      {"type": "text", "value": session["place"], "title": translate(context).lessonLocation},
      {"type": "text", "value": session["type"] ?? session["subject_name"], "title": translate(context).lessonType},
      {"type": "text", "value": session["subject_name"], "title": translate(context).lessonBook},
      {
        "type": "multipleSelection",
        "value": participant,
        "title": translate(context).present_students,
        "selections": [],
      },
      {"type": "date", "value": session["date"], "title": translate(context).lessonDate},
      {"type": "time", "value": session["start_at"]?.split(" ")[1], "title": translate(context).lessonTime},
      {
        "type": "oneSelection",
        "value": session["duration"],
        "title": translate(context).lessonDuration,
        "selections": ["90", "60", "30"]
      },
    ];
    return viewLessonFields;
  }

  @override
  void initState() {
    FirebaseAnalytics.instance.logEvent(
      name: 'session_profile_page',
      parameters: {
        'screen_name': "session_profile_page",
        'screen_class': "profile",
      },
    );
    authService = Provider.of<AuthService>(context, listen: false);
    getSessions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PageHeader(
                  checkedValue: "noDialog",
                  path: XFile(" "),
                  title: widget.details["name"] ?? "",
                  isCircle: false,
                ),
                isError
                    ? Padding(
                      padding: const EdgeInsets.only(top:50),
                      child: Text(translate(Get.context!).not_available),
                    )
                    : session.isEmpty
                    ? const CirculeProgress()
                    : Expanded(
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 14.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: TeacherContainer(
                                    type: "teacher",
                                    authService: authService,
                                    teacher: {"teacher": session["teacher"]},
                                    teachersWithoutClass: const [],
                                    id: widget.details["id"],
                                    onDeletePressed: null,
                                  ),
                                )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 0, bottom: 4),
                              child: TextFieldFor(
                                  fields: viewLessonFields,
                                  deleteOnTap: () {},
                                  galleryOnTap: () {},
                                  cameraOnTap: () {},
                                  scrollController: widget.scrollController,
                                  readOnly: true),
                            )),
                          ],
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
