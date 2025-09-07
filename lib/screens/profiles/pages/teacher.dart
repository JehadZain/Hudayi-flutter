import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/services/API/api.dart';
import 'package:hudayi/ui/helper/AppConstants.dart';
import 'package:hudayi/ui/helper/AppConsts.dart';
import 'package:hudayi/ui/helper/AppDialog.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/widgets/CirculeProgress.dart';
import 'package:hudayi/ui/widgets/NoData.dart';
import 'package:hudayi/ui/widgets/comingSoon.dart';
import 'package:hudayi/ui/widgets/listViewComponent.dart';
import 'package:hudayi/ui/widgets/statistics.dart';
import 'package:provider/provider.dart';

class TeacherProfile extends StatefulWidget {
  final TextEditingController searchController;
  final ScrollController scrollController;
  final TabController tabController;
  final Map details;
  const TeacherProfile({Key? key, required this.searchController, required this.scrollController, required this.tabController, required this.details})
      : super(key: key);

  @override
  State<TeacherProfile> createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  List viewTeacherFields = [];
  int tabIndex = 0;
  Map teacher = {};
  Future? staticsFuture;
  var authService;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  int calculateSumOfSkills(List addRatingFields) {
    int sum = 0;
    List<int> fieldIndices = [9, 10, 11, 12, 14, 15, 16, 18, 20, 22];

    for (int index in fieldIndices) {
      if (index >= 0 && index < addRatingFields.length) {
        sum += int.tryParse(addRatingFields[index]["value"] ?? "0") ?? 0;
      }
    }

    return sum;
  }

  getTeacherDetails() {
    teacher.clear();
    ApiService().getTeacherDetails(widget.details["id"], jsonDecode(authService.user.toUser())["token"]).then((data) {
      if (data != null) {
        setState(() {
          teacher.addAll(data["data"]);
        });
        Map teacherClass = teacher["class_rooms"] == null
            ? {}
            : teacher["class_rooms"].firstWhere((classRoom) => classRoom["pivot"]["left_at"] == null, orElse: () => {});
        viewTeacherFields.addAll([
          {"type": "flutterText", "title": translate(context).account_information},
          {"type": "text", "value": teacher["id"].toString(), "title": translate(context).serial_number},
          {
            "type": "text",
            "value": "${teacher["user"]["first_name"]} ${teacher["user"]["last_name"]}",
            "title": translate(context).first_name_last_name
          },
          {"type": "text", "value": teacher["user"]["father_name"], "title": translate(context).father_name},
          {"type": "text", "value": teacher["user"]["mother_name"], "title": translate(context).mother_name},
          {"type": "date", "value": teacher["user"]["birth_date"]?.split("T")[0], "title": translate(context).date_of_birth},
          {
            "type": "oneSelection",
            "value": getGenderValue(context, teacher["user"]["gender"]),
            "title": translate(context).gender,
            "selections": [translate(context).female, translate(context).male]
          },
          {"type": "number", "value": teacher["user"]["phone"], "title": translate(context).personal_phone_number},
          {"type": "number", "value": teacher["user"]["identity_number"], "title": translate(context).national_id_number},
          {"type": "text", "value": teacher["user"]["email"] ?? translate(context).not_available, "title": translate(context).email_address},
          {"type": "text", "value": teacher["user"]["birth_place"], "title": translate(context).place_of_birth},
          {
            "type": "oneSelection",
            "value": getStatusValue(context, teacher["user"]["status"]),
            "title": translate(context).teacherStatus,
            "selections": [translate(context).inactive, translate(context).active]
          },
          {
            "type": "oneSelection",
            "value": teacherClass.isEmpty
                ? translate(context).not_available
                : teacherClass["grade"] != null
                    ? teacherClass["grade"]["property"] != null
                        ? teacherClass["grade"]["property"]["name"]
                        : translate(context).not_available
                    : translate(context).not_available,
            "title": translate(context).teacherCenter,
            "selections": [translate(context).first_grade]
          },
          {
            "type": "oneSelection",
            "value": teacherClass.isEmpty
                ? translate(context).not_available
                : teacherClass["grade"] != null
                    ? teacherClass["grade"]["name"]
                    : translate(context).not_available,
            "title": translate(context).teacherClass,
            "selections": [translate(context).first_grade]
          },
          {
            "type": "oneSelection",
            "value": teacherClass.isEmpty ? translate(context).not_available : teacherClass["name"],
            "title": translate(context).sectionOrCircle,
            "selections": [translate(context).first_section]
          },
          {"type": "flutterText", "title": translate(context).private_account_information},
          {
            "type": "text",
            "value": teacher["user"]["current_address"] ?? translate(context).not_available,
            "title": translate(context).current_residence
          },
          {
            "type": "oneSelection",
            "value": teacher["user"]["blood_type"],
            "title": translate(context).blood_type,
            "selections": ["A+", "A-", "B+", "B-", "O+", "O-", "-AB", "+AB"]
          },
          {
            "type": "oneSelection",
            "value": getMarriedValue(context, teacher["marital_status"].toString()),
            "title": translate(context).marital_status,
            "selections": [translate(context).no, translate(context).yes]
          },
          {"type": "number", "value": teacher["wives_count"] == "null" ? "0" : teacher["wives_count"], "title": translate(context).number_of_wives},
          {"type": "number", "value": teacher["children_count"], "title": translate(context).number_of_children},
          {
            "type": "oneSelection",
            "value": getYesOrNoValue(context, teacher["user"]["is_has_disease"]),
            "title": translate(context).chronic_illness,
            "selections": [translate(context).no, translate(context).yes]
          },
          {
            "type": "text",
            "value": teacher["user"]["disease_name"] == "null" ? "" : teacher["user"]["disease_name"],
            "title": translate(context).illness_name
          },
          {
            "type": "oneSelection",
            "value": getYesOrNoValue(context, teacher["user"]["is_has_treatment"]),
            "title": translate(context).treatment_available,
            "selections": [translate(context).no, translate(context).yes]
          },
          {
            "type": "text",
            "value": teacher["user"]["treatment_name"] == "null" ? "" : teacher["user"]["treatment_name"],
            "title": translate(context).treatment_name
          },
          {
            "type": "oneSelection",
            "value": getYesOrNoValue(context, teacher["user"]["are_there_disease_in_family"]),
            "title": translate(context).chronic_illness_home,
            "selections": [translate(context).no, translate(context).yes]
          },
          {
            "type": "text",
            "value": teacher["user"]["family_disease_note"] == "null" ? "" : teacher["user"]["family_disease_note"],
            "title": translate(context).illness_name
          },
        ]);
      }
    });
  }

  @override
  void initState() {
    FirebaseAnalytics.instance.logEvent(
      name: 'teacher_profile_page',
      parameters: {
        'screen_name': "teacher_profile_page",
        'screen_class': "profile",
      },
    );
    authService = Provider.of<AuthService>(context, listen: false);
    staticsFuture = ApiService().getTeacherStatics(widget.details["id"], jsonDecode(authService.user.toUser())["token"]);
    getTeacherDetails();
    super.initState();
    widget.tabController.animation!.addListener(() {
      setState(() {
        tabIndex = widget.tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: teacher.isEmpty
            ? const CirculeProgress()
            : TabBarView(physics: const BouncingScrollPhysics(), controller: widget.tabController, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8, top: 0, bottom: 4),
                  child: TextFieldFor(
                      fields: viewTeacherFields,
                      deleteOnTap: () {},
                      galleryOnTap: () {},
                      cameraOnTap: () {},
                      scrollController: tabIndex == 0 ? widget.scrollController : ScrollController(),
                      readOnly: true),
                ),
                teacher["class_rooms"].isEmpty
                    ? const NoData()
                    : ListViewComponent(
                        searchController: widget.searchController,
                        onRefresh: () async {
                          getTeacherDetails();
                        },
                        controller: tabIndex == 3 ? widget.scrollController : ScrollController(),
                        permmission: false,
                        isClickable: true,
                        list: teacher["class_rooms"] == null
                            ? []
                            : teacher["class_rooms"].toList().asMap().entries.map((entry) {
                                return {
                                  "id": entry.value["id"],
                                  "name": entry.value["name"] ?? translate(context).not_available,
                                  "description": "${translate(context).joinedClassOn} ${entry.value["pivot"]["joined_at"]}",
                                  "image": entry.value["image"],
                                  "type": entry.value["pivot"]["left_at"] == null
                                      ? translate(context).currentlyTeachingIn
                                      : translate(context).previousEpisode,
                                  "date": "",
                                  "time": "",
                                };
                              }).toList(),
                        pageType: "subClass",
                        tabs: getSubClassTabs(context),
                      ),

                teacher["interviews"].isEmpty
                    ? const NoData()
                    : ListViewComponent(
                        searchController: widget.searchController,
                        onRefresh: () async {
                          getTeacherDetails();
                        },
                        controller: tabIndex == 3 ? widget.scrollController : ScrollController(),
                        permmission: false,
                        isClickable: true,
                        list: teacher["interviews"] == null
                            ? []
                            : teacher["interviews"].where((e) => e["type"] == "book").toList().asMap().entries.map((entry) {
                                return {
                                  "id": entry.value["id"],
                                  "name": entry.value["name"] ?? translate(context).not_available,
                                  "description":
                                      "${entry.value["goal"]} - ${translate(context).interviewConductedWith} ${entry.value["student"] == null ? "" : entry.value["student"]["user"] == null ? "" : entry.value["student"]["user"]["first_name"]} ${entry.value["student"] == null ? "" : entry.value["student"]["user"] == null ? "" : entry.value["student"]["user"]["last_name"]}",
                                  "comment": entry.value["comment"],
                                  "image": entry.value["image"],
                                  "type": entry.value["type"] == "book"
                                      ? translate(context).book
                                      : entry.value["type"] ?? translate(context).not_available,
                                  "date":
                                      "${entry.value["date"].split(" ")[0] ?? translate(context).not_available} / ${entry.value["teacher"] != null ? "${entry.value["teacher"]["user"]["first_name"]} ${entry.value["teacher"]["user"]["last_name"]} - ${entry.value["teacher"]["id"]}" : translate(context).not_available}",
                                  "time": entry.value["date"]!.split(" ").length > 1
                                      ? entry.value["date"]!.split(" ")[1] ?? translate(context).not_available
                                      : translate(context).not_available,
                                  "event_place": entry.value["event_place"] ?? translate(context).not_available,
                                  "goal": entry.value["goal"] ?? translate(context).not_available,
                                  "score": entry.value["score"] ?? translate(context).not_available,
                                };
                              }).toList(),
                        tabs: const [],
                        pageType: "interview",
                      ),
                teacher["interviews"].isEmpty
                    ? const NoData()
                    : ListViewComponent(
                        onRefresh: () async {
                          getTeacherDetails();
                        },
                        isClickable: true,
                        searchController: widget.searchController,
                        controller: tabIndex == 3 ? widget.scrollController : ScrollController(),
                        list: teacher["interviews"] == null
                            ? []
                            : teacher["interviews"].where((e) => e["type"] != "book").toList().asMap().entries.map((entry) {
                                return {
                                  "id": entry.value["id"],
                                  "name": entry.value["name"] ?? translate(context).not_available,
                                  "description":
                                      "${entry.value["goal"]} -  ${translate(context).interviewConductedWith} ${entry.value["student"] == null ? "" : entry.value["student"]["user"] == null ? "" : entry.value["student"]["user"]["first_name"]} ${entry.value["student"] == null ? "" : entry.value["student"]["user"] == null ? "" : entry.value["student"]["user"]["last_name"]}",
                                  "comment": entry.value["comment"],
                                  "image": entry.value["image"],
                                  "type": entry.value["type"] ?? translate(context).not_available,
                                  "date":
                                      "${entry.value["date"].split(" ")[0] ?? translate(context).not_available} / ${entry.value["teacher"] != null ? "${entry.value["teacher"]["user"]["first_name"]} ${entry.value["teacher"]["user"]["last_name"]} - ${entry.value["teacher"]["id"]}" : translate(context).not_available}",
                                  "time": entry.value["date"] == "null"
                                      ? ""
                                      : entry.value["date"]?.split(" ").length == 2
                                          ? entry.value["date"]?.split(" ")[1]
                                          : "" ?? translate(context).not_available,
                                  "event_place": entry.value["event_place"] ?? translate(context).not_available,
                                  "goal": entry.value["goal"] ?? translate(context).not_available,
                                  "score": entry.value["score"] ?? translate(context).not_available,
                                };
                              }).toList(),
                        tabs: const [],
                        permmission: false,
                        pageType: "interview",
                      ),
                teacher["quizzes"].isEmpty
                    ? const NoData()
                    : ListViewComponent(
                        onRefresh: () async {
                          getTeacherDetails();
                        },
                        isClickable: true,
                        searchController: widget.searchController,
                        controller: tabIndex == 4 ? widget.scrollController : ScrollController(),
                        list: teacher["quizzes"] == null
                            ? []
                            : teacher["quizzes"].asMap().entries.map((entry) {
                                return {
                                  "id": entry.value["id"],
                                  "name": "${entry.value["name"]} , ${translate(context).subjects}: ${entry.value["quiz_subject"]}",
                                  "description":
                                      "${translate(context).studentGradeInExam} ${entry.value["score"] ?? translate(context).not_available} - - ${translate(context).interviewConductedWith} ${entry.value["student"]["user"] == null ? "" : entry.value["student"]["user"]["first_name"]} ${entry.value["student"]["user"] == null ? "" : entry.value["student"]["user"]["last_name"]}",
                                  "type":getQuizTypeValue(context,  entry.value["quiz_type"]),
                                  "date": entry.value["date"]?.split(" ")[0] ?? translate(context).not_available,
                                  "time": entry.value["time"] ?? translate(context).not_available,
                                  "score": entry.value["score"] ?? translate(context).not_available,
                                  "quiz_subject": entry.value["quiz_subject"] ?? translate(context).not_available,
                                };
                              }).toList(),
                        tabs: const [],
                        pageType: "exam",
                        permmission: false,
                      ),
                teacher["quran_quizzes"].isEmpty
                    ? const NoData()
                    : ListViewComponent(
                        isClickable: true,
                        onRefresh: () async {
                          getTeacherDetails();
                        },
                        searchController: widget.searchController,
                        controller: tabIndex == 5 ? widget.scrollController : ScrollController(),
                        list: teacher["quran_quizzes"] == null
                            ? []
                            : teacher["quran_quizzes"].asMap().entries.map((entry) {
                                return {
                                  "id": entry.value["id"],
                                  "name": entry.value["name"] ?? translate(context).not_available,
                                  "juz": entry.value["juz"] ?? translate(context).not_available,
                                  "score": entry.value["score"] ?? translate(context).not_available,
                                  "page": entry.value["page"] ?? translate(context).not_available,
                                  "description":
                                      "${translate(context).page}: ${entry.value["page"]}, ${translate(context).assessment}:${entry.value["score"] ?? translate(context).not_available} - ${translate(context).interviewConductedWith} ${entry.value["student"] == null ? "" : entry.value["student"]["user"] == null ? "" : entry.value["student"]["user"]["first_name"]} ${entry.value["student"] == null ? "" : entry.value["student"]["user"] == null ? "" : entry.value["student"]["user"]["last_name"]}",
                                  "type": getExamTypeValue(context, entry.value["exam_type"]) ?? translate(context).not_available,
                                  "date": entry.value["date"] ?? translate(context).not_available,
                                  "examiner": entry.value["teacher"] != null
                                      ? "${entry.value["teacher"]["user"]["first_name"]} ${entry.value["teacher"]["user"]["last_name"]} - ${entry.value["teacher"]["id"]}"
                                      : translate(context).not_available,
                                };
                              }).toList(),
                        tabs: const [],
                        pageType: "quran",
                        permmission: false,
                      ),
                // ListViewComponent(
                //   searchController: widget.searchController,
                //   controller: tabIndex == 7 ? widget.scrollController : ScrollController(),
                //   addPage: AddPage(isEdit: false, fields: getAddRatingFields(context), title: "إضافة تقييم"),
                //   list: bookTemp,
                //   tabs: [],
                //   pageType: "rating",
                // ),
                teacher["notes"].isEmpty
                    ? const NoData()
                    : ListViewComponent(
                        onRefresh: () async {
                          getTeacherDetails();
                        },
                        searchController: widget.searchController,
                        controller: tabIndex == 6 ? widget.scrollController : ScrollController(),
                        list: teacher["notes"] == null
                            ? []
                            : teacher["notes"].asMap().entries.map((entry) {
                                return {
                                  "id": entry.value["id"],
                                  "name": entry.value["teacher"] != null
                                      ? "${entry.value["teacher"]["user"]["first_name"]} ${entry.value["teacher"]["user"]["last_name"]} - ${entry.value["teacher"]["id"]}"
                                      : entry.value["admin"] != null
                                          ? "${entry.value["admin"]["user"]["first_name"]} ${entry.value["admin"]["user"]["last_name"]} - ${entry.value["admin"]["id"]}"
                                          : translate(context).not_available,
                                  "description": entry.value["teacher_content"] ?? entry.value["admin_content"],
                                  "type": entry.value["date"]?.split(" ")[1] ?? translate(context).not_available,
                                  "date": entry.value["date"]?.split(" ")[0] ?? translate(context).not_available,
                                  "student_id": teacher["id"],
                                  "teacher_id": jsonDecode(authService.user.toUser())["id"],
                                };
                              }).toList(),
                        tabs: const [],
                        permmission: false,
                        isClickable: true,
                        pageType: "note",
                      ),
                // ListViewComponent(
                //   searchController: widget.searchController,
                //   controller: tabIndex == 7 ? widget.scrollController : ScrollController(),
                //   addPage: AddPage(isEdit: false, fields: getAddReportFields(context), title: "إضافة تقرير"),
                //   list: bookTemp,
                //   tabs: [],
                //   pageType: "report",
                // ),
                if (jsonDecode(authService.user.toUser())["role"] == "admin" ||
                    jsonDecode(authService.user.toUser())["role"] == "branch_admin" ||
                    jsonDecode(authService.user.toUser())["role"] == "property_admin")
                  ListViewComponent(
                    searchController: widget.searchController,
                    controller: tabIndex == 8 ? widget.scrollController : ScrollController(),
                    onEditPressed: (item, index) async {
                      addRatingFields[1]["value"] = teacher["id"].toString();
                      addRatingFields[2]["value"] = "${teacher["user"]["first_name"]} ${teacher["user"]["last_name"]}";
                      addRatingFields[3]["value"] =
                          "${jsonDecode(authService.user.toUser())["first_name"]} ${jsonDecode(authService.user.toUser())["last_name"]}";
                      addRatingFields[4]["value"] = DateTime.now().toIso8601String().split('T')[0];
                      addRatingFields[6]["value"] = item["start_date"];
                      addRatingFields[7]["value"] = item["end_date"];
                      addRatingFields[9]["value"] = item["correct_reading_skill"];
                      addRatingFields[10]["value"] = item["teaching_skill"];
                      addRatingFields[11]["value"] = item["academic_skill"];
                      addRatingFields[12]["value"] = item["following_skill"];
                      addRatingFields[14]["value"] = item["plan_commitment"];
                      addRatingFields[15]["value"] = item["time_commitment"];
                      addRatingFields[16]["value"] = item["student_commitment"];
                      addRatingFields[18]["value"] = item["activity"];
                      addRatingFields[20]["value"] = item["commitment_to_administrative_instructions"];
                      addRatingFields[22]["value"] = item["exam_and_quizzes"];
                      addRatingFields[24]["value"] = item["note"];
                      addRatingFields[25]["value"] = item["student_count"];
                      Navigator.of(context).push(createRoute(
                        AddPage(
                          englishTitle: "edit_grade",
                          isEdit: true,
                          fields: addRatingFields,
                          title: translate(context).editEvaluation,
                          onPressed: () async {
                            Map result = await ApiService().editRates({
                              "id": item["id"],
                              "admin_id": jsonDecode(authService.user.toUser())["id"],
                              "teacher_id": addRatingFields[1]["value"],
                              "date": DateTime.now().toIso8601String().split('T')[0],
                              "start_date": addRatingFields[6]["value"],
                              "end_date": addRatingFields[7]["value"],
                              "correct_reading_skill": addRatingFields[9]["value"],
                              "teaching_skill": addRatingFields[10]["value"],
                              "academic_skill": addRatingFields[11]["value"],
                              "following_skill": addRatingFields[12]["value"],
                              "plan_commitment": addRatingFields[14]["value"],
                              "time_commitment": addRatingFields[15]["value"],
                              "student_commitment": addRatingFields[16]["value"],
                              "activity": addRatingFields[18]["value"],
                              "commitment_to_administrative_instructions": addRatingFields[20]["value"],
                              "exam_and_quizzes": addRatingFields[22]["value"],
                              "note": addRatingFields[24]["value"],
                              "student_count": addRatingFields[25]["value"],
                            }, jsonDecode(authService.user.toUser())["token"]);

                            if (result["api"] == "SUCCESS") {
                              getTeacherDetails();
                            }
                            return result["api"];
                          },
                        ),
                      ));
                    },
                    onDeletePressed: (item, index) async {
                      showCustomDialog(context, translate(context).confirm_delete, AppConstants.appLogo, "delete", () async {
                        Map result = await ApiService().deleteRates(item["id"], jsonDecode(authService.user.toUser())["token"]);

                        if (result["api"] == "SUCCESS") {
                          getTeacherDetails();
                        }
                        return result["api"];
                      });
                    },
                    list: teacher["rates"] == null
                        ? []
                        : teacher["rates"].asMap().entries.map((entry) {
                            return {
                              "id": entry.value["id"],
                              "name": entry.value["admin"] != null
                                  ? "${translate(context).evaluatorsName}: ${entry.value["admin"]["user"]["first_name"]} ${entry.value["admin"]["user"]["last_name"]}"
                                  : translate(context).not_available,
                              "description":
                                  "${translate(context).assessmentConductedOn} ${entry.value["date"]} ${translate(context).between} ${entry.value["start_date"]}  ${translate(context).andTheTime} ${entry.value["end_date"]}",
                              "date": "${translate(context).totalAssessment} ${entry.value["percentage"]} ${translate(context).outOf100}",
                              "student_id": teacher["id"],
                              "teacher_id": entry.value["teacher_id"],
                              "admin": entry.value["admin"],
                              "teacher": teacher["user"],
                              "admin_id": entry.value["admin_id"],
                              "date_1": entry.value["date"],
                              "start_date": entry.value["start_date"],
                              "end_date": entry.value["end_date"],
                              "correct_reading_skill": entry.value["correct_reading_skill"],
                              "teaching_skill": entry.value["teaching_skill"],
                              "academic_skill": entry.value["academic_skill"],
                              "following_skill": entry.value["following_skill"],
                              "plan_commitment": entry.value["plan_commitment"],
                              "time_commitment": entry.value["time_commitment"],
                              "student_commitment": entry.value["student_commitment"],
                              "activity": entry.value["activity"],
                              "commitment_to_administrative_instructions": entry.value["commitment_to_administrative_instructions"],
                              "exam_and_quizzes": entry.value["exam_and_quizzes"],
                              "percentage": entry.value["percentage"],
                              "score": entry.value["score"],
                              "note": entry.value["note"],
                              "student_count": entry.value["student_count"],
                            };
                          }).toList(),
                    onTap: () {
                      addRatingFields[1]["value"] = teacher["id"].toString();
                      addRatingFields[2]["value"] = "${teacher["user"]["first_name"]} ${teacher["user"]["last_name"]}";
                      addRatingFields[3]["value"] =
                          "${jsonDecode(authService.user.toUser())["first_name"]} ${jsonDecode(authService.user.toUser())["last_name"]}";
                      addRatingFields[4]["value"] = DateTime.now().toIso8601String().split('T')[0];
                      Navigator.of(context).push(createRoute(
                        AddPage(
                          englishTitle: "add_rating",
                          isEdit: true,
                          fields: addRatingFields,
                          title: translate(context).addEvaluation,
                          onPressed: () async {
                            Map result = await ApiService().createRates({
                              "id": null,
                              "admin_id": jsonDecode(authService.user.toUser())["id"],
                              "teacher_id": addRatingFields[1]["value"],
                              "date": DateTime.now().toIso8601String().split('T')[0],
                              "start_date": addRatingFields[6]["value"],
                              "end_date": addRatingFields[7]["value"],
                              "correct_reading_skill": addRatingFields[9]["value"],
                              "teaching_skill": addRatingFields[10]["value"],
                              "academic_skill": addRatingFields[11]["value"],
                              "following_skill": addRatingFields[12]["value"],
                              "plan_commitment": addRatingFields[14]["value"],
                              "time_commitment": addRatingFields[15]["value"],
                              "student_commitment": addRatingFields[16]["value"],
                              "activity": addRatingFields[18]["value"],
                              "commitment_to_administrative_instructions": addRatingFields[20]["value"],
                              "exam_and_quizzes": addRatingFields[22]["value"],
                              "percentage": "100",
                              "score": calculateSumOfSkills(addRatingFields),
                              "note": addRatingFields[24]["value"],
                              "student_count": addRatingFields[25]["value"],
                            }, jsonDecode(authService.user.toUser())["token"]);
                            if (result["api"] == "SUCCESS") {
                              getTeacherDetails();
                            }
                            return result["api"];
                          },
                        ),
                      ));
                    },
                    tabs: [],
                    pageType: "rate",
                    onRefresh: () async {},
                  ),
                Statistics(
                  controller: tabIndex == 9 ? widget.scrollController : ScrollController(),
                  future: staticsFuture,
                  type: "teacher",
                ),
                // QrPage(code: teacher["user"]["qr_code"] ?? ""),
              ]));
  }
}
