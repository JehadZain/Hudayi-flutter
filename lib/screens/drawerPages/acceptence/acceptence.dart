import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/services/API/api.dart';
import 'package:hudayi/ui/helper/App_Colors.dart';
import 'package:hudayi/ui/helper/App_Constants.dart';
import 'package:hudayi/ui/helper/App_Consts.dart';
import 'package:hudayi/ui/helper/App_Dialog.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:hudayi/ui/widgets/Circule_Progress.dart';
import 'package:hudayi/ui/widgets/helper.dart';
import 'package:hudayi/ui/widgets/list_View_Component.dart';
import 'package:hudayi/ui/widgets/page_Header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Acceptence extends StatefulWidget {
  const Acceptence({Key? key}) : super(key: key);

  @override
  State<Acceptence> createState() => _BooksState();
}

class _BooksState extends State<Acceptence> {
  final TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List classRooms = [];
  List users = [];
  bool isScolled = false;
  bool isEmpty = false;
  bool isClassRoom = true;
  int page = 1;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  var authService;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  getData(isClassroom) {
    if (isClassroom) {
      ApiService().pendingClassRooms(jsonDecode(authService.user.toUser())["token"], page).then((data) {
        if (data["api"] != "NO_DATA") {
          setState(() {
            _isLoadMoreRunning = true;
          });
          if (data["data"]["data"].isEmpty) {
            setState(() {
              _hasNextPage = false;
            });
          } else {
            page += 1;
          }
          if (data["data"]["data"] != null) {
            setState(() {
              classRooms.addAll(data["data"]["data"]);
              _isLoadMoreRunning = false;
              isLoading = false;
            });
          } else {
            setState(() {
              isEmpty = true;
              isLoading = false;
              _isLoadMoreRunning = false;
            });
          }
        } else {
          setState(() {
            isEmpty = true;
            isLoading = false;
            _isLoadMoreRunning = false;
          });
        }
      });
    }

    if (!isClassroom) {
      ApiService().pendingUsers(jsonDecode(authService.user.toUser())["token"], page).then((data) {
        setState(() {
          _isLoadMoreRunning = true;
        });
        if (data["api"] != "NO_DATA") {
          if (data["data"]["data"].isEmpty) {
            setState(() {
              _hasNextPage = false;
            });
          } else {
            page += 1;
          }
          if (data["data"]["data"] != null) {
            setState(() {
              users.addAll(data["data"]["data"]);
              _isLoadMoreRunning = false;
              isLoading = false;
            });
          } else {
            setState(() {
              isEmpty = true;
              _isLoadMoreRunning = false;
              isLoading = false;
            });
          }
        } else {
          setState(() {
            isEmpty = true;
            _isLoadMoreRunning = false;
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  void initState() {
    FirebaseAnalytics.instance.logEvent(
      name: 'pending_page',
      parameters: {
        'screen_name': "pending_page",
        'screen_class': "profile",
      },
    );
    authService = Provider.of<AuthService>(context, listen: false);
    users.clear();
    classRooms.clear();
    getData(isClassRoom);
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        double maxScroll = scrollController.position.maxScrollExtent;
        double currentScroll = scrollController.position.pixels;
        double delta = 200.0;
        if (maxScroll - currentScroll <= delta) {
          _loadMore();
        }
      });
  }

  void _loadMore() async {
    if (_hasNextPage == true && _isLoadMoreRunning == false && scrollController.position.extentAfter < 100) {
      try {
        getData(isClassRoom);
      } catch (err) {}
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_loadMore);
    super.dispose();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              users.clear();
              classRooms.clear();
              page = 1;
              _hasNextPage = true;
              isLoading = true;
              getData(!isClassRoom);

              isClassRoom = !isClassRoom;
              _isLoadMoreRunning = false;
            });
          },
          backgroundColor: AppColors.primary,
          child: isClassRoom ? const Icon(Icons.play_lesson) : const Icon(Icons.person),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageHeader(
                    checkedValue: "noDialog",
                    path: XFile(" "),
                    title: isClassRoom ? translate(context).sections_awaiting_approval : translate(context).people_awaiting_approval,
                    isCircle: false,
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    isLoading
                        ? const CirculeProgress()
                        : isClassRoom && classRooms.isEmpty
                            ? Expanded(
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    setState(() {
                                      users.clear();
                                      classRooms.clear();
                                      page = 1;
                                      _hasNextPage = true;
                                    });
                                    getData(isClassRoom);
                                  },
                                  child: Stack(
                                    children: [
                                      ListView(),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 0.0),
                                        child: Center(child: Text(translate(context).no_information_available)),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : !isClassRoom && users.isEmpty
                                ? Expanded(
                                    child: RefreshIndicator(
                                      onRefresh: () async {
                                        setState(() {
                                          users.clear();
                                          classRooms.clear();
                                          page = 1;
                                          _hasNextPage = true;
                                        });
                                        getData(isClassRoom);
                                      },
                                      child: Stack(
                                        children: [
                                          ListView(),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 0.0),
                                            child: Center(child: Text(translate(context).no_information_available)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: ListViewComponent(
                                      onRefresh: () async {
                                        setState(() {
                                          users.clear();
                                          classRooms.clear();
                                          page = 1;
                                          _hasNextPage = true;
                                        });
                                        getData(isClassRoom);
                                      },
                                      onDeletePressed: null,
                                      onEditPressed: null,
                                      disableContaineronTap: (item) {
                                        if (isClassRoom) {
                                          Navigator.of(context).push(createRoute(
                                            AddPage(
                                              isEdit: true,
                                              isAcceptence: true,
                                              acceptPressed: () {
                                                showCustomDialog(context, translate(context).confirm_accept, AppConstants.appLogo, "delete",
                                                    () async {
                                                  Map result = await ApiService().editClassRoom({
                                                    "id": item["id"],
                                                    "name": item["name"].toString(),
                                                    "capacity": item["capacity"].toString(),
                                                    "mainImage": "null",
                                                    "grade_id": item["grade_id"],
                                                    "is_approved": "1",
                                                  }, jsonDecode(authService.user.toUser())["token"]);

                                                  if (result["api"] == "SUCCESS") {
                                                    setState(() {
                                                      users.clear();
                                                      classRooms.clear();
                                                      page = 1;
                                                      _hasNextPage = true;
                                                    });
                                                    getData(isClassRoom);
                                                    Navigator.of(context).pop();
                                                  }
                                                  return result["api"];
                                                });
                                              },
                                              rejectPressed: () {
                                                showCustomDialog(context, translate(context).confirm_reject, AppConstants.appLogo, "delete",
                                                    () async {
                                                  Map result =
                                                      await ApiService().deleteClassRoom(item["id"], jsonDecode(authService.user.toUser())["token"]);

                                                  if (result["api"] == "SUCCESS") {
                                                    setState(() {
                                                      users.clear();
                                                      classRooms.clear();
                                                      page = 1;
                                                      _hasNextPage = true;
                                                    });
                                                    getData(isClassRoom);
                                                    Navigator.of(context).pop();
                                                  }
                                                  return result["api"];
                                                });
                                              },
                                              fields: [
                                                {"type": "text", "value": item["name"], "title": translate(context).section_name, "readOnly": true},
                                                {
                                                  "type": "text",
                                                  "value": item["grade"]["id"].toString(),
                                                  "title": translate(context).grade_id,
                                                  "readOnly": true
                                                },
                                                {
                                                  "type": "text",
                                                  "value": item["grade"]["name"],
                                                  "title": translate(context).grade_name,
                                                  "readOnly": true
                                                },
                                                {
                                                  "type": "text",
                                                  "value": item["grade"]["property"]["id"].toString(),
                                                  "title": translate(context).center_id,
                                                  "readOnly": true
                                                },
                                                {
                                                  "type": "text",
                                                  "value": item["grade"]["property"]["name"],
                                                  "title": translate(context).center_name,
                                                  "readOnly": true
                                                },
                                                {
                                                  "type": "text",
                                                  "value": "${item["type"]}",
                                                  "title": translate(context).section_capacity,
                                                  "readOnly": true
                                                },
                                              ],
                                              title: translate(context).section_information,
                                              englishTitle: "pinding_class_room_informations",
                                            ),
                                          ));
                                        } else {
                                          Navigator.of(context).push(createRoute(
                                            AddPage(
                                              isEdit: true,
                                              acceptPressed: () {
                                                showCustomDialog(context, translate(context).confirm_accept, AppConstants.appLogo, "delete",
                                                    () async {
                                                  Map result =
                                                      await ApiService().acceptUser(item["id"], jsonDecode(authService.user.toUser())["token"]);

                                                  if (result["api"] == "SUCCESS") {
                                                    setState(() {
                                                      users.clear();
                                                      classRooms.clear();
                                                      page = 1;
                                                      _hasNextPage = true;
                                                    });
                                                    getData(isClassRoom);
                                                    Navigator.of(context).pop();
                                                  }
                                                  return result["api"];
                                                });
                                              },
                                              rejectPressed: () {
                                                showCustomDialog(context, translate(context).confirm_reject, AppConstants.appLogo, "delete",
                                                    () async {
                                                  Map result =
                                                      await ApiService().deleteUser(item["id"], jsonDecode(authService.user.toUser())["token"]);

                                                  if (result["api"] == "SUCCESS") {
                                                    setState(() {
                                                      users.clear();
                                                      classRooms.clear();
                                                      page = 1;
                                                      _hasNextPage = true;
                                                    });
                                                    getData(isClassRoom);
                                                    Navigator.of(context).pop();
                                                  }
                                                  return result["api"];
                                                });
                                              },
                                              isAcceptence: true,
                                              fields: [
                                                {"type": "flutterText", "title": translate(context).account_information},
                                                {
                                                  "type": "text",
                                                  "value":
                                                      "${item == null ? translate(context).not_available : item["first_name"]} ${item["last_name"]}",
                                                  "title": translate(context).first_name_last_name
                                                },
                                                {"type": "text", "value": item["father_name"], "title": translate(context).father_name},
                                                {"type": "text", "value": item["mother_name"], "title": translate(context).mother_name},
                                                {
                                                  "type": "date",
                                                  "value": item["birth_date"]?.split("T")[0],
                                                  "title": translate(context).date_of_birth
                                                },
                                                {
                                                  "type": "oneSelection",
                                                  "value": getGenderValue(context, item["gender"]),
                                                  "title": translate(context).gender,
                                                  "selections": [translate(context).female, translate(context).male]
                                                },
                                                {"type": "number", "value": item["phone"], "title": translate(context).student_phone_number},
                                                {"type": "number", "value": item["identity_number"], "title": translate(context).national_id_number},
                                                {"type": "text", "value": item["birth_place"], "title": translate(context).place_of_birth},
                                                {
                                                  "type": "oneSelection",
                                                  "value": getStatusValue(context,  item["status"]),
                                                  "title": translate(context).student_status,
                                                  "selections": [translate(context).inactive, translate(context).active]
                                                },
                                                {"type": "flutterText", "title": translate(context).private_account_information},
                                                {
                                                  "type": "text",
                                                  "value": item["current_address"] ?? translate(context).not_available,
                                                  "title": translate(context).current_residence
                                                },
                                                {
                                                  "type": "oneSelection",
                                                  "value": item["blood_type"],
                                                  "title": translate(context).blood_type,
                                                  "selections": const ["A+", "A-", "B+", "B-", "O+", "O-", "-AB", "+AB"]
                                                },
                                                {
                                                  "type": "oneSelection",
                                                  "value": getYesOrNoValue(context,  item["is_has_disease"]),
                                                  "title": translate(context).chronic_illness_present,
                                                  "selections": [translate(context).no, translate(context).yes]
                                                },
                                                {"type": "text", "value": item["disease_name"], "title": translate(context).illness_name},
                                                {
                                                  "type": "oneSelection",
                                                  "value": getYesOrNoValue(context, item["is_has_treatment"]),
                                                  "title": translate(context).treatment_available,
                                                  "selections": [translate(context).no, translate(context).yes]
                                                },
                                                {"type": "text", "value": item["treatment_name"], "title": translate(context).treatment_name},
                                                {
                                                  "type": "oneSelection",
                                                  "value": getYesOrNoValue(context, item["are_there_disease_in_family"]),
                                                  "title": translate(context).family_chronic_illness,
                                                  "selections": [translate(context).no, translate(context).yes]
                                                },
                                                {"type": "text", "value": item["family_disease_note"], "title": translate(context).illness_name},
                                              ],
                                              title: translate(context).person_information,
                                              englishTitle: "pinding_user_informations",
                                            ),
                                          ));
                                        }
                                      },
                                      searchController: searchController,
                                      controller: scrollController,
                                      addPage: null,
                                      isAdding: false,
                                      list: isClassRoom
                                          ? classRooms.asMap().entries.map((entry) {
                                              return {
                                                "id": entry.value["id"],
                                                "name": entry.value["name"] ?? translate(context).not_available,
                                                "type": entry.value["capacity"] ?? translate(context).not_available,
                                                "description": translate(context).click_for_details,
                                                "grade_id": entry.value["grade_id"],
                                                "grade": entry.value["grade"],
                                                "mainImage": entry.value["image"],
                                              };
                                            }).toList()
                                          : users.asMap().entries.map((entry) {
                                              return {
                                                "first_name": entry.value["first_name"],
                                                "last_name": entry.value["last_name"],
                                                "identity_number": entry.value["identity_number"],
                                                "username": entry.value["username"],
                                                "phone": entry.value["phone"],
                                                "gender": getGenderValue(context, entry.value["gender"]),
                                                "birth_date": entry.value["birth_date"]?.split("T")[0],
                                                "birth_place": entry.value["birth_place"],
                                                "mother_name": entry.value["mother_name"],
                                                "father_name": entry.value["father_name"],
                                                "qr_code": entry.value["qr_code"],
                                                "blood_type": entry.value["blood_type"],
                                                "note": entry.value["note"],
                                                "current_address": entry.value["current_address"],
                                                "is_has_disease": getYesOrNoKey(context, entry.value["is_has_disease"]),
                                                "disease_name": entry.value["disease_name"],
                                                "is_has_treatment": entry.value["is_has_treatment"],
                                                "is_approved": "1",
                                                "image": entry.value["image"],
                                                "status": getStatusValue(context, entry.value["status"]),
                                                "family_disease_note": entry.value["family_disease_note"],
                                                "are_there_disease_in_family": entry.value["are_there_disease_in_family"],
                                                "treatment_name": entry.value["treatment_name"],
                                                "email": entry.value["email"],
                                                "id": entry.value["id"],
                                                "name":
                                                    '${entry.value["first_name"] ?? translate(context).not_available} ${entry.value["last_name"] ?? translate(context).not_available}',
                                                "type": getGenderValue(context, entry.value["gender"]),
                                                "description":
                                                    '${entry.value["email"] ?? translate(context).not_available} - ${getStatusValue(context, entry.value["status"])}',
                                              };
                                            }).toList(),
                                      tabs: const [],
                                      pageType: "subClass",
                                    ),
                                  ),
                    if (_isLoadMoreRunning)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [Helper.sizedBoxH5, const CirculeProgress()],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
