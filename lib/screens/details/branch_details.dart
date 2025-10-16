import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/main.dart';
import 'package:hudayi/models/language_provider.dart';
import 'package:hudayi/screens/add/add.dart';

import 'package:hudayi/services/API/api.dart';
import 'package:hudayi/services/pref_utils.dart';
import 'package:hudayi/ui/helper/App_Colors.dart';
import 'package:hudayi/ui/helper/App_Constants.dart';
import 'package:hudayi/ui/helper/App_Consts.dart';
import 'package:hudayi/ui/helper/App_Dialog.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:hudayi/ui/helper/App_Icons.dart';
import 'package:hudayi/ui/styles/app_Box_Shadow.dart';
import 'package:hudayi/ui/widgets/action_Bar.dart';
import 'package:hudayi/ui/widgets/container_Shadow.dart';
import 'package:hudayi/ui/widgets/drawer.dart';
import 'package:hudayi/ui/widgets/drop_Down_Bottom_Sheet.dart';
import 'package:hudayi/ui/widgets/grid_View_List.dart';
import 'package:hudayi/ui/widgets/helper.dart';
import 'package:hudayi/ui/widgets/image_View.dart';
import 'package:hudayi/ui/widgets/no_Data.dart';
import 'package:hudayi/ui/widgets/social_media.dart';
import 'package:hudayi/ui/widgets/statistics.dart';
import 'package:hudayi/ui/widgets/tab_Bar_Container.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../ui/widgets/Circule_Progress.dart';

// ignore: must_be_immutable
class BranchDetails extends StatefulWidget {
  Map branch;
  bool? isActionBardisabled;

  BranchDetails({Key? key, required this.branch, this.isActionBardisabled}) : super(key: key);

  @override
  State<BranchDetails> createState() => _BranchDetailsState();
}

class _BranchDetailsState extends State<BranchDetails> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<BranchDetails> {
  @override
  bool get wantKeepAlive => true;
  bool isScolled = false;
  late List grades = [];
  late List students = [];
  Future? teacherFuture;
  ScrollController scrollController = ScrollController();
  late TabController tabController;
  int page = 1;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  List propAdmin = [];
  int tabIndex = 0;
  Future? static;
  var authService;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  getGrades() async {
    String gradeGroup = await PrefUtils.getGrades() ?? "";
    List gradesLocale = gradeGroup == "" ? [] : jsonDecode(await PrefUtils.getGrades());
    if (isConnected != false) {
      gradesLocale.removeWhere((element) => element["property_id"] == widget.branch["id"]);

      ApiService().getPropertyDetails(widget.branch["id"], jsonDecode(authService.user.toUser())["token"]).then((value) {
        if (!mounted) return;
        setState(() {
          if (jsonDecode(authService.user.toUser())["role"] == "teacher" ||
              jsonDecode(authService.user.toUser())["role"] == "property_admin" && widget.branch["id"] != null) {
            widget.branch = {
              "name": value["data"]["name"],
              "description": value["data"]["description"],
              "contacts": value["data"]["contacts"],
              ...widget.branch,
            };
          }
          grades.clear();
          grades.addAll(value["data"]["grades"]);
          PrefUtils.setGrades(jsonEncode([
            ...gradesLocale,
            {"property_id": widget.branch["id"], "grades": value["data"]["grades"]}
          ]));
        });
      });
    } else {
      List gradeGrpup = jsonDecode(await PrefUtils.getGrades());

      List list = gradeGrpup.firstWhere((element) => element["property_id"] == widget.branch["id"])["grades"] ?? [];
      if (!mounted) return;
      setState(() {
        grades.clear();
        grades.addAll(list);
      });
    }
  }

  bool isEmpty = false;
  bool isLoading = false;
  getStudents({String? search, bool? isSearch}) async {
    if (mounted) {
      setState(() {
        _isLoadMoreRunning = true;
      });
    }

    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    String studentsGroup = await PrefUtils.getStudent() ?? "";
    List studentsLocale = studentsGroup == "" ? [] : jsonDecode(await PrefUtils.getStudents());
    if (isConnected != false) {
      studentsLocale.removeWhere((element) => element["property_id"] == widget.branch["id"]);
      print("search$search");
      ApiService().getPropertyStudents(widget.branch["id"], jsonDecode(authService.user.toUser())["token"], page, search: search).then((value) {
        if (value["api"] == "NO_DATA") {
          if (!mounted) return;
          setState(() {
            _hasNextPage = false;
            _isLoadMoreRunning = false;
            isLoading = false;
          });
        } else {
          if (value["data"] == null) {
            if (!mounted) return;
            setState(() {
              _hasNextPage = false;
              _isLoadMoreRunning = false;
              isLoading = false;
            });
          } else {
            if (value["data"]["data"].isEmpty) {
              if (!mounted) return;
              setState(() {
                _hasNextPage = false;
                isEmpty = false;
                isLoading = false;
              });
            } else {
              page += 1;
            }
            if (!mounted) return;
            setState(() {
              isLoading = false;
              if (isSearch == true) {
                students = value["data"]["data"];
              } else {
                students.addAll(value["data"]["data"]);
              }

              _isLoadMoreRunning = false;
              PrefUtils.setStudents(jsonEncode([
                ...studentsLocale,
                {"property_id": widget.branch["id"], "students": students}
              ]));
            });
          }
        }
      });
    } else {
      List areaGrpup = jsonDecode(await PrefUtils.getStudents());
      List list = areaGrpup.firstWhere((element) => element["property_id"] == widget.branch["id"])["students"] ?? [];
      if (!mounted) return;
      setState(() {
        _isLoadMoreRunning = false;
        isLoading = false;
        students.clear();
        students.addAll(list);
      });
    }
  }

  getPropertyAdmins() async {
    ApiService().getProprty(widget.branch["id"], jsonDecode(authService.user.toUser())["token"]).then((value) {
      if (!mounted) return;
      setState(() {
        propAdmin = value["data"]["property_admins"] ?? [];
      });
    });
  }

  getProprtyData(id) {
    return ApiService().getPropretyGrade(jsonDecode(authService.user.toUser())["token"], id).then((data) {
      try {
        List<dynamic> gradeClassStrings = data["data"];

        return gradeClassStrings;
      } catch (e) {
        return [];
      }
    });
  }

  List proprties = [];
  getArea() async {
    var data = await ApiService().getArea(jsonDecode(authService.user.toUser())["token"], widget.branch["area_id"]);

    if (data["api"] != "NO_DATA") {
      if (!data["data"].isEmpty) {
        if (!mounted) return;
        setState(() {
          proprties = data["data"]["properties"];
        });
      }
    }
  }

  @override
  void initState() {
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: "property_details",
        parameters: {
          'screen_name': "property_details",
          'screen_class': "Details",
        },
      );
    }();
    authService = Provider.of<AuthService>(context, listen: false);
    getArea();
    getGrades();
    getStudents();
    getPropertyAdmins();
    if (isConnected) {
      teacherFuture = ApiService().getPropertyTeacher(widget.branch["id"], jsonDecode(authService.user.toUser())["token"]);
      static = ApiService().getProprtyStatic(widget.branch["id"], jsonDecode(authService.user.toUser())["token"]);
    }

    tabController = TabController(length: 5, vsync: this);

    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        if (!mounted) return;
        if (AppFunctions().scrollListener(scrollController, "slow") != null) {
          if (AppFunctions().scrollListener(scrollController, "slow") != isScolled) {
            if (!mounted) return;
            setState(() {
              isScolled = AppFunctions().scrollListener(scrollController, "slow");
            });
          }
        }
        if (scrollController.hasClients) {
          double maxScroll = scrollController.position.maxScrollExtent;
          double currentScroll = scrollController.position.pixels;
          double delta = 200.0;
          if (maxScroll - currentScroll <= delta) {
            if (isConnected && tabIndex == 2) {
              _loadMore();
            }
          }
        }
      });

    tabController.animation!.addListener(() {
      if (!mounted) return;
      setState(() {
        tabIndex = tabController.index;
      });
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true && _isLoadMoreRunning == false && scrollController.position.extentAfter < 100) {
      try {
        getStudents();
      } catch (err) {}
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_loadMore);
    scrollController.dispose();
    tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  getUnassignedAdmins(page) {
    return ApiService().getUnassignedAdmins(jsonDecode(authService.user.toUser())["token"], page: page).then((data) {
      try {
        List admins = data["data"].map((e) => '${e["name"] ?? e["user"]["first_name"]} ${e["user"]["last_name"] ?? ""} - ${e["id"]}').toList();

        return admins;
      } catch (e) {
        return [];
      }
    });
  }

  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      drawer: const DrawerWidget(),
      body: SafeArea(
        child: widget.branch["id"] == null
            ? Center(
                child: Text(translate(context).teacher_not_in_center),
              )
            : Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          AnimatedCrossFade(
                            firstChild: ImageContainer(
                              height: 0.32,
                              imageHeight: 0.29,
                              image: widget.branch["image"] == null ? AppIcons.branchTemp : AppFunctions().getImage(widget.branch["image"]),
                            ),
                            secondChild: ImageContainer(
                              height: 0.15,
                              imageHeight: 0.12,
                              image: widget.branch["image"] == null ? AppIcons.branchTemp : AppFunctions().getImage(widget.branch["image"]),
                            ),
                            duration: const Duration(milliseconds: 200),
                            crossFadeState: !isScolled ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          ),
                          Positioned(
                            child: TabBar(
                                tabAlignment: TabAlignment.center,
                                controller: tabController,
                                isScrollable: true,
                                labelColor: const Color(0xFFFFFFFF),
                                unselectedLabelColor: const Color(0XFF7EC9C4),
                                labelPadding: const EdgeInsets.only(
                                  left: 4,
                                  right: 4,
                                ),
                                indicatorColor: Colors.transparent,
                                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                                tabs: widget.branch["property_type"] == "mosque"
                                    ? getMosqueLoginedTabsBranchDetails(context)
                                    : getLoginedTabsBranchDetails(context)),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(controller: tabController, physics: const BouncingScrollPhysics(), children: [
                          Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 24.0, left: 24),
                                  child: ListView(
                                    controller: tabIndex == 0 ? scrollController : ScrollController(),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 14.0, right: 14),
                                        child: Text(
                                          widget.branch["name"] ?? "",
                                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: getFontName(context)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 14.0, right: 14),
                                        child: Text(
                                          widget.branch["description"] ?? '',
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, fontFamily: getFontName(context)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Helper.sizedBoxH15,
                              SocialMedia(
                                socialMediaMap: {
                                  "phone": widget.branch["phone"] ?? "0505656",
                                  "email": widget.branch["email"] ?? "mhd@sad.com",
                                  "facebook": widget.branch["facebook"] ?? "sss",
                                  "instagram": widget.branch["instagram"] ?? "sss",
                                  "whatsapp": widget.branch["whatsapp"] ?? "22222",
                                  "location": widget.branch["location"] ?? "445455,45465",
                                },
                              ),
                              Helper.sizedBoxH10,
                            ],
                          ),
                          GridViewList(
                            onRefresh: () async {
                              getGrades();
                            },
                            searchController: searchController,
                            teacherClassRoomId: jsonDecode(authService.user.toUser())["grade_id"],
                            controller: tabIndex == 1 ? scrollController : ScrollController(),
                            onEditPressed: (item, index) async {
                              addClassFields[0]["value"] = item["name"];
                              addClassFields[1]["value"] = item["description"];
                              Navigator.of(context).push(createRoute(
                                AddPage(
                                  englishTitle: "edit_grade",
                                  isEdit: true,
                                  fields: addClassFields,
                                  title: translate(context).edit_class,
                                  onPressed: () async {
                                    Map result = await ApiService().editClass({
                                      "id": item["id"],
                                      "name": addClassFields[0]["value"],
                                      "description": addClassFields[1]["value"],
                                      "property_id": widget.branch["id"],
                                    }, jsonDecode(authService.user.toUser())["token"]);

                                    if (result["api"] == "SUCCESS") {
                                      getGrades();
                                    }
                                    return result["api"];
                                  },
                                ),
                              ));
                            },
                            onDeletePressed: (item, index) async {
                              showCustomDialog(context, translate(context).confirm_delete, AppConstants.appLogo, "delete", () async {
                                Map result = await ApiService().deleteClass(item["id"], jsonDecode(authService.user.toUser())["token"]);

                                if (result["api"] == "SUCCESS") {
                                  getGrades();
                                }
                                return result["api"];
                              });
                            },
                            addPage: AddPage(
                              englishTitle: "add_grade",
                              fields: addClassFields,
                              isEdit: false,
                              title: translate(context).add_class,
                              onPressed: () async {
                                Map result = await ApiService().creatClass({
                                  "id": null,
                                  "name": addClassFields[0]["value"],
                                  "description": addClassFields[1]["value"],
                                  "property_id": widget.branch["id"]
                                }, jsonDecode(authService.user.toUser())["token"]);
                                if (result["api"] == "SUCCESS") {
                                  getGrades();
                                }
                                return result["api"];
                              },
                            ),
                            permmission: jsonDecode(authService.user.toUser())["role"] == "admin" ||
                                jsonDecode(authService.user.toUser())["role"] == "branch_admin" ||
                                jsonDecode(authService.user.toUser())["role"] == "property_admin",
                            isClickable: jsonDecode(authService.user.toUser())["role"] == "admin" ||
                                jsonDecode(authService.user.toUser())["role"] == "teacher",
                            list: grades.asMap().entries.map((entry) {
                              return {
                                "id": entry.value["id"],
                                "name": entry.value["name"],
                                "description": entry.value["description"],
                                "property_id": entry.value["property_id"],
                                "property": entry.value["property"]
                              };
                            }).toList(),
                            tabs: [
                              Tab(
                                child: TabBarContainer(
                                  title: widget.branch["property_type"] == "mosque" ? translate(context).sections : translate(context).levels,
                                  onlyText: true,
                                ),
                              ),
                              ...getClassTabs(context)
                            ],
                            pageType: "class",
                          ),
                          Column(
                            children: [
                              Expanded(
                                child: GridViewList(
                                  isEmpty: isEmpty,
                                  isLoading: isLoading,
                                  onSearch: (value) async {
                                    if (value != "") {
                                      setState(() {
                                        page = 1;
                                        students.clear();
                                        _hasNextPage = true;
                                      });
                                      getStudents(search: value, isSearch: true);
                                    } else {
                                      setState(() {
                                        page = 1;
                                        students.clear();
                                        _hasNextPage = true;
                                      });
                                      students = [];
                                      getStudents();
                                      students = [];
                                    }
                                  },
                                  onRefresh: () async {
                                    setState(() {
                                      page = 1;
                                      students.clear();
                                      _hasNextPage = true;
                                    });
                                    getStudents();
                                  },
                                  onTransferPressed: jsonDecode(authService.user.toUser())["role"] == "teacher"
                                      ? null
                                      : (item, index) async {
                                          if (jsonDecode(authService.user.toUser())["role"] == "property_admin") {
                                            showLoadingDialog(context);
                                            List data = await getProprtyData(widget.branch["id"]);
                                            Navigator.of(context).pop();
                                            dropDown(context, data, false, isPagnet: false, []).then((value) async {
                                              if (value != null) {
                                                showLoadingDialog(context);
                                                Map result = await ApiService().transferStudent({
                                                  "studnet_id": item["id"],
                                                  "new_property_id": widget.branch["id"].toString(),
                                                  "new_class_id": int.parse(value.toString().split(" - ")[2]),
                                                }, jsonDecode(authService.user.toUser())["token"]);
                                                Navigator.of(context).pop();
                                              }
                                            });
                                          } else {
                                            dropDown(
                                              context,
                                              proprties,
                                              true,
                                              isPagnet: false,
                                              ["student", item],
                                              longDropDown: true,
                                            ).then((value) {
                                              if (value == "SUCCESS") {
                                                setState(() {
                                                  page = 1;
                                                  students.clear();
                                                  _hasNextPage = true;
                                                });
                                                getStudents();
                                              }
                                            });
                                          }
                                        },
                                  searchController: searchController,
                                  controller: tabIndex == 2 ? scrollController : ScrollController(),
                                  tabs: getStudentTabs(context),
                                  onDeletePressed: jsonDecode(authService.user.toUser())["role"] == "teacher" ||
                                          jsonDecode(authService.user.toUser())["role"] == "property_admin"
                                      ? null
                                      : (item, index) async {
                                          showCustomDialog(context, translate(context).confirm_delete, AppConstants.appLogo, "delete", () async {
                                            Map result = await ApiService().deleteStudent(item["id"], jsonDecode(authService.user.toUser())["token"]);

                                            if (result["api"] == "SUCCESS") {
                                              setState(() {
                                                page = 1;
                                                students.clear();
                                                _hasNextPage = true;
                                              });
                                              getStudents();
                                            }
                                            return result["api"];
                                          });
                                        },
                                  onEditPressed: jsonDecode(authService.user.toUser())["role"] == "teacher"
                                      ? null
                                      : (item, index) async {
                                          showLoadingDialog(context);
                                          await ApiService()
                                              .getStudentDetails(item["id"], jsonDecode(authService.user.toUser())["token"])
                                              .then((data) async {
                                            if (data != null && data["data"] != null) {
                                              await AppFunctions.getImageXFileByUrl(AppFunctions().getImage(data["data"]["user"]["image"]))
                                                  .then((value) {
                                                addStudentsFields[15]["value"] = value;
                                                addStudentsFields[1]["value"] = data["data"]["user"]["username"];
                                                addStudentsFields[2]["value"] = data["data"]["user"]["password"];
                                                addStudentsFields[3]["value"] = data["data"]["user"]["first_name"];
                                                addStudentsFields[4]["value"] = data["data"]["user"]["last_name"];
                                                addStudentsFields[5]["value"] = data["data"]["user"]["father_name"];
                                                addStudentsFields[6]["value"] = data["data"]["user"]["mother_name"];
                                                addStudentsFields[7]["value"] = data["data"]["user"]["birth_date"]?.split("T")[0];
                                                addStudentsFields[8]["value"] = getGenderValue(context, data["data"]["user"]["gender"]);
                                                addStudentsFields[9]["value"] =
                                                    data["data"]["parent_phone"] == "null" ? null : data["data"]["parent_phone"];
                                                addStudentsFields[10]["value"] =
                                                    data["data"]["user"]["phone"] == "null" ? null : data["data"]["user"]["phone"];
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
                                                addStudentsFields[26]["value"] =
                                                    getYesOrNoValue(context, data["data"]["user"]["are_there_disease_in_family"]);
                                                addStudentsFields[27]["value"] = data["data"]["user"]["family_disease_note"] == "null"
                                                    ? ""
                                                    : data["data"]["user"]["family_disease_note"];
                                                addStudentsFields[28]["value"] =
                                                    data["data"]["is_orphan"] == "0" ? translate(context).no : translate(context).yes;
                                                Navigator.of(context).pop();
                                                Navigator.of(context).push(createRoute(
                                                  AddPage(
                                                    englishTitle: "edit_student",
                                                    isEdit: true,
                                                    fields: addStudentsFields,
                                                    title: translate(context).edit_students,
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
                                                        "is_orphan": addStudentsFields[28]["value"] == translate(context).yes ? "1" : "0",
                                                        "user[mainImage]":
                                                            addStudentsFields[15]["value"].path == '' ? null : addStudentsFields[15]["value"]?.path,
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
                                                        'user[property_id]': widget.branch["id"],
                                                      }, jsonDecode(authService.user.toUser())["token"]);

                                                      print(result);
                                                      if (result["api"] == "SUCCESS") {
                                                        setState(() {
                                                          page = 1;
                                                          students.clear();
                                                          _hasNextPage = true;
                                                        });
                                                        getStudents();
                                                      }
                                                      return AppFunctions().getUserErrorMessage(result, context);
                                                    },
                                                  ),
                                                ));
                                              });
                                            }
                                          });
                                        },
                                  addPage: AddPage(
                                    englishTitle: "add_student",
                                    fields: addStudentsFields,
                                    isEdit: false,
                                    title: translate(context).add_student,
                                    onPressed: () async {
                                      //createProprtyStudnet
                                      Map result = await ApiService().createProprtyStudnet({
                                        "id": "",
                                        "user_id": "",
                                        "parent_work": "",
                                        "family_members_count": addStudentsFields[20]["value"],
                                        "parent_phone": addStudentsFields[9]["value"],
                                        "who_is_parent": addStudentsFields[25]["value"],
                                        "is_orphan": addStudentsFields[28]["value"] == translate(context).yes ? "1" : "0",
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
                                        'user[property_id]': widget.branch["id"],
                                      }, jsonDecode(authService.user.toUser())["token"]);

                                      if (result["api"] == "SUCCESS") {
                                        setState(() {
                                          page = 1;
                                          students.clear();
                                          _hasNextPage = true;
                                        });
                                        getStudents();
                                      }

                                      return AppFunctions().getUserErrorMessage(result, context);
                                    },
                                  ),
                                  list: students.asMap().entries.map((entry) {
                                    return {
                                      "id": entry.value["id"],
                                      "user_id": entry.value["user_id"],
                                      "name": entry.value["name"],
                                      "image": entry.value["image"],
                                      "status": getStatusValue(context, entry.value["status"]),
                                      "gender": getGenderValue(context, entry.value["gender"]),
                                      "left_at": entry.value["left_at"],
                                    };
                                  }).toList(),
                                  permmission: jsonDecode(authService.user.toUser())["role"] == "admin" ||
                                      jsonDecode(authService.user.toUser())["role"] == "branch_admin" ||
                                      jsonDecode(authService.user.toUser())["role"] == "property_admin" ||
                                      jsonDecode(authService.user.toUser())["role"] == "teacher",
                                  itemClick: jsonDecode(authService.user.toUser())["role"] == "admin" ||
                                          jsonDecode(authService.user.toUser())["role"] == "branch_admin" ||
                                          jsonDecode(authService.user.toUser())["role"] == "property_admin"
                                      ? null
                                      : (p0) => {},
                                  pageType: "student",
                                ),
                              ),
                              if (_isLoadMoreRunning && students.length != 0)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [Helper.sizedBoxH5, const CirculeProgress()],
                                  ),
                                ),
                            ],
                          ),
                          teacherFuture == null
                              ? const NoData()
                              : Column(
                                  children: [
                                    if (isConnected)
                                      Column(
                                        children: [
                                          const SizedBox(height: 15),
                                          propAdmin.isNotEmpty
                                              ? GestureDetector(
                                                  onTap: () {
                                                    deleteItem(item) async {
                                                      Map result = await ApiService()
                                                          .deletePropAdmin(item["main_id"], jsonDecode(authService.user.toUser())["token"]);

                                                      return result;
                                                    }

                                                    List group = propAdmin.asMap().entries.map((entry) {
                                                      return {
                                                        "main_id": entry.value["id"],
                                                        "id": entry.value["admin_id"],
                                                        "user_id": entry.value["admin"] == null
                                                            ? ""
                                                            : entry.value["admin"]["user"] == null
                                                                ? ""
                                                                : entry.value["admin"]["user"]["id"],
                                                        "name": entry.value["admin"] == null
                                                            ? ""
                                                            : entry.value["admin"]["user"] == null
                                                                ? ""
                                                                : '${entry.value["admin"]["user"]["first_name"]} ${entry.value["admin"]["user"]["last_name"]}',
                                                        "image": entry.value["admin"] == null
                                                            ? ""
                                                            : entry.value["admin"]["user"] == null
                                                                ? ""
                                                                : entry.value["admin"]["user"]["image"],
                                                        "gender": "male",
                                                        "status": entry.value['deleted_at'] == null
                                                            ? translate(context).active
                                                            : translate(context).inactive,
                                                        "property_id": entry.value['property_id'],
                                                        "type": "property",
                                                      };
                                                    }).toList();

                                                    addItem(admins) async {
                                                      Map result = await ApiService().addPropAdmin({
                                                        "id": null,
                                                        "admin_id": admins,
                                                        "property_id": group[0]["property_id"],
                                                      }, jsonDecode(authService.user.toUser())["token"]);

                                                      return result;
                                                    }

                                                    dropDown(
                                                            context,
                                                            group,
                                                            true,
                                                            isPagnet: false,
                                                            getData: (page) async {
                                                              return await getUnassignedAdmins(page);
                                                            },
                                                            [],
                                                            longDropDown: true,
                                                            onDelete: (item) async {
                                                              return await deleteItem(item);
                                                            },
                                                            onAdd: (item) async {
                                                              return await addItem(item);
                                                            },
                                                            isNullable: true)
                                                        .then((value) async {
                                                      if (value != null) {
                                                        if (value == "SUCCESS") {
                                                          getPropertyAdmins();
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
                                                          "${translate(context).view_managers}(${propAdmin.length})",
                                                          style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                                                        ))),
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    dropDown(context, [], true, isPagnet: true, getData: (page) async {
                                                      return await getUnassignedAdmins(page);
                                                    }, [], isNullable: true)
                                                        .then((value) async {
                                                      if (value != null) {
                                                        List newAdmins = value.map((item) => item.split(" - ")[1]).toList();
                                                        showLoadingDialog(context);
                                                        Map result = await ApiService().addPropAdmin({
                                                          "id": null,
                                                          "admin_id": newAdmins,
                                                          "property_id": widget.branch["id"],
                                                        }, jsonDecode(authService.user.toUser())["token"]);
                                                        String status = result["api"];
                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                        if (status == "SUCCESS") {
                                                          // ignore: use_build_context_synchronously
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                            content: Text(translate(context).operation_success,
                                                                style: TextStyle(fontFamily: getFontName(context))),
                                                            duration: const Duration(milliseconds: 500),
                                                          ));
                                                          Future.delayed(const Duration(seconds: 1), () {
                                                            Navigator.of(context).pop();
                                                            getPropertyAdmins();
                                                          });
                                                        } else if (status == "FAILED") {
                                                          // ignore: use_build_context_synchronously
                                                          Navigator.of(context).pop();
                                                          await FirebaseAnalytics.instance.logEvent(
                                                            name: "an_expected_error_occured_while_adding_prop_admin_${result["hints"].toString()}",
                                                            parameters: {
                                                              'screen_name':
                                                                  "an_expected_error_occured_while_adding_prop_admin_${result["hints"].toString()}",
                                                              'screen_class': "Adding",
                                                            },
                                                          );
                                                          // ignore: use_build_context_synchronously
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                            content: Text(translate(context).unexpected_error,
                                                                style: TextStyle(fontFamily: getFontName(context))),
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
                                                          translate(context).add_center_manager,
                                                          style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                                                        ))),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    Expanded(
                                      child: GridViewList(
                                        onRefresh: () async {
                                          if (isConnected) {
                                            setState(() {
                                              teacherFuture = null;
                                              teacherFuture = ApiService()
                                                  .getPropertyTeacher(widget.branch["id"], jsonDecode(authService.user.toUser())["token"]);
                                            });
                                          }
                                          
                                        },
                                        onTransferPressed: (item, index) async {
                                          print(jsonDecode(authService.user.toUser())["role"]);
                                          if (jsonDecode(authService.user.toUser())["role"] == "property_admin") {
                                            showLoadingDialog(context);
                                            List data = await getProprtyData(widget.branch["id"]);
                                            Navigator.of(context).pop();
                                            dropDown(context, data, false, isPagnet: false, []).then((value) async {
                                              if (value != null) {
                                                showLoadingDialog(context);
                                                Map result = await ApiService().transferTeacher({
                                                  "teacher_id": item["id"],
                                                  "new_property_id": widget.branch["id"].toString(),
                                                  "new_class_id": int.parse(value.toString().split(" - ")[2]),
                                                }, jsonDecode(authService.user.toUser())["token"]);
                                                Navigator.of(context).pop();
                                              }
                                            });
                                          } else {
                                            dropDown(
                                              context,
                                              proprties,
                                              true,
                                              isPagnet: false,
                                              ["teacher", item],
                                              longDropDown: true,
                                            ).then((value) async {
                                              if (value == "SUCCESS") {
                                                setState(() {
                                                  teacherFuture = null;
                                                  teacherFuture = ApiService()
                                                      .getPropertyTeacher(widget.branch["id"], jsonDecode(authService.user.toUser())["token"]);
                                                });
                                              }
                                            });
                                          }
                                        },
                                        searchController: searchController,
                                        controller: tabIndex == 3 ? scrollController : ScrollController(),
                                        onDeletePressed: jsonDecode(authService.user.toUser())["role"] == "teacher" ||
                                                jsonDecode(authService.user.toUser())["role"] == "branch_admin" ||
                                                jsonDecode(authService.user.toUser())["role"] == "property_admin"
                                            ? null
                                            : (item, index) async {
                                                showCustomDialog(context, translate(context).confirm_delete3, AppConstants.appLogo, "delete",
                                                    () async {
                                                  Map result =
                                                      await ApiService().deleteTeacher(item["id"], jsonDecode(authService.user.toUser())["token"]);

                                                  if (result["api"] == "SUCCESS") {
                                                    setState(() {
                                                      teacherFuture = null;
                                                      teacherFuture = ApiService()
                                                          .getPropertyTeacher(widget.branch["id"], jsonDecode(authService.user.toUser())["token"]);
                                                    });
                                                  }
                                                  return result["api"];
                                                });
                                              },
                                        onEditPressed: (item, index) async {
                                          showLoadingDialog(context);
                                          await ApiService()
                                              .getTeacherDetails(item["id"], jsonDecode(authService.user.toUser())["token"])
                                              .then((data) async {
                                            if (data != null && data["data"] != null) {
                                              await AppFunctions.getImageXFileByUrl(AppFunctions().getImage(data["data"]["user"]["image"]))
                                                  .then((value) {
                                                addTeachersFields[14]["value"] = value;
                                                addTeachersFields[1]["value"] = data["data"]["user"]["username"];
                                                addTeachersFields[2]["value"] = data["data"]["user"]["password"];
                                                addTeachersFields[3]["value"] = data["data"]["user"]["first_name"];
                                                addTeachersFields[4]["value"] = data["data"]["user"]["last_name"];
                                                addTeachersFields[5]["value"] = data["data"]["user"]["father_name"];
                                                addTeachersFields[6]["value"] = data["data"]["user"]["mother_name"];
                                                addTeachersFields[7]["value"] = data["data"]["user"]["birth_date"]?.split("T")[0];
                                                addTeachersFields[8]["value"] = getGenderValue(context, data["data"]["user"]["gender"]);
                                                addTeachersFields[9]["value"] = data["data"]["user"]["phone"];
                                                addTeachersFields[10]["value"] = data["data"]["user"]["identity_number"];
                                                addTeachersFields[11]["value"] = data["data"]["user"]["birth_place"];
                                                addTeachersFields[12]["value"] = data["data"]["user"]["email"];
                                                addTeachersFields[13]["value"] = getStatusValue(context, data["data"]["user"]["status"]);
                                                addTeachersFields[17]["value"] = data["data"]["user"]["current_address"];
                                                addTeachersFields[18]["value"] = data["data"]["user"]["blood_type"];
                                                addTeachersFields[19]["value"] = getMarriedValue(context, data["data"]?["marital_status"] ?? "");
                                                addTeachersFields[20]["value"] =
                                                    data["data"]["wives_count"] == "null" ? "0" : data["data"]["wives_count"];
                                                addTeachersFields[21]["value"] = data["data"]["children_count"];
                                                addTeachersFields[22]["value"] = getYesOrNoValue(context, data["data"]["user"]["is_has_disease"]);
                                                addTeachersFields[23]["value"] =
                                                    data["data"]["user"]["disease_name"] == "null" ? "" : data["data"]["disease_name"];
                                                addTeachersFields[24]["value"] = getYesOrNoValue(context, data["data"]["user"]["is_has_treatment"]);
                                                addTeachersFields[25]["value"] =
                                                    data["data"]["user"]["treatment_name"] == "null" ? "" : data["data"]["treatment_name"];
                                                addTeachersFields[26]["value"] =
                                                    getYesOrNoValue(context, data["data"]["user"]["are_there_disease_in_family"]);
                                                addTeachersFields[27]["value"] =
                                                    data["data"]["user"]["family_disease_note"] == "null" ? "" : data["data"]["family_disease_note"];
                                                Navigator.of(context).pop();
                                                Navigator.of(context).push(createRoute(
                                                  AddPage(
                                                    englishTitle: "edit_teacher",
                                                    isEdit: true,
                                                    fields: addTeachersFields,
                                                    title: translate(context).edit_teacher,
                                                    onPressed: () async {
                                                      Map result = await ApiService().editProprtyTeacher({
                                                        "id": item["id"],
                                                        "user_id": item["user_id"],
                                                        "marital_status": getMarriedKey(context, addTeachersFields[19]["value"]),
                                                        "wives_count": addTeachersFields[20]["value"],
                                                        "children_count": addTeachersFields[21]["value"],
                                                        "user[mainImage]":
                                                            addTeachersFields[14]["value"].path == '' ? null : addTeachersFields[14]["value"]?.path,
                                                        'user[id]': "",
                                                        "user[status]": getStatusKey(context, addTeachersFields[13]["value"]),
                                                        "user[email]": addTeachersFields[12]["value"],
                                                        "user[first_name]": addTeachersFields[3]["value"],
                                                        "user[last_name]": addTeachersFields[4]["value"],
                                                        "user[username]": addTeachersFields[1]["value"],
                                                        'user[is_approved]': "1",
                                                        "user[password]": addTeachersFields[2]["value"],
                                                        "user[identity_number]": addTeachersFields[10]["value"],
                                                        "user[phone]": addTeachersFields[9]["value"],
                                                        "user[gender]": getGenderKey(context, addTeachersFields[8]["value"]),
                                                        "user[birth_date]": addTeachersFields[7]["value"],
                                                        "user[birth_place]": addTeachersFields[11]["value"],
                                                        "user[father_name]": addTeachersFields[5]["value"],
                                                        "user[mother_name]": addTeachersFields[6]["value"],
                                                        "user[qr_code]": "",
                                                        "user[blood_type]": addTeachersFields[18]["value"],
                                                        "user[note]": "",
                                                        "user[current_address]": addTeachersFields[17]["value"],
                                                        "user[is_has_disease]": getYesOrNoKey(context, addTeachersFields[22]["value"]),
                                                        "user[disease_name]": addTeachersFields[23]["value"],
                                                        "user[is_has_treatment]": getYesOrNoKey(context, addTeachersFields[24]["value"]),
                                                        "user[treatment_name]": addTeachersFields[25]["value"],
                                                        "user[are_there_disease_in_family]": getYesOrNoKey(context, addTeachersFields[26]["value"]),
                                                        "user[family_disease_note]": addTeachersFields[27]["value"],
                                                        "user[property_id]": widget.branch["id"],
                                                      }, jsonDecode(authService.user.toUser())["token"]);

                                                      if (result["api"] == "SUCCESS") {
                                                        setState(() {
                                                          teacherFuture = null;
                                                          teacherFuture = ApiService().getPropertyTeacher(
                                                              widget.branch["id"], jsonDecode(authService.user.toUser())["token"]);
                                                        });
                                                      }
                                                      return AppFunctions().getUserErrorMessage(result, context);
                                                    },
                                                  ),
                                                ));
                                              });
                                            }
                                          });
                                        },
                                        addPage: AddPage(
                                          englishTitle: "add_teacher",
                                          fields: addTeachersFields,
                                          isEdit: false,
                                          title: translate(context).add_teacher,
                                          onPressed: () async {
                                            Map result = await ApiService().createProprtyTeacher({
                                              "id": "",
                                              "user_id": "",
                                              "marital_status": getMarriedKey(context, addTeachersFields[19]["value"]),
                                              "wives_count": addTeachersFields[20]["value"],
                                              "children_count": addTeachersFields[21]["value"],
                                              "user[mainImage]":
                                                  addTeachersFields[14]["value"].path == '' ? null : addTeachersFields[14]["value"]?.path,
                                              'user[id]': "",
                                              "user[status]": getStatusKey(context, addTeachersFields[13]["value"]),
                                              "user[email]": addTeachersFields[12]["value"],
                                              "user[first_name]": addTeachersFields[3]["value"],
                                              "user[last_name]": addTeachersFields[4]["value"],
                                              "user[username]": addTeachersFields[1]["value"],
                                              'user[is_approved]': jsonDecode(authService.user.toUser())["role"] == "teacher" ||
                                                      jsonDecode(authService.user.toUser())["role"] == "branch_admin" ||
                                                      jsonDecode(authService.user.toUser())["role"] == "property_admin"
                                                  ? "0"
                                                  : "1",
                                              "user[password]": addTeachersFields[2]["value"],
                                              "user[identity_number]": addTeachersFields[10]["value"],
                                              "user[phone]": addTeachersFields[9]["value"],
                                              "user[gender]": getGenderKey(context, addTeachersFields[8]["value"]),
                                              "user[birth_date]": addTeachersFields[7]["value"],
                                              "user[birth_place]": addTeachersFields[11]["value"],
                                              "user[father_name]": addTeachersFields[5]["value"],
                                              "user[mother_name]": addTeachersFields[6]["value"],
                                              "user[qr_code]": "",
                                              "user[blood_type]": addTeachersFields[18]["value"],
                                              "user[note]": "",
                                              "user[current_address]": addTeachersFields[17]["value"],
                                              "user[is_has_disease]": getYesOrNoKey(context, addTeachersFields[22]["value"]),
                                              "user[disease_name]": addTeachersFields[23]["value"],
                                              "user[is_has_treatment]": getYesOrNoKey(context, addTeachersFields[24]["value"]),
                                              "user[treatment_name]": addTeachersFields[25]["value"],
                                              "user[are_there_disease_in_family]": getYesOrNoKey(context, addTeachersFields[26]["value"]),
                                              "user[family_disease_note]": addTeachersFields[27]["value"],
                                              "user[property_id]": widget.branch["id"],
                                            }, jsonDecode(authService.user.toUser())["token"]);

                                            if (result["api"] == "SUCCESS") {
                                              setState(() {
                                                teacherFuture = null;
                                                teacherFuture = ApiService()
                                                    .getPropertyTeacher(widget.branch["id"], jsonDecode(authService.user.toUser())["token"]);
                                              });
                                            }

                                            return AppFunctions().getUserErrorMessage(result, context);
                                          },
                                        ),
                                        list: const [],
                                        future: teacherFuture,
                                        permmission: jsonDecode(authService.user.toUser())["role"] == "admin" ||
                                            jsonDecode(authService.user.toUser())["role"] == "branch_admin" ||
                                            jsonDecode(authService.user.toUser())["role"] == "property_admin",
                                        pageType: "teacher",
                                        tabs: jsonDecode(authService.user.toUser())["role"] == "admin" ||
                                                jsonDecode(authService.user.toUser())["role"] == "branch_admin" ||
                                                jsonDecode(authService.user.toUser())["role"] == "property_admin"
                                            ? getTeacherTabsWithRreviews(context)
                                            : getTeacherTabsWithRreviews(context),
                                      ),
                                    ),
                                  ],
                                ),
                          // ListViewComponent(
                          //   searchController: searchController,
                          //   controller: tabIndex == 4 ? scrollController : ScrollController(),
                          //   addPage: AddPage(fields: getAddBookFields(context), title: "إضافة كتاب"),
                          //   list: const [],
                          //   permmission: jsonDecode(authService.user.toUser())["role"] == "admin",
                          //   future: branchFuture,
                          //   futureListName: "subjects",
                          //   tabs: const [],
                          //   pageType: "book",
                          // ),
                          // ListViewComponent(
                          //   searchController: searchController,
                          //   controller: tabIndex == 7 ? scrollController : ScrollController(),
                          //   addPage: AddPage(fields: getAddReportFields(context), title: "إضافة تقرير"),
                          //   list: bookTemp,
                          //   pageType: "report",
                          //   tabs: const [],
                          // ),
                          static == null
                              ? const NoData()
                              : Statistics(
                                  future: static,
                                  controller: scrollController,
                                  type: widget.branch["property_type"] == "mosque" ? "mosque" : "proprety",
                                ),
                        ]),
                      ),
                    ],
                  ),
                  if (widget.isActionBardisabled == null)
                    const Positioned(
                        child: ActionBar(
                      menuseItem: [],
                    ))
                ],
              ),
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  final double height;
  final double imageHeight;
  final String image;
  const ImageContainer({Key? key, required this.height, required this.imageHeight, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(image ?? AppIcons.branchTemp),
                  fit: BoxFit.cover,
                ),
              ),
              child: ContainerShadow(height: imageHeight),
            ),
            onTap: () {
              Navigator.of(context).push(createRoute(ImageView(image: image ?? AppIcons.branchTemp)));
            },
          ),
        ],
      ),
    );
  }
}
