import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/ui/helper/app_functions.dart';
import 'package:hudayi/ui/widgets/circule_progress.dart';

class Statistics extends StatelessWidget {
  final ScrollController controller;
  final Future? future;
  final String type;
  const Statistics({required this.type, super.key, required this.controller, this.future});

  @override
  Widget build(BuildContext context) {
    Map staticsName = {
      "quran_quizzes": translate(context).quranPagesCount,
      "face_to_face_quiz": type == "mosque" ? translate(context).mushafPagesCount : translate(context).pagesConsidering,
      "absence_quiz": translate(context).memorizedPagesCount,
      "write_arabic_reading_quiz": translate(context).arabicReadingTestsCount,
      "quizzes": translate(context).testsTakenCount,
      "Quizzes": type == "class_room" ? translate(context).testsCount : translate(context).testsTakenCount,
      "notes": translate(context).notesCount,
      "Notes": translate(context).notesCount,
      "interviews": type == "teacher" ? translate(context).interviewsConductedCount : translate(context).interviewsConductedCount_InterviewsConducted,
      "Interviews": type == "teacher" ? translate(context).interviewsConductedCount : translate(context).interviewsConductedCount_InterviewsConducted,
      "Session": translate(context).lessonsTaughtCount,
      "class_rooms": type == "mosque" ? translate(context).classesGroupsCount : translate(context).classesCount,
      "sessions": translate(context).lessonsTaughtCount,
      "session": translate(context).lessonsTaughtCount,
      "Sessions": type == "class_room"
          ? translate(context).lessons_count
          : type == "student"
              ? translate(context).lessonsAttendedCount
              : translate(context).lessonsTaughtCount,
      "activity": type == "class_room" || type == "grade" || type == "proprety" || type == "mosque"
          ? translate(context).activitiesImplementedCount
          : type == "teacher"
              ? translate(context).activitiesImplementedCount
              : translate(context).activitiesParticipatedCount,
      "Students": translate(context).activeStudentsCount,
      "Unattended Sessions": translate(context).lessonsMissedCount,
      "Personal Interviews": type == "student" ? translate(context).interviewsConductedCount : translate(context).personalInterviewsCount,
      "Unattended Activities": type == "teacher"
          ? translate(context).activitiesImplementedCount
          : type == "student"
              ? translate(context).activitiesNotAttendedCount
              : translate(context).activitiesNotParticipatedCount,
      "Activity": type == "class_room" || type == "grade" || type == "proprety" || type == "mosque"
          ? translate(context).activitiesImplementedCount
          : type == "teacher"
              ? translate(context).activitiesImplementedCount
              : translate(context).activitiesParticipatedCount,
      "activities": type == "class_room" || type == "grade" || type == "proprety" || type == "mosque"
          ? translate(context).executedActivitiesCount
          : type == "teacher"
              ? translate(context).activitiesImplementedCount
              : translate(context).activitiesParticipatedCount,
      "Activities": type == "class_room" || type == "grade" || type == "proprety" || type == "mosque"
          ? translate(context).executedActivitiesCount
          : type == "teacher"
              ? translate(context).activitiesImplementedCount
              : type == "student"
                  ? translate(context).attendedActivitiesCount
                  : translate(context).activitiesParticipatedCount,
      "grades": type == "mosque" ? translate(context).classesGroupsCount : translate(context).classesLevelsCount,
      "classrooms": type == "mosque" ? translate(context).classesGroupsCount : translate(context).classesCount,
      "ClassRooms": type == "mosque" ? translate(context).classesGroupsCount : translate(context).classesCount,
      "students": translate(context).activeStudentsCount,
      "teachers": translate(context).teacherCount,
      "Teachers": translate(context).teacherCount,
      "Grades": type == "mosque" ? translate(context).classesGroupsCount : translate(context).classesLevelsCount,
      "Classrooms": type == "mosque" ? translate(context).classesGroupsCount : translate(context).classesCount,
      "Users": translate(context).members,
      "unattended_sessions": translate(context).lessonsMissedCount,
      "unattended_activities": translate(context).activitiesNotParticipatedCount,
      "Books": type == "class_room" || type == "grade" || type == "proprety" || type == "mosque"
          ? translate(context).booksReadCount
          : translate(context).booksDiscussedCount,
      "Correct Arabic Reading Quiz": translate(context).arabicReadingPagesCount,
      "Absence Quiz": translate(context).memorizedPagesCount,
      "Approved students": translate(context).activeStudentsCount,
      "Approved Students": translate(context).activeStudentsCount,
      "Pending Students": translate(context).inactiveStudentsCount,
      "face_to_face_quiz_pages": type == "mosque" ? translate(context).mushafPagesCount : translate(context).readingsPagesCount,
      "Face-to-Face Quiz": translate(context).mushafPagesCount,
      "Face-to-Face-Quiz-school": translate(context).readingsPagesCount,
      "Face_to_Face Quiz": translate(context).testsTakenCount,
      "Face_to_Face_Quiz": translate(context).testsTakenCount,
      "absence_quiz_pages": translate(context).memorizedPagesCount,
      "arabic_reading_quiz_pages": translate(context).readingsCount,
      "arabic_reading_quiz": translate(context).readingsCount,
      "interviews_count": type == "student" ? translate(context).interviewsConductedCount : translate(context).interviewsConductedCount
    };

    FirebaseAnalytics.instance.logEvent(
      name: 'static_${type}_profile_page',
      parameters: {
        'screen_name': "static_${type}_profile_page",
        'screen_class': "profile",
      },
    );
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: FutureBuilder(
                  future: future,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      List details = snapshot.data == null ? [] : snapshot.data["data"] ?? [];
                      return GridView.count(
                        controller: controller,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsetsDirectional.only(start: 8.0, end: 8, top: 0, bottom: 4),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                        children: <Widget>[
                          for (var item in details)
                            GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: double.infinity,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 5,
                                        color: Color(0x44111417),
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(start: 14.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        // CircularPercentIndicator(
                                        //   percent: item["from"] / item["to"],
                                        //   radius: 30,
                                        //   lineWidth: 8,
                                        //   animation: true,
                                        //   circularStrokeCap: CircularStrokeCap.round,
                                        //   progressColor: Theme.of(context).primaryColor,
                                        //   backgroundColor: const Color(0xFFF1F4F8),
                                        //   center: Text(
                                        //     '${item["from"]}%',
                                        //     style: const TextStyle(
                                        //       color: Color(0xFF101213),
                                        //       fontSize: 15,
                                        //       fontWeight: FontWeight.bold,
                                        //     ),
                                        //   ),
                                        // ),
                                        Text(item["count"].toString()),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              staticsName[item["name"]].toString(),
                                              style: const TextStyle(
                                                color: Color(0xFF57636C),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                        ],
                      );
                    }
                    return const CirculeProgress();
                  })),
        ],
      ),
    );
  }
}
