import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hudayi/main.dart';
import 'package:hudayi/models/Languageprovider.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/screens/add/addTimes.dart';
import 'package:hudayi/screens/profiles/profilePage.dart';
import 'package:hudayi/services/API/api.dart';
import 'package:hudayi/services/pref_utils.dart';
import 'package:hudayi/ui/helper/AppColors.dart';
import 'package:hudayi/ui/helper/AppConstants.dart';
import 'package:hudayi/ui/helper/AppConsts.dart';
import 'package:hudayi/ui/helper/AppDialog.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/helper/AppIcons.dart';
import 'package:hudayi/ui/styles/appBoxShadow.dart';
import 'package:hudayi/ui/widgets/CirculeProgress.dart';
import 'package:hudayi/ui/widgets/anmiation_card.dart';
import 'package:hudayi/ui/widgets/dropDownBottomSheet.dart';
import 'package:hudayi/ui/widgets/gridViewList.dart';
import 'package:hudayi/ui/widgets/listViewComponent.dart';
import 'package:hudayi/ui/widgets/noData.dart';
import 'package:hudayi/ui/widgets/statistics.dart';
import 'package:provider/provider.dart';

class SubClassProfile extends StatefulWidget {
  final TextEditingController searchController;
  final ScrollController scrollController;
  final TabController tabController;
  final Map details;
  const SubClassProfile(
      {super.key, required this.searchController, required this.scrollController, required this.tabController, required this.details});

  @override
  State<SubClassProfile> createState() => _SubClassProfileState();
}

class _SubClassProfileState extends State<SubClassProfile> {
  int tabIndex = 0;
  Map classRoomGroup = {};
  Map teacher = {};
  List studentsWithoutClass = [];
  List books = [];
  List sessions = [];
  List teachersWithoutClass = [];
  Future? staticsFuture;
  var authService;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  Map user = {};
  getGroupDetails() async {
    classRoomGroup.clear();
    String sessionGroup = await PrefUtils.getSession() ?? "";
    sessions = sessionGroup == "" ? [] : jsonDecode(await PrefUtils.getSession());
    String group = await PrefUtils.getGroups() ?? "";
    List groupsLocale = group == "" ? [] : jsonDecode(await PrefUtils.getGroups());
    if (isConnected != false) {
      groupsLocale.removeWhere((element) => element["grade_id"] == widget.details["id"]);

      ApiService().getClassGroupDetails(widget.details["id"], jsonDecode(authService.user.toUser())["token"]).then((data) {
        if (data != null) {
          if (mounted) {
            setState(() {
              ApiService()
                  .getBooks(jsonDecode(authService.user.toUser())["token"], property_type: widget.details["classType"] == "mosque" ? "جامع" : "مدرسة")
                  .then((book) {
                books.addAll(book["data"] ?? []);
                PrefUtils.setBooks(jsonEncode(data["data"]["books"]));
                addLessonFields.removeWhere((element) => element["title"] == translate(Get.context!).lessonBook);
                List bookss = List.from(data["data"]["books"] ?? []);
                bookss.removeWhere((e) => e["book_type"] == translate(Get.context!).cultural);
                addLessonFields.insert(
                  4,
                  {
                    "type": "oneSelection",
                    "value": null,
                    "title": translate(Get.context!).lessonBook,
                    "selections": data["data"]["books"] == null ? [] : bookss.map((e) => '${e["name"]}/${e["book_type"]} - ${e["id"]}').toList(),
                  },
                );
              });
              List? classRoomStudents = data["data"]["class_room_students"].where((item) => item["left_at"] == null).toList() ?? [];
              print("classRoomStudents${classRoomStudents?.where((e) => e["student"]?["user"]?["status"].toString() == "1")}");
              PrefUtils.setProprtyStudents(jsonEncode(classRoomStudents));
              addActivityFields.removeWhere((element) => element["title"] == translate(Get.context!).present_students);
              addActivityFields.insert(
                3,
                {
                  "type": "multipleSelection",
                  "value": null,
                  "title": translate(Get.context!).present_students,
                  "selections": classRoomStudents == null
                      ? []
                      : classRoomStudents
                          .where((e) => (e["student"]?["user"]?["status"].toString() == "1"))
                          .map((e) =>
                              '${e["name"] ?? e["student"]["user"]["first_name"]} ${e["student"]["user"]["last_name"] ?? ""} - ${e["student"]["id"]}')
                          .toList()
                },
              );

              addLessonFields.removeWhere((element) => element["title"] == translate(Get.context!).present_students);
              addLessonFields.insert(
                5,
                {
                  "type": "multipleSelection",
                  "value": null,
                  "title": translate(Get.context!).present_students,
                  "selections": classRoomStudents == null
                      ? []
                      : classRoomStudents
                          .where((e) => e["student"]?["user"]?["status"].toString() == "1")
                          .map((e) =>
                              '${e["name"] ?? e["student"]["user"]["first_name"]} ${e["student"]["user"]["last_name"] ?? ""} - ${e["student"]["id"]}')
                          .toList()
                },
              );
              classRoomGroup.clear();
              classRoomGroup.addAll(data["data"]);
              teacher.addAll(classRoomGroup["class_room_teachers"].firstWhere((e) => e["left_at"] == null, orElse: () => {}) ?? {});
              PrefUtils.setGroups(jsonEncode([
                ...groupsLocale,
                {"grade_id": widget.details["id"], "groups": data["data"]}
              ]));
            });
          }
        }
      });
    } else {
      List gradeGrpup = jsonDecode(await PrefUtils.getGroups());
      Map list = gradeGrpup.firstWhere((element) => element["grade_id"] == widget.details["id"])["groups"] ?? [];
      setState(() {
        classRoomGroup.addAll(list);
        teacher.addAll(classRoomGroup["class_room_teachers"].firstWhere((e) => e["left_at"] == null, orElse: () => {}) ?? {});
      });
    }
  }

  getStudnets() {
    List student = [];

    student = addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).present_students)["value"].split(',').toList();

    if (student.isEmpty)
      student =
          addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).present_students)["value"].split(' , ').toList();

    return student;
  }

  getSrudentWithoutClass() {
    studentsWithoutClass.clear();
    ApiService().getStudentsWithoutClass(widget.details["property_id"], jsonDecode(authService.user.toUser())["token"]).then((data) {
      setState(() {
        studentsWithoutClass.addAll(data["data"]);
      });
    });
  }

  getTeacherWithoutClass() {
    teachersWithoutClass.clear();
    ApiService().getTeacherWithoutClass(widget.details["property_id"], jsonDecode(authService.user.toUser())["token"]).then((data) {
      setState(() {
        teachersWithoutClass.addAll(data["data"]);
      });
    });
  }

  List class_rooms = [];
  getClass() async {
    ApiService().getClassDetails(widget.details["grade_id"], jsonDecode(authService.user.toUser())["token"]).then((value) {
      setState(() {
        value["data"]["class_rooms"].removeWhere((e) => e["id"] == widget.details["id"]);

        class_rooms.addAll(value["data"]["class_rooms"]);
      });
    });
  }

  @override
  void initState() {
    authService = Provider.of<AuthService>(context, listen: false);
    getGroupDetails();
    user.addAll(jsonDecode(authService.user.toUser()));

    if (isConnected) {
      FirebaseAnalytics.instance.logEvent(
        name: 'class_room_profile_page',
        parameters: {
          'screen_name': "class_room_profile_page",
          'screen_class': "profile",
        },
      );
      getClass();
      staticsFuture = ApiService().getClassRoomStatics(widget.details["id"], jsonDecode(authService.user.toUser())["token"]);

      ApiService().getPropertyTeacher(widget.details["property_id"], jsonDecode(authService.user.toUser())["token"]).then((data) {
        //teachersWithoutClass.addAll(data == null ? [] : data["data"]);
        setState(() {
          addActivityFields.removeWhere((element) => element["title"] == translate(Get.context!).teacherOrActivitySupervisor);
          addActivityFields.insert(4, {
            "type": "oneSelection",
            "value": null,
            "title": translate(Get.context!).teacherOrActivitySupervisor,
            "selections": data["data"] == null ? [] : data["data"].map((e) => '${e["name"]} - ${e["id"]}').toList()
          });
        });
      });
      ApiService().getPropertyTeacher(widget.details["property_id"], jsonDecode(authService.user.toUser())["token"]).then((teachers) {
        PrefUtils.setProprtyTeachers(jsonEncode(teachers["data"]));
        addLessonFields.removeWhere((element) => element["title"] == translate(Get.context!).lessonTeacher);
        addLessonFields.insert(
          6,
          {
            "type": "oneSelection",
            "value": null,
            "title": translate(Get.context!).lessonTeacher,
            "selections": teachers["data"] == null ? [] : teachers["data"].map((e) => '${e["name"]} - ${e["id"]}').toList()
          },
        );
      });

      getSrudentWithoutClass();
      ApiService().getSubjects(jsonDecode(authService.user.toUser())["token"]).then((data) {
        PrefUtils.setSubjects(jsonEncode(data["data"]));
        setState(() {
          addLessonFields.removeWhere((element) => element["title"] == translate(Get.context!).lessonType);
          addLessonFields.insert(
            3,
            {
              "type": "oneSelection",
              "value": null,
              "title": translate(Get.context!).lessonType,
              "selections": data["data"] == null ? [] : data["data"].map((e) => '${e["name"]}').toList()
            },
          );
        });
      });

      getTeacherWithoutClass();

      ApiService().getActivityTypes(jsonDecode(authService.user.toUser())["token"]).then((data) {
        setState(() {
          addActivityFields.removeWhere((element) => element["title"] == translate(Get.context!).activity_type);
          addActivityFields.insert(
            5,
            {
              "type": "oneSelection",
              "value": null,
              "title": translate(Get.context!).activity_type,
              "selections": data["data"] == null ? [] : data["data"]["data"].map((e) => "${e["name"]} - ${e["id"]}").toList()
            },
          );
        });
      });
    } else {
      () async {
        String teacherGroup = await PrefUtils.getProprtyTeachers() ?? "";
        List teachers = teacherGroup == "" ? [] : jsonDecode(await PrefUtils.getProprtyTeachers() ?? "[]") ?? [];
        addLessonFields.removeWhere((element) => element["title"] == translate(Get.context!).lessonTeacher);
        addLessonFields.insert(
          6,
          {
            "type": "oneSelection",
            "value": null,
            "title": translate(Get.context!).lessonTeacher,
            "selections": teachers.map((e) => '${e["name"]} - ${e["id"]}').toList()
          },
        );

        String studentGroup = await PrefUtils.getProprtyStudents() ?? "";
        List students = teacherGroup == "" ? [] : jsonDecode(await PrefUtils.getProprtyStudents() ?? "[]") ?? [];
        addLessonFields.removeWhere((element) => element["title"] == translate(Get.context!).present_students);
        addLessonFields.insert(
          5,
          {
            "type": "multipleSelection",
            "value": null,
            "title": translate(Get.context!).present_students,
            "selections": students
                .where((e) => e["student"]["user"]["status"].toString() == "1")
                .map((e) => '${e["name"] ?? e["student"]["user"]["first_name"]} ${e["student"]["user"]["last_name"] ?? ""} - ${e["student"]["id"]}')
                .toList()
          },
        );

        String subejctsGroup = await PrefUtils.getSubjects() ?? "";
        List subjects = subejctsGroup == "" ? [] : jsonDecode(await PrefUtils.getSubjects() ?? "[]") ?? [];
        addLessonFields.removeWhere((element) => element["title"] == translate(Get.context!).lessonType);
        addLessonFields.insert(
          3,
          {
            "type": "oneSelection",
            "value": null,
            "title": translate(Get.context!).lessonType,
            "selections": subjects.map((e) => '${e["name"]}').toList()
          },
        );

        String booksGroup = await PrefUtils.getBooks() ?? "";
        List books = booksGroup == "" ? [] : jsonDecode(await PrefUtils.getBooks() ?? "[]") ?? [];
        addLessonFields.removeWhere((element) => element["title"] == translate(Get.context!).lessonBook);
        books.removeWhere((e) => e["book_type"] == translate(Get.context!).cultural);
        addLessonFields.insert(
          4,
          {
            "type": "oneSelection",
            "value": null,
            "title": translate(Get.context!).lessonBook,
            "selections": books.map((e) => '${e["name"]}/${e["book_type"]} - ${e["id"]}').toList(),
          },
        );
      }();
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
    return Expanded(
        child: classRoomGroup.isEmpty
            ? const CirculeProgress()
            : TabBarView(physics: const BouncingScrollPhysics(), controller: widget.tabController, children: [
                Column(
                  children: [
                    if (isConnected)
                      if (user["role"] == "admin" ||
                          user['role'] == "branch_admin" ||
                          user["role"] == "property_admin" ||
                          (user["role"] == "teacher" && user["class_room_id"] == widget.details["id"]))
                        Padding(
                            padding: const EdgeInsets.only(top: 14.0),
                            child: teacher.isNotEmpty
                                ? // Generated code for this menuItem Widget...
                                GestureDetector(
                                    onTap: () {},
                                    child: TeacherContainer(
                                      authService: authService,
                                      type: "teacher",
                                      teacher: teacher,
                                      teachersWithoutClass: teachersWithoutClass,
                                      id: widget.details["id"],
                                      onEditPressed: (item) async {
                                        dropDown(
                                            context,
                                            teachersWithoutClass
                                                .map((e) => '${e["name"] ?? e["first_name"]} ${e["last_name"] ?? ""} - ${e["id"]}')
                                                .toList(),
                                            false,
                                            []).then((value) async {
                                          if (value != null) {
                                            showLoadingDialog(context);
                                            Map result = await ApiService().editClassRoomTeacher({
                                              "id": teacher["id"],
                                              "class_room_id": widget.details["id"],
                                              "teacher_id": value.toString().split(" - ")[1],
                                              "joined_at": DateTime.now().toString(),
                                            }, jsonDecode(authService.user.toUser())["token"]);
                                            String status = result["api"];
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            if (status == "SUCCESS") {
                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text(translate(Get.context!).operationCompletedSuccessfully,
                                                    style: TextStyle(fontFamily: getFontName(context))),
                                                duration: const Duration(milliseconds: 500),
                                              ));
                                              Future.delayed(const Duration(seconds: 1), () {
                                                Navigator.of(context).pop();
                                                getGroupDetails();
                                                getTeacherWithoutClass();
                                              });
                                            } else if (status == "FAILED") {
                                              // ignore: use_build_context_synchronously
                                              Navigator.of(context).pop();
                                              await FirebaseAnalytics.instance.logEvent(
                                                name: "an_expected_error_occured_while_editClassRoomTeacher_${result["hints"].toString()}",
                                                parameters: {
                                                  'screen_name': "an_expected_error_occured_while_editClassRoomTeacher_${result["hints"].toString()}",
                                                  'screen_class': "Adding",
                                                },
                                              );
                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text(translate(Get.context!).unexpected_error,
                                                    style: TextStyle(fontFamily: getFontName(context))),
                                                duration: const Duration(milliseconds: 500),
                                              ));
                                            }
                                          }
                                        });
                                      },
                                      onDeletePressed: (item) async {
                                        showCustomDialog(context, translate(Get.context!).confirm_delete, AppConstants.appLogo, "delete", () async {
                                          Map result = await ApiService()
                                              .deleteClassroomTeachers(teacher["id"], jsonDecode(authService.user.toUser())["token"]);
                                          if (result["api"] == "SUCCESS") {
                                            teacher = {};
                                          }
                                          getGroupDetails();
                                          return result["api"];
                                        });
                                      },
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      dropDown(
                                          context,
                                          teachersWithoutClass
                                              .map((e) => '${e["name"] ?? "${e["first_name"]} ${e["last_name"]}"} - ${e["id"]}')
                                              .toList(),
                                          false,
                                          []).then((value) async {
                                        if (value != null) {
                                          showLoadingDialog(context);
                                          Map result = await ApiService().addClassRoomTeacher({
                                            "id": null,
                                            "class_room_id": widget.details["id"],
                                            "teacher_id": value.toString().split(" - ")[1],
                                            "joined_at": DateTime.now().toString(),
                                            "left_at": null
                                          }, jsonDecode(authService.user.toUser())["token"]);
                                          String status = result["api"];
                                          FocusManager.instance.primaryFocus?.unfocus();
                                          if (status == "SUCCESS") {
                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content:
                                                  Text(translate(Get.context!).operation_success, style: TextStyle(fontFamily: getFontName(context))),
                                              duration: const Duration(milliseconds: 500),
                                            ));
                                            Future.delayed(const Duration(seconds: 1), () {
                                              Navigator.of(context).pop();
                                              getGroupDetails();
                                              getTeacherWithoutClass();
                                            });
                                          } else if (status == "FAILED") {
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();
                                            await FirebaseAnalytics.instance.logEvent(
                                              name: "an_expected_error_occured_while_addClassRoomTeacher_${result["hints"].toString()}",
                                              parameters: {
                                                'screen_name': "an_expected_error_occured_while_addClassRoomTeacher_${result["hints"].toString()}",
                                                'screen_class': "Adding",
                                              },
                                            );
                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content:
                                                  Text(translate(Get.context!).unexpected_error, style: TextStyle(fontFamily: getFontName(context))),
                                              duration: const Duration(milliseconds: 500),
                                            ));
                                          }
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 0, bottom: 4),
                                      child: Container(
                                          height: 85,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(15),
                                            boxShadow: [AppBoxShadow.containerBoxShadow],
                                          ),
                                          child: Center(
                                              child: Text(
                                            translate(Get.context!).add_teacher,
                                            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                                          ))),
                                    ),
                                  )),
                    Expanded(
                      child: GridViewList(
                        searchController: widget.searchController,
                        controller: tabIndex == 0 ? widget.scrollController : ScrollController(),
                        permmission: user["role"] == "admin" ||
                            user['role'] == "branch_admin" ||
                            user["role"] == "property_admin" ||
                            (user["role"] == "teacher" && user["class_room_id"] == widget.details["id"]),
                        addPage: null,
                        onRefresh: () async {
                          getGroupDetails();
                        },
                        onTap: () {
                          dropDown(context, studentsWithoutClass.map((e) => '${e["first_name"]} ${e["last_name"]} - ${e["id"]}').toList(), false, [])
                              .then((value) async {
                            if (value != null) {
                              showLoadingDialog(context);
                              Map result = await ApiService().addClassroomStudent({
                                "id": null,
                                "class_room_id": widget.details["id"],
                                "student_id": [value.toString().split(" - ")[1]],
                                "joined_at": DateTime.now().toString(),
                                "left_at": null
                              }, jsonDecode(authService.user.toUser())["token"]);
                              String status = result["api"];
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (status == "SUCCESS") {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(translate(Get.context!).operation_success, style: TextStyle(fontFamily: getFontName(context))),
                                  duration: const Duration(milliseconds: 500),
                                ));
                                Future.delayed(const Duration(seconds: 1), () {
                                  Navigator.of(context).pop();
                                  getGroupDetails();
                                  getSrudentWithoutClass();
                                });
                              } else if (status == "FAILED") {
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                                await FirebaseAnalytics.instance.logEvent(
                                  name: "an_expected_error_occured_while_addClassroomStudent_${result["hints"].toString()}",
                                  parameters: {
                                    'screen_name': "an_expected_error_occured_while_addClassroomStudent_${result["hints"].toString()}",
                                    'screen_class': "Adding",
                                  },
                                );
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(translate(Get.context!).unexpected_error, style: TextStyle(fontFamily: getFontName(context))),
                                  duration: const Duration(milliseconds: 500),
                                ));
                              }
                            }
                          });
                        },
                        onTransferPressed: jsonDecode(authService.user.toUser())["role"] == "teacher"
                            ? null
                            : (item, index) async {
                                List classRooms = class_rooms.asMap().entries.map((entry) {
                                  return {
                                    "id": entry.value["id"],
                                    "name": entry.value["name"],
                                  };
                                }).toList();
                                dropDown(context, classRooms.map((e) => '${e["name"]} - ${e["id"]}').toList(), false, []).then((value) async {
                                  if (value != null) {
                                    showLoadingDialog(context);
                                    Map result = await ApiService().transferStudent({
                                      "studnet_id": item["id"],
                                      "new_property_id": item["property_id"],
                                      "new_class_id": int.parse(value.toString().split(" - ")[1]),
                                    }, jsonDecode(authService.user.toUser())["token"]);
                                    print(result);
                                    String status = result["api"];
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    if (status == "SUCCESS") {
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(translate(Get.context!).operation_success, style: TextStyle(fontFamily: getFontName(context))),
                                        duration: const Duration(milliseconds: 500),
                                      ));
                                      Future.delayed(const Duration(seconds: 1), () {
                                        Navigator.of(context).pop();
                                        getGroupDetails();
                                        getSrudentWithoutClass();
                                      });
                                    } else if (status == "FAILED") {
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                      await FirebaseAnalytics.instance.logEvent(
                                        name: "an_expected_error_occured_while_transferStudent_${result["hints"].toString()}",
                                        parameters: {
                                          'screen_name': "an_expected_error_occured_while_transferStudent_${result["hints"].toString()}",
                                          'screen_class': "Adding",
                                        },
                                      );
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(translate(Get.context!).unexpected_error, style: TextStyle(fontFamily: getFontName(context))),
                                        duration: const Duration(milliseconds: 500),
                                      ));
                                    }
                                  }
                                });
                              },
                        onEditPressed: (item, index) async {
                          showLoadingDialog(context);
                          await ApiService().getStudentDetails(item["id"], jsonDecode(authService.user.toUser())["token"]).then((data) async {
                            if (data != null && data["data"] != null) {
                              await AppFunctions.getImageXFileByUrl(AppFunctions().getImage(data["data"]["user"]["image"])).then((value) {
                                addStudentsFields[15]["value"] = value;
                                addStudentsFields[1]["value"] = data["data"]["user"]["username"];
                                addStudentsFields[2]["value"] = data["data"]["user"]["password"];
                                addStudentsFields[3]["value"] = data["data"]["user"]["first_name"];
                                addStudentsFields[4]["value"] = data["data"]["user"]["last_name"];
                                addStudentsFields[5]["value"] = data["data"]["user"]["father_name"];
                                addStudentsFields[6]["value"] = data["data"]["user"]["mother_name"];
                                addStudentsFields[7]["value"] = data["data"]["user"]["birth_date"]?.split("T")[0];
                                addStudentsFields[8]["value"] = getGenderValue(context, data["data"]["user"]["gender"]);
                                addStudentsFields[9]["value"] = data["data"]["parent_phone"] == "null" ? null : data["data"]["parent_phone"];
                                addStudentsFields[10]["value"] = data["data"]["user"]["phone"] == "null" ? null : data["data"]["user"]["phone"];
                                addStudentsFields[11]["value"] = data["data"]["user"]["identity_number"];
                                addStudentsFields[12]["value"] = data["data"]["user"]["birth_place"];
                                addStudentsFields[13]["value"] = data["data"]["user"]["email"];
                                addStudentsFields[14]["value"] = getStatusValue(context, data["data"]["user"]["status"]);
                                addStudentsFields[18]["value"] = data["data"]["user"]["current_address"];
                                addStudentsFields[19]["value"] = data["data"]["user"]["blood_type"];
                                addStudentsFields[20]["value"] = data["data"]["family_members_count"];
                                addStudentsFields[21]["value"] = getYesOrNoValue(context, data["data"]["user"]["is_has_disease"]);
                                addStudentsFields[22]["value"] =
                                    data["data"]["user"]["disease_name"] == "null" ? "" : data["data"]["user"]["disease_name"];
                                addStudentsFields[23]["value"] = getYesOrNoValue(context, data["data"]["user"]["is_has_treatment"]);
                                addStudentsFields[24]["value"] =
                                    data["data"]["user"]["treatment_name"] == "null" ? "" : data["data"]["user"]["treatment_name"];
                                addStudentsFields[25]["value"] = data["data"]["who_is_parent"];
                                addStudentsFields[26]["value"] = getYesOrNoValue(context, data["data"]["user"]["are_there_disease_in_family"]);
                                addStudentsFields[27]["value"] =
                                    data["data"]["user"]["family_disease_note"] == "null" ? "" : data["data"]["user"]["family_disease_note"];
                                addStudentsFields[28]["value"] =
                                    data["data"]["is_orphan"] == "0" ? translate(Get.context!).no : translate(Get.context!).yes;
                                Navigator.of(context).pop();
                                Navigator.of(context).push(createRoute(
                                  AddPage(
                                    englishTitle: "edit_student",
                                    isEdit: true,
                                    fields: addStudentsFields,
                                    title: translate(Get.context!).edit_students,
                                    onPressed: () async {
                                      Map result = await ApiService().editProprtyStudent({
                                        "id": item["id"],
                                        "user_id": item["user_id"],
                                      }, {
                                        "id": item["id"],
                                        "user_id": item["user_id"],
                                        "parent_work": "",
                                        "family_members_count": addStudentsFields[20]["value"],
                                        "parent_phone": addStudentsFields[9]["value"],
                                        "who_is_parent": addStudentsFields[25]["value"],
                                        "is_orphan": addStudentsFields[28]["value"] == translate(Get.context!).yes ? "1" : "0",
                                        "user[mainImage]": addStudentsFields[15]["value"].path == '' ? null : addStudentsFields[15]["value"]?.path,
                                        'user[id]': '',
                                        'user[status]': getStatusKey(context, addStudentsFields[14]["value"]),
                                        'user[email]': addStudentsFields[13]["value"],
                                        'user[first_name]': addStudentsFields[3]["value"],
                                        'user[last_name]': addStudentsFields[4]["value"],
                                        'user[username]': addStudentsFields[1]["value"],
                                        'user[is_approved]': "1",
                                        'user[password]': addStudentsFields[2]["value"],
                                        'user[identity_number]': addStudentsFields[11]["value"],
                                        'user[phone]': addStudentsFields[10]["value"],
                                        'user[gender]': getGenderKey(context, addStudentsFields[8]["value"]),
                                        'user[birth_date]': addStudentsFields[7]["value"]?.split("T")[0],
                                        'user[birth_place]': "${addStudentsFields[12]["value"]}",
                                        'user[father_name]': addStudentsFields[5]["value"],
                                        'user[mother_name]': addStudentsFields[6]["value"],
                                        'user[qr_code]': '',
                                        'user[blood_type]': addStudentsFields[19]["value"],
                                        'user[note]': "",
                                        'user[current_address]': addStudentsFields[18]["value"],
                                        'user[is_has_disease]': getYesOrNoKey(context, addStudentsFields[21]["value"]),
                                        'user[disease_name]': addStudentsFields[22]["value"],
                                        'user[is_has_treatment]': getYesOrNoKey(context, addStudentsFields[23]["value"]),
                                        'user[treatment_name]': addStudentsFields[24]["value"],
                                        'user[are_there_disease_in_family]': getYesOrNoKey(context, addStudentsFields[26]["value"]),
                                        'user[family_disease_note]': addStudentsFields[27]["value"],
                                        'user[property_id]': widget.details["property_id"],
                                      }, jsonDecode(authService.user.toUser())["token"]);

                                      if (result["api"] == "SUCCESS") {
                                        getGroupDetails();
                                      }
                                      return AppFunctions().getUserErrorMessage(result, context);
                                    },
                                  ),
                                ));
                              });
                            }
                          });
                        },
                        onDeletePressed: (item, index) async {
                          // user["role"] == "admin" ||
                          //     user['role'] == "branch_admin" ||
                          //     user["role"] == "property_admin" ||
                          //     (user["role"] == "teacher" && user["class_room_id"] == widget.details["id"]),
                          if (user["role"] == "admin" || user['role'] == "branch_admin" || user["role"] == "property_admin") {
                            showCustomDialog(context, translate(Get.context!).confirmStudentTransfer, AppConstants.appLogo, "delete", () async {
                              Map result = await ApiService().deleteClassRoomStudent(item["prop_id"], jsonDecode(authService.user.toUser())["token"]);
                              if (result["api"] == "SUCCESS") {
                                setState(() {
                                  classRoomGroup["class_room_students"].removeAt(index);
                                });
                              }
                              return result["api"];
                            });
                          } else if (user["role"] == "admin" ||
                              user['role'] == "branch_admin" ||
                              user["role"] == "property_admin" ||
                              (user["role"] == "teacher" && user["class_room_id"] == widget.details["id"])) {
                                print('item["status"]${getStatusKey(context, item["status"])}');
                            if (item["status"] == getStatusValue(context,"1")) {
                              showCustomDialog(context, translate(Get.context!).confirmStudentDeactivation, AppConstants.appLogo, "delete", () async {
                                Map result = await ApiService()
                                    .studentStatus(jsonDecode(authService.user.toUser())["token"], "0", item["id"]);

                                if (result["api"] == "SUCCESS") {
                                  getGroupDetails();
                                }
                                return result["api"];
                              });
                            } else {
                              showCustomDialog(context, translate(Get.context!).confirmStudentActivation, AppConstants.appLogo, "delete", () async {
                                Map result = await ApiService()
                                    .studentStatus(jsonDecode(authService.user.toUser())["token"], "1", item["id"]);

                                if (result["api"] == "SUCCESS") {
                                  getGroupDetails();
                                }
                                return result["api"];
                              });
                            }
                          }
                        },
                        list: classRoomGroup["class_room_students"].asMap().entries.map((entry) {
                          return {
                            "id": entry.value["student"] == null ? "" : entry.value["student"]["id"],
                            "prop_id": entry.value["id"],
                            "property_id": widget.details["property_id"],
                            "class_room_id": entry.value["class_room_id"],
                            "name": entry.value["student"] == null
                                ? ""
                                : "${entry.value["student"]["user"] == null ? translate(Get.context!).not_available : entry.value["student"]["user"]["first_name"]} ${entry.value["student"]["user"] == null ? translate(Get.context!).not_available : entry.value["student"]["user"]["last_name"]}",
                            "image": entry.value["student"] == null ? "" : entry.value["student"]?["user"]?["image"],
                            "gender": entry.value["student"] == null
                                ? ""
                                : entry.value["student"]?["user"] == null
                                    ? null
                                    : getGenderValue(context, entry.value["student"]?["user"]?["gender"]),
                            "joined_at": entry.value["joined_at"],
                            "left_at": entry.value["left_at"],
                            "status": getStatusValue(context, entry.value["student"]?["user"]?["status"])
                          };
                        }).toList(),
                        tabs: getStudentTabs(context),
                        pageType: "student",
                      ),
                    ),
                  ],
                ),
                ListViewComponent(
                    onRefresh: () async {
                      getGroupDetails();
                    },
                    disableContaineronTap: isConnected ? null : (item) {},
                    permmission: user["role"] == "admin" ||
                        user['role'] == "branch_admin" ||
                        user["role"] == "property_admin" ||
                        (user["role"] == "teacher" && user["class_room_id"] == widget.details["id"]),
                    searchController: widget.searchController,
                    controller: tabIndex == 4 ? widget.scrollController : ScrollController(),
                    addPage: AddPage(
                      englishTitle: "add_session",
                      isEdit: false,
                      fields: addLessonFields,
                      title: translate(Get.context!).addSession,
                      onPressed: () async {
                        Map session = {
                          "id": null,
                          "removeItem": AppFunctions().idGenerator(),
                          "name": addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonName)["value"],
                          "type": addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonType)["value"],
                          "description":
                              addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonDescription)["value"],
                          "date": DateTime.now().toString().split(" ")[0],
                          "start_at":
                              '${addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonDate)["value"]} ${addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonTime)["value"].split(" ")[0]}',
                          "duration": addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonDuration)["value"],
                          "place": addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonplace)["value"],
                          "teacher_id": addLessonFields
                              .firstWhere((element) => element["title"] == translate(Get.context!).lessonTeacher)["value"]
                              .split(" - ")[1],
                          "class_room_id": widget.details["id"],
                          "subject_name": addLessonFields
                              .firstWhere((element) => element["title"] == translate(Get.context!).lessonBook)["value"]
                              .split(" - ")[0],
                        };
                        if (isConnected) {
                          Map result = await ApiService().createGroupSession(session, jsonDecode(authService.user.toUser())["token"]);

                          List items = addLessonFields
                              .firstWhere((element) => element["title"] == translate(Get.context!).present_students)["value"]
                              .split(',')
                              .toList()
                              .map((e) => e.split(" - ")[1])
                              .toList();

                          Map reult = await ApiService().addSessionPer(result["data"]["id"], items, jsonDecode(authService.user.toUser())["token"]);
                          print("reult$reult");
                          if (result["api"] == "SUCCESS") {
                            setState(() {
                              classRoomGroup["sessions"].insert(0, result["data"]);
                              getGroupDetails();
                            });
                          }

                          return result["api"];
                        } else {
                          showLoadingDialog(context);
                          List items = addLessonFields
                              .firstWhere((element) => element["title"] == translate(Get.context!).present_students)["value"]
                              .split(',')
                              .toList()
                              .map((e) => e.split(" - ")[1])
                              .toList();
                          PrefUtils.setSession(jsonEncode([
                            ...sessions,
                            {...session, "session_attendances": items}
                          ]));
                          setState(() {
                            sessions.insert(0, session);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(translate(Get.context!).operation_success, style: TextStyle(fontFamily: getFontName(context))),
                            duration: const Duration(milliseconds: 500),
                          ));

                          return "SUCCESS";
                        }
                      },
                    ),
                    list: [...sessions, ...classRoomGroup["sessions"]].asMap().entries.map((entry) {
                      return {
                        "id": entry.value["id"],
                        "name": entry.value["name"] ?? translate(Get.context!).not_available,
                        "type": entry.value["subject_name"] ?? translate(Get.context!).not_available,
                        "description": entry.value["description"] ?? translate(Get.context!).not_available,
                        "date": entry.value["start_at"] ?? translate(Get.context!).not_available,
                        "duration": entry.value["duration"] ?? translate(Get.context!).not_available,
                        "place": entry.value["place"] ?? translate(Get.context!).not_available,
                        "session_attendances": entry.value["session_attendances"] ?? [],
                        "subject_name": entry.value["subject_name"] ?? translate(Get.context!).not_available,
                        "removeItem": entry.value["removeItem"],
                      };
                    }).toList(),
                    onEditPressed: (item, index) async {
                      await ApiService().getSessionDetails(item["id"], jsonDecode(authService.user.toUser())["token"]).then((data) {
                        if (data != null) {
                          addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonName)["value"] = item["name"];
                          addLessonFields[1]["value"] = item["description"];
                          addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonDescription)["value"] =
                              item["description"];
                          addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonplace)["value"] = item["place"];
                          addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonType)["value"] = item["type"];
                          addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonBook)["value"] =
                              item["subject_name"];
                          addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonDate)["value"] =
                              item["date"].split(" ")[0];
                          addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonTime)["value"] =
                              item["date"].split(" ")[1];

                          addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).present_students)["value"] =
                              data["data"]["session_attendances"]
                                  ?.map((e) => '${e["student"]["user"]["first_name"]} ${e["student"]["user"]["last_name"]} - ${e["student"]["id"]}')
                                  .toList()
                                  .join(", ");
                          addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonTeacher)["value"] =
                              "${data["data"]["teacher"]["user"]["first_name"]} ${data["data"]["teacher"]["user"]["last_name"]} - ${data["data"]["teacher"]["id"]}";

                          addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonDuration)["value"] =
                              item["duration"];
                        }
                      });

                      Navigator.of(context).push(createRoute(
                        AddPage(
                          englishTitle: "edit_session",
                          isEdit: true,
                          fields: addLessonFields,
                          title: "تعديل الدرس",
                          onPressed: () async {
                            Map result = await ApiService().editGroupSession({
                              "id": item["id"],
                              "name": addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonName)["value"],
                              "type": addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonType)["value"],
                              "description":
                                  addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonDescription)["value"],
                              "date": DateTime.now().toString().split(" ")[0],
                              "place": addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonplace)["value"],
                              "start_at":
                                  '${addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonDate)["value"]} ${addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonTime)["value"].toString().replaceAll("ص", "").replaceAll("م", "")}',
                              "duration":
                                  addLessonFields.firstWhere((element) => element["title"] == translate(Get.context!).lessonDuration)["value"],
                              "class_room_id": widget.details["id"],
                              "teacher_id": addLessonFields
                                  .firstWhere((element) => element["title"] == translate(Get.context!).lessonTeacher)["value"]
                                  .split(" - ")[1],
                              "subject_name": addLessonFields
                                  .firstWhere((element) => element["title"] == translate(Get.context!).lessonBook)["value"]
                                  .split(" - ")[0],
                            }, jsonDecode(authService.user.toUser())["token"]);

                            if (result["api"] == "SUCCESS") {
                              List items = addLessonFields
                                  .firstWhere((element) => element["title"] == translate(Get.context!).present_students)["value"]
                                  .split(',')
                                  .toList()
                                  .map((e) => e.split(" - ")[1])
                                  .toList();

                              Map reult = await ApiService()
                                  .putSessionPareicpants(result["data"]["id"], items, jsonDecode(authService.user.toUser())["token"]);

                              setState(() {
                                classRoomGroup["sessions"].removeAt(index);
                                classRoomGroup["sessions"].insert(index, result["data"]);
                                getGroupDetails();
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
                          Map result = await ApiService().deleteGroupSession(item["id"], jsonDecode(authService.user.toUser())["token"]);

                          if (result["api"] == "SUCCESS") {
                            setState(() {
                              classRoomGroup["sessions"].removeAt(index);
                            });
                          }
                          return result["api"];
                        } else {
                          if (item["id"] == null || item["id"] == "null") {
                            setState(() {
                              sessions.removeWhere((element) => element["removeItem"] == item["removeItem"]);
                              PrefUtils.setSession(jsonEncode(sessions));
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
                    tabs: const [],
                    pageType: "session"),
                ListViewComponent(
                  onRefresh: () async {
                    getGroupDetails();
                  },
                  permmission: user["role"] == "admin" ||
                      user['role'] == "branch_admin" ||
                      user["role"] == "property_admin" ||
                      (user["role"] == "teacher" && user["class_room_id"] == widget.details["id"]),
                  searchController: widget.searchController,
                  controller: tabIndex == 3 ? widget.scrollController : ScrollController(),
                  addPage: AddPage(
                    englishTitle: "edit_activity",
                    isEdit: false,
                    fields: addActivityFields,
                    title: translate(Get.context!).addActivity,
                    onPressed: () async {
                      Map result = await ApiService().createClassRoomActivity({
                        "class_room_id": widget.details["id"],
                        "activity_type_id": addActivityFields
                            .firstWhere((element) => element["title"] == translate(Get.context!).activity_type)["value"]
                            .split(' - ')[1],
                        "name": addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activity_name)["value"],
                        "place": addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activity_location)["value"],
                        "cost": addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activity_cost)["value"],
                        "mainImage":
                            addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activityPhoto)["value"].path == ''
                                ? null
                                : addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activityPhoto)["value"]?.path,
                        "result":"",
                        "note": addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activity_description)["value"],
                        "start_datetime":
                            addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activity_date)["value"],
                        "end_datetime": addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activity_date)["value"],
                        "teacher_id": addActivityFields
                            .firstWhere((element) => element["title"] == translate(Get.context!).teacherOrActivitySupervisor)["value"]
                            .split(" - ")[1],
                      }, jsonDecode(authService.user.toUser())["token"]);
                      
                      List students = getStudnets();
                      List newStudent = students.map((item) => item.split(" - ")[1]).toList();
                      Map reult =
                          await ApiService().addActivityPareicpants(result["data"]["id"], newStudent, jsonDecode(authService.user.toUser())["token"]);

                      if (result["api"] == "SUCCESS") {
                        setState(() {
                          classRoomGroup["activities"].insert(0, result["data"]);
                          getGroupDetails();
                        });
                      }

                      return result["api"];
                    },
                  ),
                  list: classRoomGroup["activities"].asMap().entries.map((entry) {
                    return {
                      "id": entry.value["id"],
                      "name": entry.value["name"] ?? translate(Get.context!).not_available,
                      "type": entry.value["activity_type"] == null
                          ? translate(Get.context!).not_available
                          : "${entry.value["activity_type"]["name"]} - ${entry.value["activity_type"]["id"]}",
                      "description": entry.value["note"] ?? translate(Get.context!).not_available,
                      "date": entry.value["start_datetime"].split(" ")[0] ?? translate(Get.context!).not_available,
                      "place": entry.value["place"] ?? translate(Get.context!).not_available,
                      "cost": entry.value["cost"] ?? translate(Get.context!).not_available,
                      "image": entry.value["image"] ?? "",
                      "participants": entry.value["participants"] ?? [],
                      "examiner": entry.value["teacher"] != null
                          ? "${entry.value["teacher"]["user"]["first_name"]} ${entry.value["teacher"]["user"]["last_name"]} - ${entry.value["teacher"]["id"]}"
                          : translate(Get.context!).not_available,
                    };
                  }).toList(),
                  onEditPressed: (item, index) async {
                    showLoadingDialog(context);
                    AppFunctions.getImageXFileByUrl(AppFunctions().getImage(item["image"])).then((value) {
                      addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activityPhoto)["value"] = value;
                      addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activity_name)["value"] = item["name"];
                      addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activity_description)["value"] =
                          item["description"];
                      addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activity_location)["value"] =
                          item["place"];
                      addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).present_students)["value"] =
                          item["participants"]
                              .map((e) => '${e["student"]["user"]["first_name"]} ${e["student"]["user"]["last_name"]} - ${e["student"]["id"]}')
                              .toList()
                              .join(",");
                      addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activity_date)["value"] = item["date"];

                      addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activity_type)["value"] = item["type"];
                      addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activity_cost)["value"] = item["cost"];
                      addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).teacherOrActivitySupervisor)["value"] =
                          item["examiner"];
                      Navigator.of(context).pop();
                      Navigator.of(context).push(createRoute(
                        AddPage(
                          englishTitle: "edit_activity",
                          isEdit: true,
                          fields: addActivityFields,
                          title: translate(Get.context!).editActivity,
                          onPressed: () async {
                            Map result = await ApiService().editClassRoomActivity({
                              "id": item["id"],
                              "class_room_id": widget.details["id"],
                              "mainImage": addActivityFields
                                          .firstWhere((element) => element["title"] == translate(Get.context!).activityPhoto)["value"]
                                          .path ==
                                      ''
                                  ? null
                                  : addActivityFields
                                      .firstWhere((element) => element["title"] == translate(Get.context!).activityPhoto)["value"]
                                      ?.path,
                              "activity_type_id": addActivityFields
                                  .firstWhere((element) => element["title"] == translate(Get.context!).activity_type)["value"]
                                  .split(' - ')[1],
                              "name": addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activity_name)["value"],
                              "place":
                                  addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activity_location)["value"],
                              "cost": addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activity_cost)["value"],
                              "result": addActivityFields
                                  .firstWhere((element) => element["title"] == translate(Get.context!).activity_description)["value"],
                              "note": addActivityFields
                                  .firstWhere((element) => element["title"] == translate(Get.context!).activity_description)["value"],
                              "start_datetime":
                                  addActivityFields.firstWhere((element) => element["title"] == translate(Get.context!).activity_date)["value"],
                              "teacher_id": addActivityFields
                                  .firstWhere((element) => element["title"] == translate(Get.context!).teacherOrActivitySupervisor)["value"]
                                  .split(" - ")[1],
                            }, jsonDecode(authService.user.toUser())["token"]);
                            List student = addActivityFields
                                .firstWhere((element) => element["title"] == translate(Get.context!).present_students)["value"]
                                .split(',')
                                .toList()
                                .map((e) => e.split(" - ")[1])
                                .toList();
                            Map reult = await ApiService()
                                .putActivityPareicpants(result["data"]["id"], student, jsonDecode(authService.user.toUser())["token"]);

                            if (result["api"] == "SUCCESS") {
                              setState(() {
                                classRoomGroup["activities"].removeAt(index);
                                classRoomGroup["activities"].insert(index, result["data"]);
                                getGroupDetails();
                              });
                            }
                            return result["api"];
                          },
                        ),
                      ));
                    });
                  },
                  onDeletePressed: (item, index) async {
                    showCustomDialog(context, translate(Get.context!).confirm_delete, AppConstants.appLogo, "delete", () async {
                      Map result = await ApiService().deleteClassRoomActivity(item["id"], jsonDecode(authService.user.toUser())["token"]);

                      if (result["api"] == "SUCCESS") {
                        setState(() {
                          classRoomGroup["activities"].removeAt(index);
                        });
                      }
                      return result["api"];
                    });
                  },
                  tabs: const [],
                  pageType: "activity",
                ),
                ListViewComponent(
                  onRefresh: () async {
                    getGroupDetails();
                  },
                  searchController: widget.searchController,
                  controller: tabIndex == 1 ? widget.scrollController : ScrollController(),
                  permmission: user["role"] == "admin" ||
                      user['role'] == "branch_admin" ||
                      user["role"] == "property_admin" ||
                      (user["role"] == "teacher" && user["class_room_id"] == widget.details["id"]),
                  addPage: AddTimesPage(
                    books: classRoomGroup["books"],
                    onPressed: (times) async {
                      for (var time in times) {
                        Map result = await ApiService().createTime({
                          "id": null,
                          "class_room_id": widget.details["id"],
                          "day_name": time["day"],
                          "subject_name": time["subject"],
                          "start_at": time["startTime"],
                          "end_at": time["endTime"],
                        }, jsonDecode(authService.user.toUser())["token"]);
                        setState(() {
                          classRoomGroup["calendars"].insert(0, result["data"]);
                          getGroupDetails();
                        });
                        return result["api"];
                      }
                    },
                  ),
                  itemContainer: Container(),
                  list: classRoomGroup["calendars"]?.asMap().entries.map((entry) {
                    return {
                      "id": entry.value["id"],
                      "startTime": entry.value["start_at"] ?? translate(Get.context!).not_available,
                      "subject": entry.value["subject_name"] ?? translate(Get.context!).not_available,
                      "day": entry.value["day_name"] ?? translate(Get.context!).not_available,
                      "endTime": entry.value["end_at"] ?? translate(Get.context!).not_available,
                    };
                  }).toList(),
                  onEditPressed: (item, index) async {
                    Navigator.of(context).push(createRoute(
                      AddTimesPage(
                        books: classRoomGroup["books"],
                        time: item,
                        onPressed: (times) async {
                          Map result = await ApiService().editTime({
                            "id": times[0]["id"],
                            "class_room_id": widget.details["id"],
                            "day_name": times[0]["day"],
                            "subject_name": times[0]["subject"],
                            "start_at": times[0]["startTime"],
                            "end_at": times[0]["endTime"],
                          }, jsonDecode(authService.user.toUser())["token"]);
                          if (result["api"] == "SUCCESS") {
                            setState(() {
                              classRoomGroup["calendars"].removeAt(index);
                              classRoomGroup["calendars"].insert(index, result["data"]);
                              getGroupDetails();
                            });
                          }

                          return result["api"];
                        },
                      ),
                    ));
                  },
                  onDeletePressed: (item, index) async {
                    showCustomDialog(context, translate(Get.context!).confirm_delete, AppConstants.appLogo, "delete", () async {
                      Map result = await ApiService().deleteTime(item["id"], jsonDecode(authService.user.toUser())["token"]);

                      if (result["api"] == "SUCCESS") {
                        setState(() {
                          classRoomGroup["calendars"].removeAt(index);
                        });
                      }
                      return result["api"];
                    });
                  },
                  tabs: getStudentTabs(context),
                  pageType: "null",
                ),
                ListViewComponent(
                  onRefresh: () async {
                    getGroupDetails();
                  },
                  permmission: user["role"] == "admin" ||
                      user['role'] == "branch_admin" ||
                      user["role"] == "property_admin" ||
                      (user["role"] == "teacher" && user["class_room_id"] == widget.details["id"]),
                  searchController: widget.searchController,
                  controller: tabIndex == 2 ? widget.scrollController : ScrollController(),
                  addPage: null,
                  onTap: () {
                    dropDown(context, books.map((e) => '${e["name"]}/${e["book_type"]} - ${e["id"]}').toList(), false, []).then((value) async {
                      if (value != null) {
                        showLoadingDialog(context);
                        Map result = await ApiService().addABookToClassRoom(
                          jsonDecode(authService.user.toUser())["token"],
                          class_room_id: widget.details["id"],
                          book_id: value.toString().split(" - ")[1],
                        );
                        String status = result["api"];
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (status == "SUCCESS") {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(translate(Get.context!).operation_success, style: TextStyle(fontFamily: getFontName(context))),
                            duration: const Duration(milliseconds: 500),
                          ));
                          Future.delayed(const Duration(seconds: 1), () async {
                            books.clear();
                            await getGroupDetails();
                            Navigator.of(context).pop();
                          });
                        } else if (status == "FAILED") {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                          if (result["hints"].toString().contains("Book is already")) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(translate(Get.context!).bookAlreadyExists, style: TextStyle(fontFamily: getFontName(context))),
                              duration: const Duration(milliseconds: 500),
                            ));
                          } else {
                            await FirebaseAnalytics.instance.logEvent(
                              name: "an_expected_error_occured_while_addABookToClassRoom_${result["hints"].toString()}",
                              parameters: {
                                'screen_name': "an_expected_error_occured_while_addABookToClassRoom_${result["hints"].toString()}",
                                'screen_class': "Adding",
                              },
                            );
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(translate(Get.context!).unexpected_error, style: TextStyle(fontFamily: getFontName(context))),
                              duration: const Duration(milliseconds: 500),
                            ));
                          }
                        }
                      }
                    });
                  },
                  list: classRoomGroup["books"].asMap().entries.map((entry) {
                    return {
                      "id": entry.value["id"],
                      "name": entry.value["name"] ?? translate(Get.context!).not_available,
                      "type": entry.value["book_type"] ?? translate(Get.context!).not_available,
                      "size": entry.value["size"] ?? translate(Get.context!).not_available,
                      "description":
                          '${entry.value["author_name"] ?? translate(Get.context!).not_available} - ${entry.value["paper_count"] ?? translate(Get.context!).not_available}/${entry.value["size"] ?? translate(Get.context!).not_available}',
                      "date": entry.value["start_at"] ?? "",
                      "paper_count": entry.value["paper_count"],
                      "author_name": entry.value["author_name"],
                      "property_type": entry.value["property_type"] == "mosque" ? translate(Get.context!).mosque : translate(Get.context!).school,
                    };
                  }).toList(),
                  tabs: const [],
                  pageType: "book",
                  onDeletePressed: (item, index) async {
                    showCustomDialog(context, translate(Get.context!).confirm_delete, AppConstants.appLogo, "delete", () async {
                      Map result = await ApiService().deleteABookFromClassRoom(
                        jsonDecode(authService.user.toUser())["token"],
                        class_room_id: widget.details["id"],
                        book_id: item["id"],
                      );

                      if (result["api"] == "SUCCESS") {
                        setState(() {
                          classRoomGroup["books"].removeAt(index);
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
                        controller: tabIndex == 5 ? widget.scrollController : ScrollController(),
                        type: "class_room",
                      ),
              ]));
  }
}

class TeacherContainer extends StatelessWidget {
  const TeacherContainer({
    Key? key,
    required this.teacher,
    required this.id,
    required this.teachersWithoutClass,
    required this.authService,
    this.onDeletePressed,
    required this.type,
    this.onEditPressed,
  }) : super(key: key);

  final Map teacher;
  final List teachersWithoutClass;
  final int id;
  final String type;
  final Future<void> Function(dynamic)? onDeletePressed;
  final Future<void> Function(dynamic)? onEditPressed;
  final authService;
  @override
  Widget build(BuildContext context) {
    return isConnected
        ? AnmiationCard(
            page: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 0, bottom: 4),
              child: Container(
                height: 85,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [AppBoxShadow.containerBoxShadow],
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (teacher[type] != null)
                        if (teacher[type]["user"]["image"] == null)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 1, 1),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                AppIcons.teacherAvatar,
                                width: 70,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      if (teacher[type] != null)
                        if (teacher[type]["user"]["image"] != null)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 1, 1),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: AppFunctions().getImage(teacher[type]["user"]["image"]),
                                width: 70,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 4, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (teacher[type] != null)
                                Text(
                                  "${teacher[type]["user"]["first_name"] ?? ""} ${teacher[type]["user"]["last_name"] ?? ""}",
                                  style: TextStyle(fontFamily: getFontName(context), color: Colors.black, fontSize: 16),
                                ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 8, 0),
                                  child: Text(
                                    translate(Get.context!).clickToViewDetails,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontFamily: 'PNU',
                                      color: Color(0xFF7C8791),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 1.0),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (isConnected)
                                    if (onEditPressed != null)
                                      if (jsonDecode(authService.user.toUser())["role"] == "admin" ||
                                          jsonDecode(authService.user.toUser())['role'] == "branch_admin" && type != "admin" ||
                                          jsonDecode(authService.user.toUser())["role"] == "property_admin" && type != "admin")
                                        GestureDetector(
                                            onTap: () {
                                              if (onEditPressed == null) {
                                                dropDown(context, teachersWithoutClass.map((e) => '${e["name"]} - ${e["id"]}').toList(), false, [])
                                                    .then((value) async {
                                                  if (value != null) {
                                                    showLoadingDialog(context);
                                                    Map result = await ApiService().editClassRoomTeacher({
                                                      "id": teacher["id"],
                                                      "class_room_id": id,
                                                      "teacher_id": value.toString().split(" - ")[1],
                                                      "joined_at": teacher["joined_at"],
                                                      "left_at": null
                                                    }, jsonDecode(authService.user.toUser())["token"]);
                                                    String status = result["api"];
                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                    if (status == "SUCCESS") {
                                                      // ignore: use_build_context_synchronously
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text(translate(Get.context!).operation_success,
                                                            style: TextStyle(fontFamily: getFontName(context))),
                                                        duration: const Duration(milliseconds: 500),
                                                      ));
                                                      Future.delayed(const Duration(seconds: 1), () {
                                                        Navigator.of(context).pop();
                                                        Navigator.of(context).pop();
                                                      });
                                                    } else if (status == "FAILED") {
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.of(context).pop();
                                                      await FirebaseAnalytics.instance.logEvent(
                                                        name: "an_expected_error_occured_while_editClassRoomTeacher_${result["hints"].toString()}",
                                                        parameters: {
                                                          'screen_name':
                                                              "an_expected_error_occured_while_editClassRoomTeacher_${result["hints"].toString()}",
                                                          'screen_class': "Adding",
                                                        },
                                                      );
                                                      // ignore: use_build_context_synchronously
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text(translate(Get.context!).unexpected_error,
                                                            style: TextStyle(fontFamily: getFontName(context))),
                                                        duration: const Duration(milliseconds: 500),
                                                      ));
                                                    }
                                                  }
                                                });
                                              } else {
                                                onEditPressed!(teacher["id"]);
                                              }
                                            },
                                            child: Text(
                                              translate(Get.context!).edit,
                                              style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.bold),
                                            )),
                                  if (isConnected)
                                    if (onDeletePressed != null)
                                      if (jsonDecode(authService.user.toUser())["role"] == "admin" ||
                                          jsonDecode(authService.user.toUser())['role'] == "branch_admin" && type != "admin" ||
                                          jsonDecode(authService.user.toUser())["role"] == "property_admin" && type != "admin")
                                        const VerticalDivider(
                                          color: Colors.black,
                                        ),
                                  if (isConnected)
                                    if (onDeletePressed != null)
                                      if (jsonDecode(authService.user.toUser())["role"] == "admin" ||
                                          jsonDecode(authService.user.toUser())['role'] == "branch_admin" && type != "admin" ||
                                          jsonDecode(authService.user.toUser())["role"] == "property_admin" && type != "admin")
                                        GestureDetector(
                                            onTap: () {
                                              onDeletePressed!(teacher["id"]);
                                            },
                                            child: Text(
                                              translate(Get.context!).delete,
                                              style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
                                            )),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                            child: Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFF57636C),
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            displayedPage: ProfilePage(
              tabs: type == "admin"
                  ? getAdminTabs(context)
                  : jsonDecode(authService.user.toUser())["role"] == "admin" ||
                          jsonDecode(authService.user.toUser())["role"] == "branch_admin" ||
                          jsonDecode(authService.user.toUser())["role"] == "property_admin"
                      ? getTeacherTabsWithRreviews(context)
                      : getStudentMainTabs(context),
              pageType: type,
              profileDetails: type == "admin"
                  ? {
                      "user_id": teacher[type] == null ? teacher["admin_id"] : teacher[type]["id"],
                      "id": teacher[type] == null ? "" : teacher[type]["id"],
                      "first_name": teacher[type] == null ? "" : teacher[type]["user"]["first_name"],
                      "last_name": teacher[type] == null ? "" : teacher[type]["user"]["last_name"],
                      "gender": teacher[type] == null ? "" : getGenderValue(context, teacher[type]["user"]["gender"]),
                      "image": teacher[type] == null ? "" : teacher[type]["user"]["image"]
                    }
                  : {
                      "id": teacher[type]["id"],
                      "first_name": teacher[type]["user"]["first_name"],
                      "last_name": teacher[type]["user"]["last_name"],
                      "gender": getGenderValue(context, teacher[type]["user"]["gender"]),
                      "image": teacher[type]["user"]["image"]
                    },
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 0, bottom: 4),
            child: Container(
              height: 85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [AppBoxShadow.containerBoxShadow],
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 1, 1),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          AppIcons.teacherAvatar,
                          width: 70,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 4, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${teacher[type]["user"]["first_name"] ?? ""} ${teacher[type]["user"]["last_name"] ?? ""}",
                              style: const TextStyle(
                                fontFamily: 'PNU',
                                color: Color(0xFF090F13),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 8, 0),
                                child: Text(
                                  translate(Get.context!).clickToViewDetails,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontFamily: 'PNU',
                                    color: Color(0xFF7C8791),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (jsonDecode(authService.user.toUser())["role"] == "admin" ||
                            jsonDecode(authService.user.toUser())['role'] == "branch_admin" ||
                            jsonDecode(authService.user.toUser())["role"] == "property_admin")
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (isConnected)
                                    if (onEditPressed != null)
                                      GestureDetector(
                                          onTap: () {
                                            if (onEditPressed == null) {
                                              dropDown(context, teachersWithoutClass.map((e) => '${e["name"]} - ${e["id"]}').toList(), false, [])
                                                  .then((value) async {
                                                if (value != null) {
                                                  showLoadingDialog(context);
                                                  Map result = await ApiService().editClassRoomTeacher({
                                                    "id": teacher["id"],
                                                    "class_room_id": id,
                                                    "teacher_id": value.toString().split(" - ")[1],
                                                    "joined_at": teacher["joined_at"],
                                                    "left_at": null
                                                  }, jsonDecode(authService.user.toUser())["token"]);
                                                  String status = result["api"];
                                                  FocusManager.instance.primaryFocus?.unfocus();
                                                  if (status == "SUCCESS") {
                                                    // ignore: use_build_context_synchronously
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                      content: Text(translate(Get.context!).operation_success,
                                                          style: TextStyle(fontFamily: getFontName(context))),
                                                      duration: const Duration(milliseconds: 500),
                                                    ));
                                                    Future.delayed(const Duration(seconds: 1), () {
                                                      Navigator.of(context).pop();
                                                      Navigator.of(context).pop();
                                                    });
                                                  } else if (status == "FAILED") {
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context).pop();
                                                    await FirebaseAnalytics.instance.logEvent(
                                                      name: "an_expected_error_occured_while_editClassRoomTeacher_${result["hints"].toString()}",
                                                      parameters: {
                                                        'screen_name':
                                                            "an_expected_error_occured_while_editClassRoomTeacher_${result["hints"].toString()}",
                                                        'screen_class': "Adding",
                                                      },
                                                    );
                                                    // ignore: use_build_context_synchronously
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                      content: Text(translate(Get.context!).unexpected_error,
                                                          style: TextStyle(fontFamily: getFontName(context))),
                                                      duration: const Duration(milliseconds: 500),
                                                    ));
                                                  }
                                                }
                                              });
                                            } else {
                                              onEditPressed!(teacher["id"]);
                                            }
                                          },
                                          child: Text(
                                            translate(Get.context!).edit,
                                            style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.bold),
                                          )),
                                  if (isConnected)
                                    if (onDeletePressed != null)
                                      const VerticalDivider(
                                        color: Colors.black,
                                      ),
                                  if (isConnected)
                                    if (onDeletePressed != null)
                                      GestureDetector(
                                          onTap: () {
                                            onDeletePressed!(teacher["id"]);
                                          },
                                          child: Text(
                                            translate(Get.context!).delete,
                                            style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
                                          )),
                                ],
                              ),
                            ),
                          ),
                        const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFF57636C),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
