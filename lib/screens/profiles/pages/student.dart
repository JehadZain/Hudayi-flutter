import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hudayi/main.dart';
import 'package:hudayi/models/language_provider.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/services/API/api.dart';
import 'package:hudayi/services/pref_utils.dart';
import 'package:hudayi/ui/helper/App_Constants.dart';
import 'package:hudayi/ui/helper/App_Consts.dart';
import 'package:hudayi/ui/helper/App_Dialog.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:hudayi/ui/widgets/Circule_Progress.dart';
import 'package:hudayi/ui/widgets/list_View_Component.dart';
import 'package:hudayi/ui/widgets/no_Data.dart';
import 'package:hudayi/ui/widgets/statistics.dart';
import 'package:provider/provider.dart';

class StudentProfile extends StatefulWidget {
  final TextEditingController searchController;
  final ScrollController scrollController;
  final TabController tabController;
  final Map details;
  const StudentProfile({Key? key, required this.searchController, required this.scrollController, required this.tabController, required this.details})
      : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  List viewStudentsFields = [];
  int tabIndex = 0;
  Map student = {};
  bool isEmpty = false;
  List qurans = [];
  List allQurans = [];
  Future? staticsFuture;
  var authService;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  setStudent(student) {
    Map studentClass = student["class_rooms"] == null
        ? {}
        : student["class_rooms"].firstWhere((classRoom) => classRoom["pivot"]["left_at"] == null, orElse: () => {});

    viewStudentsFields.addAll([
      {"type": "flutterText", "title": translate(Get.context!).account_information},
      {"type": "text", "value": student["id"].toString(), "title": translate(Get.context!).serial_number},
      {
        "type": "text",
        "value": "${student["user"] == null ? translate(Get.context!).not_available : student["user"]["first_name"]} ${student["user"]["last_name"]}",
        "title": translate(Get.context!).first_name_last_name
      },
      {"type": "text", "value": student["user"]["father_name"], "title": translate(Get.context!).father_name},
      {"type": "text", "value": student["user"]["mother_name"], "title": translate(Get.context!).mother_name},
      {"type": "date", "value": student["user"]["birth_date"]?.split("T")[0], "title": translate(Get.context!).date_of_birth},
      {
        "type": "oneSelection",
        "value": getGenderValue(context, student["user"]["gender"]),
        "title": translate(Get.context!).gender,
        "selections": [translate(Get.context!).female, translate(Get.context!).male]
      },
      {
        "type": "number",
        "value": student["parent_phone"] == "null" ? null : student["parent_phone"] ?? translate(Get.context!).not_available,
        "title": translate(Get.context!).parentPhoneNumber
      },
      {
        "type": "number",
        "value": student["user"]["phone"] == "null" ? null : student["user"]["phone"],
        "title": translate(Get.context!).student_phone_number
      },
      {"type": "number", "value": student["user"]["identity_number"], "title": translate(Get.context!).national_id_number},
      {"type": "text", "value": student["user"]["birth_place"], "title": translate(Get.context!).place_of_birth},
      {
        "type": "oneSelection",
        "value": getStatusValue(context, student["user"]["status"]),
        "title": translate(Get.context!).student_status,
        "selections": [translate(Get.context!).inactive, translate(Get.context!).active]
      },
      {
        "type": "oneSelection",
        "value": studentClass.isEmpty
            ? translate(Get.context!).not_available
            : studentClass["grade"] != null
                ? studentClass["grade"]["property"] != null
                    ? studentClass["grade"]["property"]["name"]
                    : translate(Get.context!).not_available
                : translate(Get.context!).not_available,
        "title": translate(Get.context!).student_Center,
        "selections": [translate(Get.context!).first_grade]
      },
      {
        "type": "oneSelection",
        "value": studentClass.isEmpty
            ? translate(Get.context!).not_available
            : studentClass["grade"] != null
                ? studentClass["grade"]["name"]
                : translate(Get.context!).not_available,
        "title": translate(Get.context!).studentGrade,
        "selections": [translate(Get.context!).first_grade]
      },
      {
        "type": "oneSelection",
        "value": studentClass.isEmpty ? translate(Get.context!).not_available : studentClass["name"],
        "title": translate(Get.context!).sectionOrCircle,
        "selections": [translate(Get.context!).first_section]
      },
      {"type": "flutterText", "title": translate(Get.context!).private_account_information},
      {
        "type": "text",
        "value": student["user"]["current_address"] ?? translate(Get.context!).not_available,
        "title": translate(Get.context!).current_residence
      },
      {
        "type": "oneSelection",
        "value": student["user"]["blood_type"],
        "title": translate(Get.context!).blood_type,
        "selections": ["A+", "A-", "B+", "B-", "O+", "O-", "-AB", "+AB"]
      },
      {"type": "number", "value": student["family_members_count"], "title": translate(Get.context!).familyMembersCount},
      {
        "type": "oneSelection",
        "value": getYesOrNoValue(context, student["user"]["is_has_disease"]),
        "title": translate(Get.context!).chronic_illness,
        "selections": [translate(Get.context!).no, translate(Get.context!).yes]
      },
      {
        "type": "text",
        "value": student["user"]["disease_name"] == "null" ? "" : student["user"]["disease_name"],
        "title": translate(Get.context!).illness_name
      },
      {
        "type": "oneSelection",
        "value": getYesOrNoValue(context, student["user"]["is_has_treatment"]),
        "title": translate(Get.context!).treatment_available,
        "selections": [translate(Get.context!).no, translate(Get.context!).yes]
      },
      {
        "type": "text",
        "value": student["user"]["treatment_name"] == "null" ? "" : student["user"]["treatment_name"],
        "title": translate(Get.context!).treatment_name
      },
      {"type": "text", "value": student["who_is_parent"] ?? translate(Get.context!).not_available, "title": translate(Get.context!).guardian},
      {
        "type": "oneSelection",
        "value": getYesOrNoValue(context, student["user"]["are_there_disease_in_family"]),
        "title": translate(Get.context!).family_chronic_illness,
        "selections": [translate(Get.context!).no, translate(Get.context!).yes]
      },
      {
        "type": "text",
        "value": student["user"]["family_disease_note"] == "null" ? "" : student["user"]["family_disease_note"],
        "title": translate(Get.context!).illness_name
      },
      {
        "type": "oneSelection",
        "value": student["is_orphan"] != "0" ? translate(Get.context!).yes : translate(Get.context!).no,
        "title": translate(Get.context!).isStudentOrphan,
        "selections": [translate(Get.context!).no, translate(Get.context!).yes]
      },
    ]);
    if (isConnected) {
      Map classRoom = student["class_rooms"].firstWhere((e) => e["pivot"]["left_at"] == null, orElse: () => {}) ?? {};
      int classRoomId = classRoom.isEmpty ? -1 : classRoom["id"];
      staticsFuture = ApiService().getStudentStatics(widget.details["id"], jsonDecode(authService.user.toUser())["token"]);
      if (classRoomId != -1) {
        ApiService().getClassRoomBooks(jsonDecode(authService.user.toUser())["token"], classRoomId).then((teachers) {
          addBookInterviewFields.removeWhere((element) => element["title"] == translate(Get.context!).book_name);
          addBookInterviewFields.insert(
            0,
            {
              "type": "oneSelection",
              "value": null,
              "title": translate(Get.context!).book_name,
              "selections": teachers["data"] == null ? [] : teachers["data"].map((e) => '${e["name"]}/${e["book_type"]} - ${e["id"]}').toList()
            },
          );
        });
      } else {
        addBookInterviewFields.removeWhere((element) => element["title"] == translate(Get.context!).book_name);
        addBookInterviewFields.insert(
          0,
          {"type": "oneSelection", "value": null, "title": translate(Get.context!).book_name, "selections": []},
        );
      }
    } else {
      () async {
        String teacherGroup = await PrefUtils.getTeachers() ?? "";
        List teachers = teacherGroup == "" ? [] : jsonDecode(await PrefUtils.getTeachers() ?? "[]") ?? [];
        addQuranFields.removeWhere((element) => element["title"] == translate(Get.context!).laboratory);
        addQuranFields.insert(
          3,
          {
            "type": "oneSelection",
            "value": null,
            "title": translate(Get.context!).laboratory,
            "selections": teachers.map((e) => '${e["name"]} - ${e["id"]}').toList()
          },
        );
      }();
    }
  }

  getStudent() async {
    String studentGroup = await PrefUtils.getStudent() ?? "";
    List students = studentGroup == "" ? [] : jsonDecode(await PrefUtils.getStudent());

    if (isConnected) {
      students.removeWhere((element) => element["id"] == widget.details["id"]);
      ApiService().getStudentDetails(widget.details["id"], jsonDecode(authService.user.toUser())["token"]).then((data) {
        if (data != null && data["data"] != null) {
          setState(() {
            viewStudentsFields = [];
            student = {};
            student.addAll(data["data"]);
            getPropertyTeachers(data["data"]?["user"]?["property_id"]);
          });
          setStudent(data["data"]);
          PrefUtils.setStudent(jsonEncode([...students, data["data"]]));
        }
      });
    } else {
      String quranGroup = await PrefUtils.getQuran() ?? "";

      try {
        allQurans = quranGroup == "" ? [] : jsonDecode(await PrefUtils.getQuran());

        Map student1 = students.firstWhere((element) => element["id"] == widget.details["id"]) ?? {};
        qurans =
            quranGroup == "" ? [] : jsonDecode(await PrefUtils.getQuran()).where((element) => element["student_id"] == widget.details["id"]).toList();
        setState(() {
          if (student1.isEmpty) {
            isEmpty = true;
          }

          viewStudentsFields = [];
          student = {};
          student.addAll(student1);
        });
        setStudent(student1);
      } catch (e) {
        setState(() {
          isEmpty = true;
        });
      }
    }
  }

  getPropertyTeachers(propertyId) {
    ApiService().getPropertyTeacher(propertyId, jsonDecode(authService.user.toUser())["token"]).then((teachers) {
      PrefUtils.setTeachers(jsonEncode(teachers["data"]));
      addQuranFields.removeWhere((element) => element["title"] == translate(Get.context!).laboratory);
      addQuranFields.insert(
        3,
        {
          "type": "oneSelection",
          "value": null,
          "title": translate(Get.context!).laboratory,
          "selections": teachers["data"] == null ? [] : teachers["data"].map((e) => '${e["name"]} - ${e["id"]}').toList()
        },
      );

      addInterviewFields.removeWhere((element) => element["title"] == translate(Get.context!).interviewer);
      addInterviewFields.insert(
        6,
        {
          "type": "oneSelection",
          "value": null,
          "title": translate(Get.context!).interviewer,
          "selections": teachers["data"] == null ? [] : teachers["data"].map((e) => '${e["name"]} - ${e["id"]}').toList()
        },
      );
      addBookInterviewFields.removeWhere((element) => element["title"] == translate(Get.context!).interviewer);
      addBookInterviewFields.insert(
        6,
        {
          "type": "oneSelection",
          "value": null,
          "title": translate(Get.context!).interviewer,
          "selections": teachers["data"] == null ? [] : teachers["data"].map((e) => '${e["name"]} - ${e["id"]}').toList()
        },
      );
    });
  }

  Map user = {};
  @override
  void initState() {
    FirebaseAnalytics.instance.logEvent(
      name: 'student_profile_page',
      parameters: {
        'screen_name': "student_profile_page",
        'screen_class': "profile",
      },
    );
    authService = Provider.of<AuthService>(context, listen: false);
    user.addAll(jsonDecode(authService.user.toUser()));
    addQuranFields.removeWhere((element) => element["title"] == translate(Get.context!).laboratory);
    addInterviewFields.removeWhere((element) => element["title"] == translate(Get.context!).studentName);
    authService = Provider.of<AuthService>(context, listen: false);
    if (widget.details["id"] != "") {
      getStudent();
    } else {
      setState(() {
        isEmpty = true;
      });
    }

    super.initState();
    widget.tabController.animation!.addListener(() {
      setState(() {
        tabIndex = widget.tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isEmpty
        ? const NoData()
        : student.isEmpty
            ? const CirculeProgress()
            : Expanded(
                child: TabBarView(physics: const BouncingScrollPhysics(), controller: widget.tabController, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8, top: 0, bottom: 4),
                  child: TextFieldFor(
                      fields: viewStudentsFields,
                      deleteOnTap: () {},
                      galleryOnTap: () {},
                      cameraOnTap: () {},
                      scrollController: tabIndex == 0 ? widget.scrollController : ScrollController(),
                      readOnly: true),
                ),
                ListViewComponent(
                  onRefresh: () async {
                    getStudent();
                  },
                  onTap: () {
                    //addQuranFields.removeWhere((element) => element["title"] == translate(Get.context!).laboratory);
                  },
                  isClickable: true,
                  permmission: user["role"] == "admin" ||
                      user['role'] == "branch_admin" ||
                      user["role"] == "property_admin" ||
                      (user["role"] == "teacher" && user["class_room_id"] == widget.details["class_room_id"]),
                  searchController: widget.searchController,
                  controller: tabIndex == 5 ? widget.scrollController : ScrollController(),
                  addPage: AddPage(
                    englishTitle: "add_quran_quizz",
                    isEdit: false,
                    fields: addQuranFields,
                    title: translate(Get.context!).addQuranicAchievement,
                    onPressed: () async {
                      print("quran$addQuranFields");

                      Map quran = {
                        "id": null,
                        "removeItem": AppFunctions().idGenerator(),
                        "name": "${translate(Get.context!).juz}: ${addQuranFields[0]["value"]}",
                        "juz": addQuranFields[0]["value"],
                        "page": addQuranFields[1]["value"],
                        "date": addQuranFields[2]["value"],
                        "exam_type": getExamTypeKey(context, addQuranFields[4]["value"]),
                        "score": getmMrksWords(context)[addQuranFields[5]["value"]],
                        "student_id": student["id"],
                        "teacher_id": int.parse(addQuranFields[3]["value"].split(" - ")[1])
                      };
                      if (isConnected) {
                        Map result = await ApiService().createStudentQuran(quran, jsonDecode(authService.user.toUser())["token"]);

                        if (result["api"] == "SUCCESS") {
                          setState(() {
                            student["quran_quizzes"].insert(0, result["data"]);
                            getStudent();
                          });
                        }
                        return result["api"];
                      } else {
                        showLoadingDialog(context);

                        setState(() {
                          qurans.insert(0, quran);
                          allQurans.insert(0, quran);
                        });
                        List oneList = [...allQurans];
                        print(oneList);
                        PrefUtils.setQuran(jsonEncode(oneList));

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(translate(Get.context!).operation_success, style: TextStyle(fontFamily: getFontName(context))),
                          duration: const Duration(milliseconds: 500),
                        ));

                        return "SUCCESS";
                      }
                    },
                  ),
                  list: [...student["quran_quizzes"], ...qurans] == null
                      ? []
                      : [...student["quran_quizzes"], ...qurans].asMap().entries.map((entry) {
                          return {
                            "id": "${entry.value["id"]}",
                            "name": entry.value["name"] ?? translate(Get.context!).not_available,
                            "juz": entry.value["juz"] ?? translate(Get.context!).not_available,
                            "score": entry.value["score"] ?? translate(Get.context!).not_available,
                            "page": entry.value["page"] ?? translate(Get.context!).not_available,
                            "description":
                                "${translate(Get.context!).page} ${entry.value["page"]}, ${translate(Get.context!).evaluations}:${entry.value["score"] ?? translate(Get.context!).not_available}",
                            "removeItem": entry.value["removeItem"],
                            "type": getExamTypeValue(context, entry.value["exam_type"]) ?? translate(Get.context!).not_available,
                            "date": entry.value["date"] ?? translate(Get.context!).not_available,
                            "examiner": entry.value["teacher"] != null
                                ? "${entry.value["teacher"]["user"] == null ? "" : entry.value["teacher"]["user"]["first_name"]} ${entry.value["teacher"]["user"] == null ? "" : entry.value["teacher"]["user"]["last_name"]} - ${entry.value["teacher"]["id"]}"
                                : translate(Get.context!).not_available,
                          };
                        }).toList(),
                  tabs: const [],
                  pageType: "quran",
                  onEditPressed: (item, index) async {
                    addQuranFields[0]["value"] = item["juz"];
                    addQuranFields[1]["value"] = item["page"];
                    addQuranFields[2]["value"] = item["date"];
                    addQuranFields[3]["value"] = item["examiner"];
                    addQuranFields[4]["value"] = item["type"];
                    addQuranFields[5]["value"] = item["score"];
                    Navigator.of(context).push(createRoute(
                      AddPage(
                        englishTitle: "edit_quran_quizz",
                        isEdit: true,
                        fields: addQuranFields,
                        title: translate(Get.context!).editQuranicAchievement,
                        onPressed: () async {
                          Map result = await ApiService().editStudentQuran({
                            "id": item["id"],
                            "name": "${translate(Get.context!).juz}: ${addQuranFields[0]["value"]}",
                            "juz": addQuranFields[0]["value"],
                            "score": addQuranFields[5]["value"],
                            "page": addQuranFields[1]["value"],
                            "type": getExamTypeKey(context, addQuranFields[4]["value"]),
                            "date": addQuranFields[2]["value"],
                            "examiner": addQuranFields[3]["value"],
                            "student_id": student["id"],
                            "teacher_id": int.parse(addQuranFields[3]["value"].split(" - ")[1])
                          }, jsonDecode(authService.user.toUser())["token"]);
                          if (result["api"] == "SUCCESS") {
                            setState(() {
                              student["quran_quizzes"].removeAt(index);
                              student["quran_quizzes"].insert(index, result["data"]);
                              getStudent();
                            });
                          }
                          return result["api"];
                        },
                      ),
                    ));
                  },
                  onDeletePressed: (item, index) async {
                    showCustomDialog(context, translate(Get.context!).confirm_delete, AppConstants.appLogo, "delete", () async {
                      if (isConnected) {
                        Map result = await ApiService().deleteStudentQuran(item["id"], jsonDecode(authService.user.toUser())["token"]);

                        if (result["api"] == "SUCCESS") {
                          setState(() {
                            student["quran_quizzes"].removeAt(index);
                          });
                        }
                        return result["api"];
                      } else {
                        if (item["id"] == null || item["id"] == "null") {
                          setState(() {
                            allQurans.removeWhere((element) => element["removeItem"] == item["removeItem"]);
                            qurans.removeWhere((element) => element["removeItem"] == item["removeItem"]);

                            PrefUtils.setQuran(jsonEncode(allQurans));
                          });
                          return "SUCCESS";
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(translate(Get.context!).cannotDeleteOffline, style: TextStyle(fontFamily: getFontName(context))),
                            duration: const Duration(milliseconds: 500),
                          ));
                          return "FAILED";
                        }
                      }
                    });
                  },
                ),

                if (user["role"] != "student")
                  ListViewComponent(
                    isClickable: true,
                    permmission: user["role"] == "admin" ||
                        user['role'] == "branch_admin" ||
                        user["role"] == "property_admin" ||
                        (user["role"] == "teacher" && user["class_room_id"] == widget.details["class_room_id"]),
                    onRefresh: () async {
                      getStudent();
                    },
                    searchController: widget.searchController,
                    controller: tabIndex == 3 ? widget.scrollController : ScrollController(),
                    list: student["interviews"] == null
                        ? []
                        : student["interviews"].where((e) => e["type"] != "book").toList().asMap().entries.map((entry) {
                            return {
                              "id": entry.value["id"],
                              "name": entry.value["name"] ?? translate(Get.context!).not_available,
                              "description": entry.value["goal"],
                              "comment": entry.value["comment"],
                              "score": entry.value["score"],
                              "type":
                                  entry.value["type"] == "book" ? translate(Get.context!).book : getInterviewTypeValue(context, entry.value["type"]),
                              "date":
                                  "${entry.value["date"].split(" ")[0] ?? translate(Get.context!).not_available} / ${entry.value["teacher"] != null ? "${entry.value["teacher"]["user"]["first_name"]} ${entry.value["teacher"]["user"]["last_name"]} - ${entry.value["teacher"]["id"]}" : translate(Get.context!).not_available}",
                              "time": entry.value["date"]?.split(" ").length == 0 ? "" : entry.value["date"]?.split(" ")[1],
                              "event_place": entry.value["event_place"] ?? translate(Get.context!).not_available,
                              "goal": entry.value["goal"] ?? translate(Get.context!).not_available,
                            };
                          }).toList(),
                    onTap: () {
                      addInterviewFields.removeWhere((element) => element["title"] == translate(Get.context!).studentName);
                    },
                    addPage: AddPage(
                      englishTitle: "add_interview",
                      isEdit: false,
                      fields: addInterviewFields,
                      title: translate(Get.context!).addInterview,
                      onPressed: () async {
                        Map result = await ApiService().createStudentInterview({
                          "id": null,
                          "name": addInterviewFields[0]["value"],
                          "event_place": addInterviewFields[2]["value"],
                          "date":
                              "${addInterviewFields[3]["value"].toString().trim()} ${addInterviewFields[4]["value"].toString().trim().replaceAll(" ", "")}",
                          "goal": "${addInterviewFields[1]["value"]}",
                          "comment": addInterviewFields[7]["value"],
                          "score": addInterviewFields[8]["value"],
                          "type": getInterviewTypeKey(context, addInterviewFields[5]["value"]),
                          "student_id": student["id"],
                          "teacher_id": addInterviewFields[6]["value"].split(' - ')[1],
                        }, jsonDecode(authService.user.toUser())["token"]);
                        getStudent();
                        return AppFunctions().getUserErrorMessage(result, context);
                      },
                    ),
                    tabs: const [],
                    onEditPressed: (item, index) async {
                      addInterviewFields[0]["value"] = item["name"];
                      addInterviewFields[1]["value"] = item["goal"];
                      addInterviewFields[2]["value"] = item["event_place"];
                      addInterviewFields[3]["value"] = item["date"].split(" / ")[0];
                      addInterviewFields[4]["value"] = item["time"];
                      addInterviewFields[5]["value"] = getInterviewTypeValue(context, item["type"]);
                      addInterviewFields[6]["value"] = item["date"].split(" / ")[1];
                      addInterviewFields[7]["value"] = item["comment"];
                      addInterviewFields[8]["value"] = item["score"];
                      Navigator.of(context).push(createRoute(
                        AddPage(
                          englishTitle: "edit_interview",
                          isEdit: true,
                          fields: addInterviewFields,
                          title: translate(Get.context!).editInterview,
                          onPressed: () async {
                            Map result = await ApiService().editStudentBookInterview({
                              "id": item["id"],
                              "name": addInterviewFields[0]["value"],
                              "event_place": addInterviewFields[2]["value"],
                              "mainImage": null,
                              "date":
                                  "${addInterviewFields[3]["value"].toString().trim()} ${addInterviewFields[4]["value"].toString().trim().replaceAll(" ", "")}",
                              "goal": "${addInterviewFields[1]["value"]}",
                              "comment": addInterviewFields[7]["value"],
                              "type": getInterviewTypeKey(context, addInterviewFields[5]["value"]),
                              "student_id": student["id"],
                              "score": addInterviewFields[8]["value"],
                              "teacher_id": addInterviewFields[6]["value"].split(' - ')[1],
                            }, jsonDecode(authService.user.toUser())["token"]);

                            if (result["api"] == "SUCCESS") {
                              getStudent();
                            }
                            return AppFunctions().getUserErrorMessage(result, context);
                          },
                        ),
                      ));
                    },
                    onDeletePressed: (item, index) async {
                      showCustomDialog(context, translate(Get.context!).confirm_delete, AppConstants.appLogo, "delete", () async {
                        Map result = await ApiService().deleteStudentInterview(item["id"], jsonDecode(authService.user.toUser())["token"]);

                        if (result["api"] == "SUCCESS") {
                          setState(() {
                            student["interviews"].removeAt(index);
                          });
                        }
                        return result["api"];
                      });
                    },
                    pageType: "interview",
                  ),
                ListViewComponent(
                  onRefresh: () async {
                    getStudent();
                  },
                  searchController: widget.searchController,
                  controller: tabIndex == 3 ? widget.scrollController : ScrollController(),
                  isClickable: true,
                  permmission: user["role"] == "admin" ||
                      user['role'] == "branch_admin" ||
                      user["role"] == "property_admin" ||
                      (user["role"] == "teacher" && user["class_room_id"] == widget.details["class_room_id"]),
                  list: student["interviews"] == null
                      ? []
                      : student["interviews"].where((e) => e["type"] == "book").toList().asMap().entries.map((entry) {
                          return {
                            "id": entry.value["id"],
                            "name": entry.value["name"] ?? translate(Get.context!).not_available,
                            "description": entry.value["goal"],
                            "image": entry.value["image"],
                            "type": entry.value["goal"] ?? translate(Get.context!).not_available,
                            "date":
                                "${entry.value["date"].split(" ")[0] ?? translate(Get.context!).not_available} / ${entry.value["teacher"] != null ? "${entry.value["teacher"]["user"]["first_name"]} ${entry.value["teacher"]["user"]["last_name"]} - ${entry.value["teacher"]["id"]}" : translate(Get.context!).not_available}",
                            "time": entry.value["date"].split(" ")[1] ?? translate(Get.context!).not_available,
                            "event_place": entry.value["event_place"] ?? translate(Get.context!).not_available,
                            "goal": entry.value["goal"] ?? translate(Get.context!).not_available,
                            "score": entry.value["score"] ?? translate(Get.context!).not_available,
                            "comment": entry.value["comment"] ?? translate(Get.context!).not_available,
                          };
                        }).toList(),
                  addPage: AddPage(
                    englishTitle: "add_book_interview",
                    isEdit: false,
                    fields: addBookInterviewFields,
                    title: translate(Get.context!).addBookInterview,
                    onPressed: () async {
                      Map result = await ApiService().createStudentBookInterview({
                        "id": null,
                        "name": addBookInterviewFields[0]["value"].split(' - ')[0],
                        "event_place": addBookInterviewFields[2]["value"],
                        "date":
                            "${addBookInterviewFields[3]["value"].toString().trim()} ${addBookInterviewFields[4]["value"].toString().trim().replaceAll(" ", "")}",
                        "goal": "${addBookInterviewFields[1]["value"]}",
                        "score": "${addBookInterviewFields[5]["value"]}",
                        "comment": addBookInterviewFields[7]["value"],
                        "mainImage": addBookInterviewFields[8]["value"].path == '' ? null : addBookInterviewFields[8]["value"]?.path,
                        "type": "book",
                        "student_id": student["id"],
                        "teacher_id": addBookInterviewFields
                            .firstWhere((element) => element["title"] == translate(Get.context!).interviewer)["value"]
                            .split(' - ')[1],
                      }, jsonDecode(authService.user.toUser())["token"]);
                      getStudent();
                      print("result$result");
                      Future.delayed(const Duration(seconds: 2), () {
                        if (result["api"] == "FAILED") Navigator.of(context).pop();
                      });

                      return AppFunctions().getUserErrorMessage(result, context);
                    },
                  ),
                  tabs: const [],
                  onEditPressed: (item, index) async {
                    showLoadingDialog(context);
                    await AppFunctions.getImageXFileByUrl(AppFunctions().getImage(item["image"])).then((value) {
                      addBookInterviewFields[0]["value"] = item["name"];
                      addBookInterviewFields[1]["value"] = item["goal"];
                      addBookInterviewFields[2]["value"] = item["event_place"];
                      addBookInterviewFields[3]["value"] = item["date"].split(" / ")[0];
                      addBookInterviewFields[4]["value"] = item["time"];
                      addBookInterviewFields[5]["value"] = item["score"];
                      addBookInterviewFields[6]["value"] = item["date"].split(" / ")[1];
                      addBookInterviewFields[7]["value"] = item["comment"];
                      addBookInterviewFields[8]["value"] = value;
                      Navigator.of(context).pop();
                      Navigator.of(context).push(createRoute(
                        AddPage(
                          englishTitle: "edit_book_interview",
                          isEdit: true,
                          fields: addBookInterviewFields,
                          title: translate(Get.context!).editBookInterview,
                          onPressed: () async {
                            Map result = await ApiService().editStudentBookInterview({
                              "id": item["id"],
                              "name": addBookInterviewFields[0]["value"].split(' - ')[0],
                              "event_place": addBookInterviewFields[2]["value"],
                              "date":
                                  "${addBookInterviewFields[3]["value"].toString().trim()} ${addBookInterviewFields[4]["value"].toString().trim().replaceAll(" ", "")}",
                              "goal": "${addBookInterviewFields[1]["value"]}",
                              "score": "${addBookInterviewFields[5]["value"]}",
                              "comment": addBookInterviewFields[7]["value"],
                              "mainImage": addBookInterviewFields[8]["value"].path == '' ? null : addBookInterviewFields[8]["value"]?.path,
                              "type": "book",
                              "student_id": student["id"],
                              "teacher_id": addBookInterviewFields
                                  .firstWhere((element) => element["title"] == translate(Get.context!).interviewer)["value"]
                                  .split(' - ')[1],
                            }, jsonDecode(authService.user.toUser())["token"]);

                            if (result["api"] == "SUCCESS") {
                              getStudent();
                            }
                            return AppFunctions().getUserErrorMessage(result, context);
                          },
                        ),
                      ));
                    });
                  },
                  onDeletePressed: (item, index) async {
                    showCustomDialog(context, translate(Get.context!).confirm_delete, AppConstants.appLogo, "delete", () async {
                      Map result = await ApiService().deleteStudentInterview(item["id"], jsonDecode(authService.user.toUser())["token"]);

                      if (result["api"] == "SUCCESS") {
                        setState(() {
                          student["interviews"].removeAt(index);
                        });
                      }
                      return result["api"];
                    });
                  },
                  pageType: "interview",
                ),

                ListViewComponent(
                  onRefresh: () async {
                    getStudent();
                  },
                  searchController: widget.searchController,
                  controller: tabIndex == 5 ? widget.scrollController : ScrollController(),
                  isAdding: false,
                  permmission: true,
                  addPage: null,
                  list: student["session_attendances"] == null
                      ? []
                      : student["session_attendances"].asMap().entries.map((entry) {
                          return {
                            "id": entry.value["session"] == null ? translate(Get.context!).not_available : entry.value["session"]["id"] ?? "",
                            "name": entry.value["session"] == null ? translate(Get.context!).not_available : entry.value["session"]["name"],
                            "type": entry.value["session"] == null ? translate(Get.context!).not_available : entry.value["session"]["subject_name"],
                            "description":
                                entry.value["session"] == null ? translate(Get.context!).not_available : entry.value["session"]["description"],
                            "date": entry.value["session"] == null
                                ? translate(Get.context!).not_available
                                : entry.value["session"]["start_at"] ?? translate(Get.context!).not_available,
                            "duration": entry.value["session"] == null
                                ? translate(Get.context!).not_available
                                : entry.value["session"]["duration"] ?? translate(Get.context!).not_available,
                            "place": entry.value["session"] == null
                                ? translate(Get.context!).not_available
                                : entry.value["session"]["place"] ?? translate(Get.context!).not_available,
                            "session_attendances": entry.value["session"] == null
                                ? translate(Get.context!).not_available
                                : entry.value["session"]["session_attendances"] ?? [],
                            "subject_name": entry.value["session"] == null
                                ? translate(Get.context!).not_available
                                : entry.value["session"]["subject_name"] ?? translate(Get.context!).not_available,
                          };
                        }).toList(),
                  tabs: const [],
                  pageType: "session",
                ),

                ListViewComponent(
                  onRefresh: () async {
                    getStudent();
                  },
                  searchController: widget.searchController,
                  controller: tabIndex == 5 ? widget.scrollController : ScrollController(),
                  isAdding: false,
                  permmission: true,
                  addPage: null,
                  list: student["unattended_sessions"] == null
                      ? []
                      : student["unattended_sessions"].asMap().entries.map((entry) {
                          return {
                            "id": entry.value["id"],
                            "name": entry.value["name"] ?? translate(Get.context!).not_available,
                            "type": entry.value["subject_name"] ?? entry.value["type"] ?? translate(Get.context!).not_available,
                            "description": entry.value["description"] ?? translate(Get.context!).not_available,
                            "date": entry.value["start_at"] ?? translate(Get.context!).not_available,
                            "duration": entry.value["duration"] ?? translate(Get.context!).not_available,
                            "place": entry.value["place"] ?? translate(Get.context!).not_available,
                            "session_attendances": entry.value["session_attendances"] ?? [],
                            "subject_name": entry.value["subject_name"] ?? translate(Get.context!).not_available,
                          };
                        }).toList(),
                  tabs: const [],
                  pageType: "session",
                ),
                ListViewComponent(
                  onRefresh: () async {
                    getStudent();
                  },
                  isClickable: true,
                  searchController: widget.searchController,
                  controller: tabIndex == 5 ? widget.scrollController : ScrollController(),
                  isAdding: false,
                  permmission: true,
                  addPage: null,
                  list: student["activity_participants"] == null
                      ? []
                      : student["activity_participants"].asMap().entries.map((entry) {
                          return {
                            "id": entry.value["activity"] == null ? translate(Get.context!).not_available : entry.value["activity"]["id"],
                            "name": entry.value["activity"] == null
                                ? translate(Get.context!).not_available
                                : entry.value["activity"]["name"] ?? translate(Get.context!).not_available,
                            "type": entry.value["activity"] == null
                                ? translate(Get.context!).not_available
                                : entry.value["activity"]["activity_type"] == null
                                    ? translate(Get.context!).not_available
                                    : "${entry.value["activity"]["activity_type"]["name"]} - ${entry.value["activity"]["activity_type"]["id"]}",
                            "description": entry.value["activity"] == null
                                ? translate(Get.context!).not_available
                                : entry.value["activity"]["note"] ?? translate(Get.context!).not_available,
                            "date": entry.value["activity"] == null
                                ? translate(Get.context!).not_available
                                : entry.value["activity"] == null
                                    ? translate(Get.context!).not_available
                                    : entry.value["activity"]["start_datetime"]?.split(" ")[0] ?? translate(Get.context!).not_available,
                            "place": entry.value["activity"] == null
                                ? translate(Get.context!).not_available
                                : entry.value["activity"]["place"] ?? translate(Get.context!).not_available,
                            "cost": entry.value["activity"] == null
                                ? translate(Get.context!).not_available
                                : entry.value["activity"]["cost"] ?? translate(Get.context!).not_available,
                            "participants": entry.value["activity"] == null ? [] : entry.value["activity"]["participants"] ?? [],
                            "examiner": entry.value["activity"] == null
                                ? translate(Get.context!).not_available
                                : entry.value["activity"]["teacher"] != null
                                    ? "${entry.value["activity"]["teacher"]["user"]["first_name"]} ${entry.value["activity"]["teacher"]["user"]["last_name"]} - ${entry.value["activity"]["teacher"]["id"]}"
                                    : translate(Get.context!).not_available,
                          };
                        }).toList(),
                  tabs: const [],
                  pageType: "activity",
                ),

                ListViewComponent(
                  onRefresh: () async {
                    getStudent();
                  },
                  isClickable: true,
                  searchController: widget.searchController,
                  controller: tabIndex == 5 ? widget.scrollController : ScrollController(),
                  isAdding: false,
                  permmission: true,
                  addPage: null,
                  list: student["unattended_activities"] == null
                      ? []
                      : student["unattended_activities"].asMap().entries.map((entry) {
                          return {
                            "id": entry.value["id"],
                            "name": entry.value["name"] ?? translate(Get.context!).not_available,
                            "type": entry.value["activity_type"] == null
                                ? translate(Get.context!).not_available
                                : "${entry.value["activity_type"]["name"]} - ${entry.value["activity_type"]["id"]}",
                            "description": entry.value["note"] ?? translate(Get.context!).not_available,
                            "date": entry.value["start_datetime"]?.split(" ")[0] ?? translate(Get.context!).not_available,
                            "place": entry.value["place"] ?? translate(Get.context!).not_available,
                            "cost": entry.value["cost"] ?? translate(Get.context!).not_available,
                            "participants": entry.value["participants"] ?? [],
                            "examiner": entry.value["teacher"] != null
                                ? "${entry.value["teacher"]["user"]["first_name"]} ${entry.value["teacher"]["user"]["last_name"]} - ${entry.value["teacher"]["id"]}"
                                : translate(Get.context!).not_available,
                          };
                        }).toList(),
                  tabs: const [],
                  pageType: "activity",
                ),
                if (user["role"] != "student")
                  ListViewComponent(
                    onRefresh: () async {
                      getStudent();
                    },
                    permmission: user["role"] == "admin" ||
                        user['role'] == "branch_admin" ||
                        user["role"] == "property_admin" ||
                        (user["role"] == "teacher" && user["class_room_id"] == widget.details["class_room_id"]),
                    isClickable: true,
                    searchController: widget.searchController,
                    controller: tabIndex == 6 ? widget.scrollController : ScrollController(),
                    addPage: AddPage(
                      englishTitle: "add_note",
                      isEdit: false,
                      fields: addNotesFields,
                      title: translate(Get.context!).addNote,
                      onPressed: () async {
                        Map result = await ApiService().createStudentNotes({
                          "admin_id": user["role"] == "teacher" ? null : jsonDecode(authService.user.toUser())["id"],
                          "admin_content": user["role"] == "teacher" ? null : addNotesFields[0]["value"],
                          "id": null,
                          "date": "${addNotesFields[1]["value"]} ${addNotesFields[2]["value"]}",
                          "teacher_content": user["role"] != "teacher" ? null : addNotesFields[0]["value"],
                          "student_id": student["id"],
                          "teacher_id": user["role"] != "teacher" ? null : jsonDecode(authService.user.toUser())["id"]
                        }, jsonDecode(authService.user.toUser())["token"]);
                        getStudent();

                        return result["api"];
                      },
                    ),
                    list: student["notes"] == null
                        ? []
                        : student["notes"].asMap().entries.map((entry) {
                            return {
                              "id": entry.value["id"],
                              "name": entry.value["teacher"] != null
                                  ? "${entry.value["teacher"]["user"]["first_name"]} ${entry.value["teacher"]["user"]["last_name"]} - ${entry.value["teacher"]["id"]}"
                                  : entry.value["admin"] != null
                                      ? "${entry.value["admin"]["user"]["first_name"]} ${entry.value["admin"]["user"]["last_name"]} - ${entry.value["admin"]["id"]}"
                                      : translate(Get.context!).not_available,
                              "description": entry.value["teacher_content"] ?? entry.value["admin_content"],
                              "type": entry.value["date"]?.split(" ")[1] ?? translate(Get.context!).not_available,
                              "date": entry.value["date"]?.split(" ")[0] ?? translate(Get.context!).not_available,
                              "student_id": student["id"],
                              "teacher_id": jsonDecode(authService.user.toUser())["id"],
                            };
                          }).toList(),
                    tabs: const [],
                    onEditPressed: (item, index) async {
                      addNotesFields[0]["value"] = item["description"];
                      addNotesFields[1]["value"] = item["date"];
                      addNotesFields[2]["value"] = item["type"];
                      Navigator.of(context).push(createRoute(
                        AddPage(
                          englishTitle: "edit_note",
                          isEdit: true,
                          fields: addNotesFields,
                          title: translate(Get.context!).editNote,
                          onPressed: () async {
                            Map result = await ApiService().editStudentNotes({
                              "id": item["id"],
                              "admin_id": user["role"] == "teacher" ? null : jsonDecode(authService.user.toUser())["id"],
                              "admin_content": user["role"] == "teacher" ? null : addNotesFields[0]["value"],
                              "date": "${addNotesFields[1]["value"]} ${addNotesFields[2]["value"]}",
                              "teacher_content": user["role"] != "teacher" ? null : addNotesFields[0]["value"],
                              "student_id": student["id"],
                              "teacher_id": user["role"] != "teacher" ? null : jsonDecode(authService.user.toUser())["id"]
                            }, jsonDecode(authService.user.toUser())["token"]);

                            if (result["api"] == "SUCCESS") {
                              getStudent();
                            }
                            return result["api"];
                          },
                        ),
                      ));
                    },
                    onDeletePressed: (item, index) async {
                      showCustomDialog(context, translate(Get.context!).confirm_delete, AppConstants.appLogo, "delete", () async {
                        Map result = await ApiService().deleteStudentNotes(item["id"], jsonDecode(authService.user.toUser())["token"]);

                        if (result["api"] == "SUCCESS") {
                          setState(() {
                            student["notes"].removeAt(index);
                          });
                        }
                        return result["api"];
                      });
                    },
                    pageType: "note",
                  ),
                ListViewComponent(
                  onRefresh: () async {
                    getStudent();
                  },
                  isClickable: true,
                  permmission: user["role"] == "admin" ||
                      user['role'] == "branch_admin" ||
                      user["role"] == "property_admin" ||
                      (user["role"] == "teacher" && user["class_room_id"] == widget.details["class_room_id"]),
                  searchController: widget.searchController,
                  controller: tabIndex == 4 ? widget.scrollController : ScrollController(),
                  addPage: AddPage(
                    englishTitle: "add_exam",
                    isEdit: false,
                    fields: addExamFields,
                    title: translate(Get.context!).addTest,
                    onPressed: () async {
                      Map result = await ApiService().createStudentExam({
                        "id": null,
                        "name": addExamFields[0]["value"],
                        "quiz_subject": addExamFields[1]["value"],
                        "date": "${addExamFields[2]["value"].toString().trim()} ${addExamFields[3]["value"].toString().trim().replaceAll(" ", "")}",
                        "time": addExamFields[3]["value"].toString().trim().replaceAll(" ", ""),
                        "quiz_type": getQuizTypeKey(context, "${addExamFields[4]["value"]}"),
                        "score": addExamFields[5]["value"],
                        "student_id": student["id"],
                        "teacher_id": jsonDecode(authService.user.toUser())["id"]
                      }, jsonDecode(authService.user.toUser())["token"]);

                      if (result["api"] == "SUCCESS") {
                        setState(() {
                          student["quizzes"].insert(0, result["data"]);
                        });
                      }

                      return result["api"];
                    },
                  ),
                  list: student["quizzes"] == null
                      ? []
                      : student["quizzes"].asMap().entries.map((entry) {
                          return {
                            "id": entry.value["id"],
                            "name": "${entry.value["name"]} , المادة: ${entry.value["quiz_subject"]}",
                            "description":
                                "${translate(Get.context!).studentGradeInExam} ${entry.value["score"] ?? translate(Get.context!).not_available}",
                            "type": getQuizTypeValue(context, entry.value["quiz_type"]),
                            "date": entry.value["date"]?.split(" ")[0] ?? translate(Get.context!).not_available,
                            "time": entry.value["time"] ?? translate(Get.context!).not_available,
                            "score": entry.value["score"] ?? translate(Get.context!).not_available,
                            "quiz_subject": entry.value["quiz_subject"] ?? translate(Get.context!).not_available,
                          };
                        }).toList(),
                  tabs: const [],
                  pageType: "exam",
                  onEditPressed: (item, index) async {
                    addExamFields[0]["value"] = item["name"].split(",")[0];
                    addExamFields[1]["value"] = item["quiz_subject"];
                    addExamFields[2]["value"] = item["date"];
                    addExamFields[3]["value"] = item["time"];
                    addExamFields[4]["value"] = item["type"];
                    addExamFields[5]["value"] = item["score"];
                    Navigator.of(context).push(createRoute(
                      AddPage(
                        englishTitle: "edit_exam",
                        isEdit: true,
                        fields: addExamFields,
                        title: translate(Get.context!).editTest,
                        onPressed: () async {
                          Map result = await ApiService().editStudentExam({
                            "id": item["id"],
                            "name": addExamFields[0]["value"],
                            "quiz_subject": addExamFields[1]["value"],
                            "date":
                                "${addExamFields[2]["value"].toString().trim()} ${addExamFields[3]["value"].toString().trim().replaceAll(" ", "")}",
                            "time": addExamFields[3]["value"].toString().trim().replaceAll(" ", ""),
                            "quiz_type": getQuizTypeKey(context, "${addExamFields[4]["value"]}"),
                            "score": addExamFields[5]["value"],
                            "student_id": student["id"],
                            "teacher_id": jsonDecode(authService.user.toUser())["id"]
                          }, jsonDecode(authService.user.toUser())["token"]);
                          if (result["api"] == "SUCCESS") {
                            setState(() {
                              student["quizzes"].removeAt(index);
                              student["quizzes"].insert(index, result["data"]);
                            });
                          }
                          return result["api"];
                        },
                      ),
                    ));
                  },
                  onDeletePressed: (item, index) async {
                    showCustomDialog(context, translate(Get.context!).confirm_delete, AppConstants.appLogo, "delete", () async {
                      Map result = await ApiService().deleteStudentExam(item["id"], jsonDecode(authService.user.toUser())["token"]);

                      if (result["api"] == "SUCCESS") {
                        setState(() {
                          student["quizzes"].removeAt(index);
                        });
                      }
                      return result["api"];
                    });
                  },
                ),

                staticsFuture == null
                    ? const NoData()
                    : Statistics(
                        future: staticsFuture,
                        controller: tabIndex == 7 ? widget.scrollController : ScrollController(),
                        type: "student",
                      ),
                // QrPage(code: student["user"]["qr_code"] ?? ""),
              ]));
  }
}
