import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/main.dart';
import 'package:hudayi/models/language_provider.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/screens/details/branch_Details.dart';
import 'package:hudayi/screens/mainPages/branches.dart';
import 'package:hudayi/screens/mainPages/login.dart';
import 'package:hudayi/screens/profiles/profile_Page.dart';
import 'package:hudayi/services/API/api.dart';
import 'package:hudayi/services/pref_utils.dart';
import 'package:hudayi/ui/helper/App_Constants.dart';
import 'package:hudayi/ui/helper/App_Consts.dart' as AppConsts;
import 'package:hudayi/ui/helper/App_Dialog.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:hudayi/ui/helper/String_Casing_Extension.dart';
import 'package:hudayi/ui/widgets/Circule_Progress.dart';
import 'package:hudayi/ui/widgets/add_Container.dart';
import 'package:hudayi/ui/widgets/animated_Header.dart';
import 'package:hudayi/ui/widgets/TextFields/search_Text_Field.dart';
import 'package:hudayi/ui/widgets/anmiation_card.dart';
import 'package:hudayi/ui/widgets/edit_and_delete.dart';
import 'package:hudayi/ui/widgets/helper.dart';
import 'package:hudayi/ui/widgets/no_Internet.dart';
import 'package:provider/provider.dart';

class Areas extends StatefulWidget {
  const Areas({Key? key}) : super(key: key);

  @override
  State<Areas> createState() => _AreasState();
}

class _AreasState extends State<Areas>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<Areas> {
  @override
  bool get wantKeepAlive => true;
  List areas = [];
  Map area = {};
  Map branch = {};
  Map class_room = {};
  final TextEditingController searchController = TextEditingController();
  ScrollController _controller = ScrollController();
  bool isScolled = false;
  bool isDone = false;
  int page = 1;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  var authService;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  getAreaData() async {
    if (authService.user.toUser() != "null" &&
        jsonDecode(authService.user.toUser())["role"] == "admin") {
      setState(() {
        _isLoadMoreRunning = true;
      });
      await ApiService()
          .getAreas(jsonDecode(authService.user.toUser())["token"], page, 15)
          .then((data) {
        if (data["data"]["data"].isEmpty) {
          setState(() {
            _hasNextPage = false;
          });
        } else {
          page += 1;
        }
        if (data != null) {
          setState(() {
            areas.addAll(data["data"]["data"]);
            PrefUtils.setAreas(jsonEncode(data["data"]));
            _isLoadMoreRunning = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  fetchData() {
    () async {
      authService = Provider.of<AuthService>(context, listen: false);
      if (authService.user.toUser() != "null" &&
          jsonDecode(authService.user.toUser())["belongs_to_id"] != null) {
        if (jsonDecode(authService.user.toUser())["role"] == "branch_admin") {
          if (isConnected == true) {
            var data = await ApiService().getArea(
                jsonDecode(authService.user.toUser())["token"],
                jsonDecode(authService.user.toUser())["belongs_to_id"]);
            setState(() {
              area.addAll(data["data"]);

              PrefUtils.setArea(jsonEncode(data["data"]));
            });
          } else {
            Map areaGrpup = jsonDecode(await PrefUtils.getArea()) ?? [];
            setState(() {
              isConnected = false;
              area.addAll(areaGrpup);
            });
          }
        }

        if (jsonDecode(authService.user.toUser())["role"] == "teacher" ||
            jsonDecode(authService.user.toUser())["role"] == "property_admin") {
          if (isConnected == true) {
            var data = await ApiService().getPropertyDetails(
                jsonDecode(authService.user.toUser())["belongs_to_id"],
                jsonDecode(authService.user.toUser())["token"]);

            setState(() {
              branch.addAll(data["data"]);

              PrefUtils.setBranch(jsonEncode(data["data"]));
            });
          } else {
            Map branchGrpup = jsonDecode(await PrefUtils.getBranch()) ?? [];
            setState(() {
              isConnected = false;
              branch.addAll(branchGrpup);
            });
          }
        }

        if (jsonDecode(authService.user.toUser())["role"] == "student") {
          if (isConnected == true) {
            var data = await ApiService().getClassGroupDetails(
                jsonDecode(authService.user.toUser())["belongs_to_id"],
                jsonDecode(authService.user.toUser())["token"]);
            setState(() {
              class_room.addAll(data["data"]);

              PrefUtils.setClassRoom(jsonEncode(data["data"]));
            });
          } else {
            Map classRoomgrpup =
                jsonDecode(await PrefUtils.getClassRoom()) ?? [];
            setState(() {
              isConnected = false;
              class_room.addAll(classRoomgrpup);
            });
          }
        }
      }

      if (isConnected == false) {
        List areaGrpup = jsonDecode(await PrefUtils.getAreas()) ?? [];
        setState(() {
          isConnected = false;
          areas.addAll(areaGrpup);
        });
        setState(() {});
      } else {
        getAreaData();
        setState(() {});
      }
    }();
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 100) {
      try {
        getAreaData();
      } catch (err) {}
    }
  }

  List addAreaFields = List.from(AppConsts.addAreaFields);
  @override
  void initState() {
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: "areas",
        parameters: {
          'screen_name': "areas",
          'screen_class': "main",
        },
      );
    }();

    fetchData();

    super.initState();

    _controller = ScrollController()
      ..addListener(() {
        if (AppFunctions().scrollListener(_controller, "slow") != null) {
          if (AppFunctions().scrollListener(_controller, "slow") != isScolled) {
            setState(() {
              isScolled = AppFunctions().scrollListener(_controller, "slow");
            });
          }
        }
        double maxScroll = _controller.position.maxScrollExtent;
        double currentScroll = _controller.position.pixels;
        double delta = 200.0;
        if (maxScroll - currentScroll <= delta) {
          if (isConnected) {
            _loadMore();
          }
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (authService.user.toUser() == "null") {
      return const Login();
    }

    final userRole = jsonDecode(authService.user.toUser())["role"];
    final belongsToId = jsonDecode(authService.user.toUser())["belongs_to_id"];

    switch (userRole) {
      case "branch_admin":
        return area.isEmpty
            ? const CirculeProgress()
            : Branches(
                area: area,
                isBack: false,
              );
      case "teacher":
      case "property_admin":
        if (belongsToId == null) {
          return Center(
            child: Text(translate(context).teacher_not_in_center),
          );
        }
        return branch.isEmpty
            ? const CirculeProgress()
            : BranchDetails(
                isActionBardisabled: userRole == "teacher",
                branch: {...branch, "area_id": branch["branch_id"]},
              );
      case "student":
        if (belongsToId == null) {
          return Center(
            child: Text(translate(context).student_not_in_center),
          );
        }
        return class_room.isEmpty
            ? const CirculeProgress()
            : ProfilePage(
                tabs: AppConsts.getSubClassTabs(context),
                isActionBardisabled: true,
                pageType: "subClass",
                profileDetails: class_room,
              );
      default:
        return _AdminView(
          areas: areas,
          area: area,
          branch: branch,
          class_room: class_room,
          searchController: searchController,
          controller: _controller,
          isScolled: isScolled,
          isDone: isDone,
          isConnected: isConnected,
          isLoadMoreRunning: _isLoadMoreRunning,
          addAreaFields: addAreaFields,
          authService: authService,
          onRefresh: () async {
            setState(() {
              page = 1;
              areas.clear();
              _hasNextPage = true;
            });
            fetchData();
          },
        );
    }
  }
}

class _AdminView extends StatelessWidget {
  const _AdminView({
    Key? key,
    required this.areas,
    required this.area,
    required this.branch,
    required this.class_room,
    required this.searchController,
    required this.controller,
    required this.isScolled,
    required this.isDone,
    required this.isConnected,
    required this.isLoadMoreRunning,
    required this.addAreaFields,
    required this.authService,
    required this.onRefresh,
  }) : super(key: key);

  final List areas;
  final Map area;
  final Map branch;
  final Map class_room;
  final TextEditingController searchController;
  final ScrollController controller;
  final bool isScolled;
  final bool isDone;
  final bool isConnected;
  final bool isLoadMoreRunning;
  final List addAreaFields;
  final authService;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: !isScolled
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: AnimatedHeader(
                  height: 110,
                  text: translate(context).regions,
                ),
                secondChild: Container()),
            Expanded(
              child: Column(
                children: [
                  if (!isConnected) const NoInternet(),
                  SearchTextField(
                    searchController: searchController,
                    title: translate(context).search_regions,
                    onChanged: (_) {
                      // setState is called in the parent
                    },
                  ),
                  if (isConnected)
                    AddContainer(
                        onTap: () {
                          addAreaFields[0]["value"] = null;
                        },
                        page: AddPage(
                          englishTitle: "add_area",
                          isEdit: false,
                          fields: addAreaFields,
                          title: translate(context).add_region,
                          onPressed: () async {
                            Map result = await ApiService().createArea({
                              "id": null,
                              "name": addAreaFields[0]["value"],
                              "organization_id": "1"
                            }, jsonDecode(authService.user.toUser())["token"]);
                            // setState is called in the parent
                            return result["api"];
                          },
                        ),
                        text: translate(context).add_region_plus),
                  areas.isEmpty && isDone == false
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CirculeProgress())
                      : areas.isEmpty
                          ? Text(translate(context).no_data_available)
                          : Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: RefreshIndicator(
                                      onRefresh: onRefresh,
                                      child: ListView(
                                        controller: controller,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        children: [
                                          for (var area in searchController
                                                      .text ==
                                                  ""
                                              ? areas
                                              : areas
                                                  .where((e) =>
                                                      e["name"].contains(searchController
                                                          .text
                                                          .toTitleCase()) ||
                                                      e["name"].contains(
                                                          searchController
                                                              .text) ||
                                                      e["name"].contains(
                                                          searchController.text
                                                              .toCapitalized()))
                                                  .toList())
                                            AnmiationCard(
                                              page: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8,
                                                    top: 4,
                                                    bottom: 4),
                                                child: GestureDetector(
                                                  onTap: authService.user
                                                              .toUser() !=
                                                          "null"
                                                      ? null
                                                      : () {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                                translate(context)
                                                                    .login_required,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        getFontName(
                                                                            context))),
                                                            duration:
                                                                const Duration(
                                                                    seconds:
                                                                        1),
                                                          ));
                                                        },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xFFF1F4F8),
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .only(
                                                              top: 8,
                                                              bottom: 8),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                              flex: 1,
                                                              child:
                                                                  Image.asset(
                                                                AppConstants
                                                                    .appLogo,
                                                                height: 70,
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                              )),
                                                          Expanded(
                                                            flex: 3,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          4.0,
                                                                      right:
                                                                          4),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          area[
                                                                              "name"],
                                                                          style: const TextStyle(
                                                                              fontSize:
                                                                                  16,
                                                                              fontWeight:
                                                                                  FontWeight.bold),
                                                                          maxLines:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                      Helper
                                                                          .sizedBoxW5,
                                                                      EditDeleteRow(
                                                                        fields:
                                                                            addAreaFields,
                                                                        onPressed:
                                                                            () async {
                                                                          Map result = await ApiService().editArea({
                                                                            "id": area["id"],
                                                                            "name": addAreaFields[0]["value"],
                                                                            "organization_id": "1" // TOD
                                                                          }, jsonDecode(authService.user.toUser())["token"]);
                                                                          // setState is called in the parent
                                                                          return result["api"];
                                                                        },
                                                                        editOnTap:
                                                                            () {
                                                                          addAreaFields[0]["value"] =
                                                                              area["name"];
                                                                        },
                                                                        editPageTitle:
                                                                            translate(context).edit_region,
                                                                        deleteOnTap:
                                                                            () {
                                                                          showCustomDialog(
                                                                              context,
                                                                              translate(context).confirm_delete,
                                                                              AppConstants.appLogo,
                                                                              "delete",
                                                                              () async {
                                                                            Map result = await ApiService().deleteArea(area["id"], jsonDecode(authService.user.toUser())["token"]);
                                                                            // setState is called in the parent
                                                                            return result["api"];
                                                                          });
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Text(translate(
                                                                          context)
                                                                      .browse_centers),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                FocusManager.instance
                                                    .primaryFocus
                                                    ?.unfocus();
                                              },
                                              displayedPage: Branches(area: area),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (isLoadMoreRunning)
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
            )
          ],
        ),
      ),
    );
  }
}
