// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/services/API/api.dart';
import 'package:hudayi/ui/helper/App_Constants.dart';
import 'package:hudayi/ui/helper/App_Consts.dart';
import 'package:hudayi/ui/helper/App_Dialog.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:hudayi/ui/widgets/Circule_Progress.dart';
import 'package:hudayi/ui/widgets/drawer.dart';
import 'package:hudayi/ui/widgets/helper.dart';
import 'package:hudayi/ui/widgets/list_View_Component.dart';
import 'package:hudayi/ui/widgets/page_Header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Admins extends StatefulWidget {
  const Admins({super.key});

  @override
  State<Admins> createState() => _AdminsState();
}

class _AdminsState extends State<Admins> {
  final TextEditingController searchController = TextEditingController();
  ScrollController _controller = ScrollController();
  List students = [];
  int page = 1;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  bool isEmpty = false;
  bool isLoading = false;
  String _currentSearch = "";
  // ignore: prefer_typing_uninitialized_variables
  var authService;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  getData({String? search}) {
    setState(() {
      _isLoadMoreRunning = true;
      isLoading = true;
    });
    ApiService()
        .getAllAdmins(jsonDecode(authService.user.toUser())["token"],
            page: page, search: search)
        .then((data) {
      if (data["api"] == "NO_DATA") {
        setState(() {
          _hasNextPage = false;
          isEmpty = true;
          isLoading = false;
          _isLoadMoreRunning = false;
        });
      } else {
        if (data["data"]["data"].isEmpty) {
          setState(() {
            _hasNextPage = false;
            isLoading = false;
            _isLoadMoreRunning = false;
          });
        } else {
          page += 1;
        }
        final List incoming = List.from(data["data"]["data"]);
        final Set existingIds = students.map((e) => e["id"]).toSet();
        final List uniqueIncoming =
            incoming.where((e) => !existingIds.contains(e["id"])).toList();
        setState(() {
          students.addAll(uniqueIncoming);
          _isLoadMoreRunning = false;
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    FirebaseAnalytics.instance.logEvent(
      name: 'all_admins_page',
      parameters: {
        'screen_name': "all_admins_page",
        'screen_class': "profile",
      },
    );
    authService = Provider.of<AuthService>(context, listen: false);
    getData();
    super.initState();
    _controller = ScrollController()
      ..addListener(() {
        double maxScroll = _controller.position.maxScrollExtent;
        double currentScroll = _controller.position.pixels;
        double delta = 200.0;
        if (maxScroll - currentScroll <= delta) {
          _loadMore();
        }
      });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 100) {
      try {
        if (_currentSearch.isNotEmpty) {
          getData(search: _currentSearch);
        } else {
          getData();
        }
        // ignore: empty_catches
      } catch (err) {}
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PageHeader(
                checkedValue: "noDialog",
                path: XFile(" "),
                title: translate(context).managers,
                isCircle: false,
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListViewComponent(
                        isLoading: isLoading,
                        onSearch: (value) {
                          _currentSearch = value;
                          if (value != "") {
                            setState(() {
                              students.clear();
                              page = 1;
                              _hasNextPage = true;
                              isEmpty = false;
                            });
                            getData(search: value);
                          } else {
                            setState(() {
                              students.clear();
                              page = 1;
                              _hasNextPage = true;
                            });
                            getData();
                          }
                        },
                        isEmpty: isEmpty,
                        onRefresh: () async {
                          if (_currentSearch.isNotEmpty) {
                            // When searching, disable refresh to avoid fetching full list
                            return;
                          }
                          setState(() {
                            students.clear();
                            page = 1;
                            _hasNextPage = true;
                          });
                          getData();
                        },
                        searchController: searchController,
                        controller: _controller,
                        isClickable: true,
                        onDeletePressed: jsonDecode(
                                    authService.user.toUser())["role"] ==
                                "teacher"
                            ? null
                            : (item, index) async {
                                showCustomDialog(
                                    context,
                                    translate(context).confirm_delete4,
                                    AppConstants.appLogo,
                                    "delete", () async {
                                  Map result = await ApiService().deleteAdmin(
                                      item["id"],
                                      jsonDecode(
                                          authService.user.toUser())["token"]);

                                  if (result["api"] == "SUCCESS") {
                                    setState(() {
                                      students.clear();
                                      page = 1;
                                      _hasNextPage = true;
                                    });
                                    getData();
                                  }
                                  return result["api"];
                                });
                              },
                        onEditPressed: (item, index) async {
                          showLoadingDialog(context);
                          await ApiService()
                              .getAdminDetails(
                                  item["id"],
                                  jsonDecode(
                                      authService.user.toUser())["token"])
                              .then((data) async {
                            if (data != null && data["data"] != null) {
                              await AppFunctions.getImageXFileByUrl(
                                      AppFunctions().getImage(data["data"]
                                          ["user"]["user"]["image"]))
                                  .then((value) {
                                addTeachersFields[14]["value"] = value;
                                addTeachersFields[1]["value"] =
                                    data["data"]["user"]["user"]["username"];
                                addTeachersFields[2]["value"] =
                                    data["data"]["user"]["user"]["password"];
                                addTeachersFields[3]["value"] =
                                    data["data"]["user"]["user"]["first_name"];
                                addTeachersFields[4]["value"] =
                                    data["data"]["user"]["user"]["last_name"];
                                addTeachersFields[5]["value"] =
                                    data["data"]["user"]["user"]["father_name"];
                                addTeachersFields[6]["value"] =
                                    data["data"]["user"]["user"]["mother_name"];
                                addTeachersFields[7]["value"] = data["data"]
                                        ["user"]["user"]["birth_date"]
                                    ?.split("T")[0];
                                addTeachersFields[8]["value"] = getGenderValue(
                                    context,
                                    data["data"]["user"]["user"]["gender"]);
                                addTeachersFields[9]["value"] =
                                    data["data"]["user"]["user"]["phone"];
                                addTeachersFields[10]["value"] = data["data"]
                                    ["user"]["user"]["identity_number"];
                                addTeachersFields[11]["value"] =
                                    data["data"]["user"]["user"]["birth_place"];
                                addTeachersFields[12]["value"] =
                                    data["data"]["user"]["user"]["email"];
                                addTeachersFields[13]["value"] = getStatusValue(
                                    context,
                                    data["data"]["user"]["user"]["status"]);
                                addTeachersFields[17]["value"] = data["data"]
                                    ["user"]["user"]["current_address"];
                                addTeachersFields[18]["value"] =
                                    data["data"]["user"]["user"]["blood_type"];
                                addTeachersFields[19]["value"] =
                                    getMarriedValue(
                                        context,
                                        data["data"]["user"]
                                                ?["marital_status"] ??
                                            "");
                                addTeachersFields[20]["value"] = data["data"]
                                            ["user"]["wives_count"] ==
                                        "null"
                                    ? "0"
                                    : data["data"]["user"]["wives_count"];
                                addTeachersFields[21]["value"] =
                                    data["data"]["user"]["children_count"];
                                addTeachersFields[22]["value"] =
                                    getYesOrNoValue(
                                        context,
                                        data["data"]["user"]['user']
                                            ["is_has_disease"]);
                                addTeachersFields[23]["value"] = data["data"]
                                            ["user"]['user']["disease_name"] ==
                                        "null"
                                    ? ""
                                    : data["data"]["user"]["user"]
                                        ["disease_name"];
                                addTeachersFields[24]["value"] =
                                    getYesOrNoValue(
                                        context,
                                        data["data"]["user"]['user']
                                            ["is_has_treatment"]);
                                addTeachersFields[25]["value"] = data["data"]
                                                ["user"]['user']
                                            ["treatment_name"] ==
                                        "null"
                                    ? ""
                                    : data["data"]["user"]["user"]
                                        ["treatment_name"];
                                addTeachersFields[26]["value"] =
                                    getYesOrNoValue(
                                        context,
                                        data["data"]["user"]['user']
                                            ["are_there_disease_in_family"]);
                                addTeachersFields[27]["value"] = data["data"]
                                                ["user"]['user']
                                            ["family_disease_note"] ==
                                        "null"
                                    ? ""
                                    : data["data"]["user"]["user"]
                                        ["family_disease_note"];

                                Navigator.of(context).pop();
                                Navigator.of(context).push(createRoute(
                                  AddPage(
                                    englishTitle: "edit_admins",
                                    isEdit: true,
                                    fields: addTeachersFields,
                                    title: translate(context).edit_manager,
                                    onPressed: () async {
                                      Map result = await ApiService().editAdmin(
                                          {
                                            "id": item["id"],
                                            "user_id": item["user_id"],
                                            "marital_status": getMarriedKey(
                                                context,
                                                addTeachersFields[19]["value"]),
                                            "wives_count": addTeachersFields[20]
                                                ["value"],
                                            "children_count":
                                                addTeachersFields[21]["value"],
                                            "user[mainImage]":
                                                addTeachersFields[14]["value"]
                                                            .path ==
                                                        ''
                                                    ? null
                                                    : addTeachersFields[14]
                                                            ["value"]
                                                        ?.path,
                                            'user[id]': "",
                                            "user[status]": getStatusKey(
                                                context,
                                                addTeachersFields[13]["value"]),
                                            "user[email]": addTeachersFields[12]
                                                ["value"],
                                            "user[first_name]":
                                                addTeachersFields[3]["value"],
                                            "user[last_name]":
                                                addTeachersFields[4]["value"],
                                            "user[username]":
                                                addTeachersFields[1]["value"],
                                            'user[is_approved]': "1",
                                            "user[password]":
                                                addTeachersFields[2]["value"],
                                            "user[identity_number]":
                                                addTeachersFields[10]["value"],
                                            "user[phone]": addTeachersFields[9]
                                                ["value"],
                                            "user[gender]": getGenderKey(
                                                context,
                                                addTeachersFields[8]["value"]),
                                            "user[birth_date]":
                                                addTeachersFields[7]["value"],
                                            "user[birth_place]":
                                                addTeachersFields[11]["value"],
                                            "user[father_name]":
                                                addTeachersFields[5]["value"],
                                            "user[mother_name]":
                                                addTeachersFields[6]["value"],
                                            "user[qr_code]": "",
                                            "user[blood_type]":
                                                addTeachersFields[18]["value"],
                                            "user[note]": "",
                                            "user[current_address]":
                                                addTeachersFields[17]["value"],
                                            "user[is_has_disease]":
                                                getYesOrNoKey(
                                                    context,
                                                    addTeachersFields[22]
                                                        ["value"]),
                                            "user[disease_name]":
                                                addTeachersFields[23]["value"],
                                            "user[is_has_treatment]":
                                                getYesOrNoKey(
                                                    context,
                                                    addTeachersFields[24]
                                                        ["value"]),
                                            "user[treatment_name]":
                                                addTeachersFields[25]["value"],
                                            "user[are_there_disease_in_family]":
                                                getYesOrNoKey(
                                                    context,
                                                    addTeachersFields[26]
                                                        ["value"]),
                                            "user[family_disease_note]":
                                                addTeachersFields[27]["value"],
                                          },
                                          jsonDecode(authService.user.toUser())[
                                              "token"]);
                                      if (result["api"] == "SUCCESS") {
                                        setState(() {
                                          students.clear();
                                          page = 1;
                                          _hasNextPage = true;
                                        });
                                        getData();
                                      }
                                      return AppFunctions()
                                          .getUserErrorMessage(result, context);
                                    },
                                  ),
                                ));
                              });
                            }
                          });
                        },
                        addPage: AddPage(
                          englishTitle: "add_admins",
                          fields: addTeachersFields,
                          isEdit: false,
                          title: translate(context).add_manager,
                          onPressed: () async {
                            Map result = await ApiService().createAdmin({
                              "id": "",
                              "user_id": "",
                              "marital_status": getMarriedKey(
                                  context, addTeachersFields[19]["value"]),
                              "wives_count": addTeachersFields[20]["value"],
                              "children_count": addTeachersFields[21]["value"],
                              "user[mainImage]":
                                  addTeachersFields[14]["value"].path == ''
                                      ? null
                                      : addTeachersFields[14]["value"]?.path,
                              'user[id]': "",
                              "user[status]": getStatusKey(
                                  context, addTeachersFields[13]["value"]),
                              "user[email]": addTeachersFields[12]["value"],
                              "user[first_name]": addTeachersFields[3]["value"],
                              "user[last_name]": addTeachersFields[4]["value"],
                              "user[username]": addTeachersFields[1]["value"],
                              'user[is_approved]':
                                  jsonDecode(authService.user.toUser())[
                                                  "role"] ==
                                              "teacher" ||
                                          jsonDecode(authService.user.toUser())[
                                                  "role"] ==
                                              "branch_admin" ||
                                          jsonDecode(authService.user.toUser())[
                                                  "role"] ==
                                              "property_admin"
                                      ? "0"
                                      : "1",
                              "user[password]": addTeachersFields[2]["value"],
                              "user[identity_number]": addTeachersFields[10]
                                  ["value"],
                              "user[phone]": addTeachersFields[9]["value"],
                              "user[gender]": getGenderKey(
                                  context, addTeachersFields[8]["value"]),
                              "user[birth_date]": addTeachersFields[7]["value"],
                              "user[birth_place]": addTeachersFields[11]
                                  ["value"],
                              "user[father_name]": addTeachersFields[5]
                                  ["value"],
                              "user[mother_name]": addTeachersFields[6]
                                  ["value"],
                              "user[qr_code]": "",
                              "user[blood_type]": addTeachersFields[18]
                                  ["value"],
                              "user[note]": "",
                              "user[current_address]": addTeachersFields[17]
                                  ["value"],
                              "user[is_has_disease]": getYesOrNoKey(
                                  context, addTeachersFields[22]["value"]),
                              "user[disease_name]": addTeachersFields[23]
                                  ["value"],
                              "user[is_has_treatment]": addTeachersFields[24]
                                  ["value"],
                              "user[treatment_name]": addTeachersFields[25]
                                  ["value"],
                              "user[are_there_disease_in_family]":
                                  addTeachersFields[26]["value"],
                              "user[family_disease_note]": addTeachersFields[27]
                                  ["value"],
                            }, jsonDecode(authService.user.toUser())["token"]);

                            if (result["api"] == "SUCCESS") {
                              setState(() {
                                students.clear();
                                page = 1;
                                _hasNextPage = true;
                              });
                              getData();
                            }

                            return AppFunctions()
                                .getUserErrorMessage(result, context);
                          },
                        ),
                        list: students.asMap().entries.map((entry) {
                          return {
                            "id": entry.value["id"],
                            "image": entry.value["user"]["image"],
                            "status": getStatusValue(
                                context, entry.value["user"]["status"]),
                            "name":
                                "${entry.value["user"] == null ? translate(context).not_available : entry.value["user"]["first_name"]} ${entry.value["user"] == null ? translate(context).not_available : entry.value["user"]["last_name"]}",
                            "type": null,
                            "description":
                                '${translate(context).username} : ${entry.value["user"] == null ? translate(context).not_available : entry.value["user"]["username"]} \n ${entry.value["id"]} هو الرقم التسلسلي',
                          };
                        }).toList(),
                        tabs: getAdminTabs(context),
                        pageType: "admin",
                      ),
                    ),
                    if (_isLoadMoreRunning && students.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Helper.sizedBoxH5,
                            const CirculeProgress()
                          ],
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
