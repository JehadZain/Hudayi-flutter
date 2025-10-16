import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/main.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/services/API/api.dart';
import 'package:hudayi/services/pref_utils.dart';
import 'package:hudayi/ui/helper/App_Consts.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:hudayi/ui/widgets/Circule_Progress.dart';
import 'package:hudayi/ui/widgets/grid_View_List.dart';
import 'package:hudayi/ui/widgets/no_Data.dart';
import 'package:hudayi/ui/widgets/statistics.dart';
import 'package:provider/provider.dart';

import '../../../ui/helper/App_Constants.dart';
import '../../../ui/helper/App_Dialog.dart';

class ClassProfile extends StatefulWidget {
  final TextEditingController searchController;
  final ScrollController scrollController;
  final TabController tabController;
  final Map details;
  const ClassProfile({super.key, required this.searchController, required this.scrollController, required this.tabController, required this.details});

  @override
  State<ClassProfile> createState() => _ClassProfileState();
}

class _ClassProfileState extends State<ClassProfile> {
  int tabIndex = 0;
  Future? statics;
  Map user = {};
  List classGroup = [];
  bool isLoading = false;
  String classType = "";
  late AuthService authService;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  getClass() async {
    try {
      classGroup.clear();
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      String classesGroup = await PrefUtils.getClasses() ?? "";
      List classesLocale = classesGroup == "" ? [] : jsonDecode(await PrefUtils.getClasses());
      if (isConnected != false) {
        classesLocale.removeWhere((element) => element["property_id"] == widget.details["id"]);

        ApiService().getClassDetails(widget.details["id"], jsonDecode(authService.user.toUser())["token"]).then((value) {
          if (!mounted) return;
          setState(() {
            classType = value["data"]["property"] == null ? "" : value["data"]["property"]["property_type"];
            classGroup.addAll(value["data"]["class_rooms"]);
            PrefUtils.setClasses(jsonEncode([
              ...classesLocale,
              {"property_id": widget.details["id"], "class_rooms": value["data"]["class_rooms"]}
            ]));
            isLoading = false;
          });
        });
      } else {
        List classesGroup = jsonDecode(await PrefUtils.getClasses());

        List list = classesGroup.firstWhere((element) => element["property_id"] == widget.details["id"])["class_rooms"] ?? [];
        if (mounted) {
          setState(() {
            classGroup.addAll(list);
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    FirebaseAnalytics.instance.logEvent(
      name: 'grade_profile_page',
      parameters: {
        'screen_name': "grade_profile_page",
        'screen_class': "profile",
      },
    );
    authService = Provider.of<AuthService>(context, listen: false);
    getClass();
    if (isConnected) {
      statics = ApiService().getGradeStatics(widget.details["id"], jsonDecode(authService.user.toUser())["token"]);
    }

    user.addAll(jsonDecode(authService.user.toUser()));
    super.initState();
    widget.tabController.animation!.addListener(() {
      if (!mounted) return;
      setState(() {
        tabIndex = widget.tabController.index;
      });
    });
  }

  @override
  void dispose() {
    widget.tabController.animation?.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: TabBarView(physics: const BouncingScrollPhysics(), controller: widget.tabController, children: [
      Stack(
        children: [
          isLoading
              ? const CirculeProgress()
              : GridViewList(
                  searchController: widget.searchController,
                  onRefresh: () async {
                    getClass();
                  },
                  controller: tabIndex == 0 ? widget.scrollController : ScrollController(),
                  teacherClassRoomId: user["class_room_id"],
                  permmission: jsonDecode(authService.user.toUser())["role"] != "teacher",
                  isClickable: classGroup.map((e) => e["id"]).toList().contains(user["class_room_id"]),
                  onDeletePressed:
                      jsonDecode(authService.user.toUser())["role"] == "admin" || jsonDecode(authService.user.toUser())["role"] == "branch_admin"
                          ? (item, index) async {
                              showCustomDialog(context, translate(context).confirm_delete, AppConstants.appLogo, "delete", () async {
                                Map result = await ApiService().deleteClassRoom(item["id"], jsonDecode(authService.user.toUser())["token"]);

                                if (result["api"] == "SUCCESS") {
                                  getClass();
                                }
                                return result["api"];
                              });
                            }
                          : null,
                  onEditPressed: (item, index) async {
                    showLoadingDialog(context);
                    await AppFunctions.getImageXFileByUrl(AppFunctions().getImage(item["image"])).then((value) {
                      addSubClassFields[0]["value"] = item["name"];
                      addSubClassFields[1]["value"] = item["capacity"];
                      addSubClassFields[2]["value"] = value;
                      addSubClassFields[3]["value"] = item["description"];
                      Navigator.of(context).pop();
                      Navigator.of(context).push(createRoute(
                        AddPage(
                          isEdit: true,
                          englishTitle: "edit_class_room",
                          fields: addSubClassFields,
                          title: classType == ""
                              ? translate(context).editEpisodeOrDivision
                              : classType == "mosque"
                                  ? translate(context).editEpisode
                                  : translate(context).editDivision,
                          onPressed: () async {
                            Map result = await ApiService().editClassRoom({
                              "id": item["id"],
                              "name": addSubClassFields[0]["value"].toString(),
                              "capacity": addSubClassFields[1]["value"].toString(),
                              "mainImage":
                                  addSubClassFields[2]["value"].path == '' ? null : addSubClassFields[2]["value"]?.path,
                              "is_approved": "1",
                              "description": addSubClassFields[3]["value"].toString(),
                              "grade_id": int.parse("${widget.details["id"]}"),
                            }, jsonDecode(authService.user.toUser())["token"]);

                            if (result["api"] == "SUCCESS") {
                              getClass();
                            }
                            return AppFunctions().getClassRoomErrorMessage(result);
                          },
                        ),
                      ));
                    });
                  },
                  addPage: AddPage(
                    isEdit: false,
                    fields: addSubClassFields,
                    englishTitle: "add_class_room",
                    title: classType == ""
                        ? translate(context).addEpisodeOrDivision
                        : classType == "mosque"
                            ? translate(context).addEpisode
                            : translate(context).addDivision,
                    onPressed: () async {
                      Map result = await ApiService().creatClassRoom({
                        "id": null,
                        "name": addSubClassFields[0]["value"].toString(),
                        "capacity": addSubClassFields[1]["value"].toString(),
                        "mainImage": addSubClassFields[2]["value"].path == '' ? null : addSubClassFields[2]["value"]?.path,
                        "is_approved": jsonDecode(authService.user.toUser())["role"] == "teacher" ||
                                jsonDecode(authService.user.toUser())["role"] == "branch_admin" ||
                                jsonDecode(authService.user.toUser())["role"] == "property_admin"
                            ? "0"
                            : "1",
                        "description": addSubClassFields[3]["value"].toString(),
                        "grade_id": int.parse("${widget.details["id"]}"),
                      }, jsonDecode(authService.user.toUser())["token"]);

                      if (result["api"] == "SUCCESS") {
                        getClass();
                      }
                      return AppFunctions().getClassRoomErrorMessage(result);
                    },
                  ),
                  tabs: getSubClassTabs(context),
                  property_id: widget.details["property_id"],
                  property_type: widget.details["property_type"],
                  pageType: "subClass",
                  list: classGroup.asMap().entries.map((entry) {
                    return {
                      "id": entry.value["id"],
                      "description": entry.value["description"],
                      "name": entry.value["name"] ?? translate(context).not_available,
                      "capacity": entry.value["capacity"],
                      "image": entry.value["image"],
                      "grade_id": entry.value["grade_id"],
                      "is_approved": entry.value["is_approved"],
                      "classType": classType
                    };
                  }).toList(),
                ),
        ],
      ),
      // GridViewList(
      //   searchController: widget.searchController,
      //   controller: tabIndex == 1 ? widget.scrollController : ScrollController(),
      //   addPage: AddPage(fields: getAddStudentsFields(context), title: "إضافة طالب"),
      //   list: studentsTemp,
      //   tabs: getStudentTabs( context),
      //   pageType: "student",
      // ),
      statics == null
          ? const NoData()
          : Statistics(
              future: statics,
              controller: tabIndex == 2 ? widget.scrollController : ScrollController(),
              type: classType == "mosque" ? "mosque" : "grade",
            ),
    ]));
  }
}
