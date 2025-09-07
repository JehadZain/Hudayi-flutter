import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/main.dart';
import 'package:hudayi/models/Languageprovider.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/screens/details/branchDetails.dart';
import 'package:hudayi/services/API/api.dart';
import 'package:hudayi/ui/helper/AppColors.dart';
import 'package:hudayi/ui/helper/AppConstants.dart';
import 'package:hudayi/ui/helper/AppConsts.dart';
import 'package:hudayi/ui/helper/AppDialog.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/helper/AppIcons.dart';
import 'package:hudayi/ui/helper/StringCasingExtension.dart';
import 'package:hudayi/ui/styles/appBoxShadow.dart';
import 'package:hudayi/ui/widgets/CirculeProgress.dart';
import 'package:hudayi/ui/widgets/addContainer.dart';
import 'package:hudayi/ui/widgets/TextFields/searchTextField.dart';
import 'package:hudayi/ui/widgets/anmiation_card.dart';
import 'package:hudayi/ui/widgets/circleImage.dart';
import 'package:hudayi/ui/widgets/dropDownBottomSheet.dart';
import 'package:hudayi/ui/widgets/edit&delete.dart';
import 'package:hudayi/ui/widgets/helper.dart';
import 'package:hudayi/ui/widgets/noInternet.dart';
import 'package:hudayi/ui/widgets/pageHeader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Branches extends StatefulWidget {
  final Map area;
  final bool? isBack;
  const Branches({Key? key, this.isBack, required this.area}) : super(key: key);

  @override
  State<Branches> createState() => _BranchesState();
}

class _BranchesState extends State<Branches> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<Branches> {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController searchController = TextEditingController();
  ScrollController _controller = ScrollController();
  List properties = [];
  bool isPropertiesNull = false;
  List admins = [];
  bool isScolled = false;
  Map user = {};
  var authService;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
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

  getArea() async {
    var data = await ApiService().getArea(jsonDecode(authService.user.toUser())["token"], widget.area["id"]);
    if (!data["data"].isEmpty) {
      setState(() {
        admins = data["data"]["branch_admins"] ?? [];
      });
      if (data["data"]["properties"].isEmpty) isPropertiesNull = true;
      return data["data"]["properties"];
    }
  }

  @override
  void initState() {
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: "properties",
        parameters: {
          'screen_name': "properties",
          'screen_class': "main",
        },
      );
      authService = Provider.of<AuthService>(context, listen: false);
      user = jsonDecode(authService.user.toUser());
      properties = await getArea();
      setState(() {});
    }();

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
      });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FadeIn(
      animate: true,
      duration: const Duration(seconds: 1),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: !isScolled ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  firstChild: PageHeader(
                    path: XFile(""),
                    title: widget.area["name"] ?? "",
                    isCircle: false,
                    isBacked: widget.isBack == false ? false : true,
                    checkedValue: "noDialog",
                  ),
                  secondChild: Container()),
              Expanded(
                child: Column(
                  children: [
                    if (isConnected)
                      Column(
                        children: [
                          const SizedBox(height: 15),
                          admins.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    deleteItem(item) async {
                                      Map result =
                                          await ApiService().deleteBranchAdmin(item["main_id"], jsonDecode(authService.user.toUser())["token"]);

                                      return result;
                                    }

                                    List group = admins.asMap().entries.map((entry) {
                                      return {
                                        "main_id": entry.value["id"],
                                        "id": entry.value["admin_id"],
                                        "user_id": entry.value["admin"]["user"] == null ? "" : entry.value["admin"]["user"]["id"],
                                        "name": entry.value["admin"]["user"] == null
                                            ? ""
                                            : '${entry.value["admin"]["user"]["first_name"]} ${entry.value["admin"]["user"]["last_name"]}',
                                        "image": entry.value["admin"]["user"] == null ? "" : entry.value["admin"]["user"]["image"],
                                        "gender": "male",
                                        "status": entry.value['deleted_at'] == null ? translate(context).active : translate(context).inactive,
                                        "branch_id": entry.value['branch_id'],
                                        "type": "branch"
                                      };
                                    }).toList();
                                    addItem(admins) async {
                                      Map result = await ApiService().addBranchAdmin({
                                        "id": null,
                                        "admin_id": admins,
                                        "branch_id": group[0]["branch_id"],
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
                                          getArea();
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
                                          "${translate(context).view_managers}(${admins.length})",
                                          style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                                        ))),
                                  ),
                                )
                              : user["role"] != "admin"
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        dropDown(context, [], true, isPagnet: true, getData: (page) async {
                                          return await getUnassignedAdmins(page);
                                        }, [], isNullable: true)
                                            .then((value) async {
                                          if (value != null) {
                                            showLoadingDialog(context);
                                            List newAdmins = value.map((item) => item.split(" - ")[1]).toList();
                                            Map result = await ApiService().addBranchAdmin({
                                              "id": null,
                                              "admin_id": newAdmins,
                                              "branch_id": widget.area["id"],
                                            }, jsonDecode(authService.user.toUser())["token"]);
                                            String status = result["api"];
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            if (status == "SUCCESS") {
                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content:
                                                    Text(translate(context).operation_success, style: TextStyle(fontFamily: getFontName(context))),
                                                duration: const Duration(milliseconds: 500),
                                              ));
                                              Future.delayed(const Duration(seconds: 1), () {
                                                Navigator.of(context).pop();
                                                getArea();
                                              });
                                            } else if (status == "FAILED") {
                                              // ignore: use_build_context_synchronously
                                              Navigator.of(context).pop();
                                              await FirebaseAnalytics.instance.logEvent(
                                                name: "an_expected_error_occured_while_adding_branch_admin_${result["hints"].toString()}",
                                                parameters: {
                                                  'screen_name': "an_expected_error_occured_while_adding_branch_admin_${result["hints"].toString()}",
                                                  'screen_class': "Adding",
                                                },
                                              );
                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content:
                                                    Text(translate(context).unexpected_error, style: TextStyle(fontFamily: getFontName(context))),
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
                                              translate(context).add_region_manager,
                                              style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                                            ))),
                                      ),
                                    ),
                        ],
                      ),
                    if (!isConnected) const NoInternet(),
                    SearchTextField(
                      searchController: searchController,
                      title: translate(context).search_centers,
                      onChanged: (_) {
                        setState((() {}));
                      },
                    ),
                    if (isConnected)
                      if (user["role"] == "admin" || user["role"] == "branch_admin")
                        AddContainer(
                            onTap: () {
                              addBranchFields[0]["value"] = null;
                            },
                            page: AddPage(
                              englishTitle: "add_property",
                              isEdit: false,
                              fields: addBranchFields,
                              title: translate(context).add_center,
                              onPressed: () async {
                                Map result = await ApiService().createProprty({
                                  "id": null,
                                  "name": addBranchFields[0]["value"],
                                  "capacity": 0,
                                  "description": addBranchFields[1]["value"],
                                  "property_type": addBranchFields[2]["value"] == translate(context).school ? "school" : "mosque",
                                  "branch_id": widget.area["id"],
                                  "phone": addBranchFields[3]["value"],
                                  "email": addBranchFields[4]["value"],
                                  "whatsapp": addBranchFields[5]["value"],
                                  "instagram": addBranchFields[6]["value"],
                                  "facebook": addBranchFields[7]["value"],
                                  "location": addBranchFields[8]["value"],
                                  "mainImage": addBranchFields[9]["value"].path == '' ? null : addBranchFields[9]["value"]?.path
                                }, jsonDecode(authService.user.toUser())["token"]);                                 
                                if (result["api"] == "SUCCESS") {
                                  setState(() {
                                    properties.insert(0, result["data"]);
                                    isPropertiesNull = false;
                                  });
                                }

                                return result["api"];
                              },
                            ),
                            text: "+${translate(context).add_center}"),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          properties = await getArea();
                          setState(() {});
                        },
                        child: Stack(
                          children: [
                            if (properties.isEmpty && !isPropertiesNull) const CirculeProgress(),
                            if (isPropertiesNull) Center(child: Text(translate(context).no_centers_available)),
                            ListView(),
                            ListView(
                              controller: _controller,
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                for (var property in searchController.text == ""
                                    ? properties
                                    : properties
                                        .where((e) =>
                                            e["name"].contains(searchController.text.toTitleCase()) ||
                                            e["name"].contains(searchController.text) ||
                                            e["name"].contains(searchController.text.toCapitalized()))
                                        .toList())
                                  AnmiationCard(
                                    page: Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 4, bottom: 4),
                                      child: GestureDetector(
                                        onTap: authService.user.toUser() != "null"
                                            ? null
                                            : () {
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  content:
                                                      Text(translate(context).login_required, style: TextStyle(fontFamily: getFontName(context))),
                                                  duration: const Duration(seconds: 1),
                                                ));
                                              },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: const Color(0xFFF1F4F8),
                                              width: 2,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.only(top: 8, bottom: 8),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: CircleImage(
                                                        image: property["image"] != null
                                                            ? AppFunctions().getImage(property["image"])
                                                            : AppIcons.branchAvatr,
                                                        radius: 38)),
                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 4.0, right: 4),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                property["name"],
                                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                            Helper.sizedBoxW5,
                                                            if (user["role"] == "admin" || user["role"] == "branch_admin")
                                                              EditDeleteRow(
                                                                  fields: const [],
                                                                  editOnTap: () async {
                                                                    showLoadingDialog(context);
                                                                    await AppFunctions.getImageXFileByUrl(AppFunctions().getImage(property["image"]))
                                                                        .then((value) {
                                                                      addBranchFields[0]["value"] = property["name"];
                                                                      addBranchFields[1]["value"] = property["description"];
                                                                      addBranchFields[2]["value"] = property["property_type"] == "school"
                                                                          ? translate(context).school
                                                                          : translate(context).university;
                                                                      addBranchFields[3]["value"] = property["phone"];
                                                                      addBranchFields[4]["value"] = property["email"];
                                                                      addBranchFields[5]["value"] = property["whatsapp"];
                                                                      addBranchFields[6]["value"] = property["instagram"];
                                                                      addBranchFields[7]["value"] = property["facebook"];
                                                                      addBranchFields[8]["value"] = property["location"];
                                                                      addBranchFields[9]["value"] = value;
                                                                      Navigator.of(context).pop();
                                                                      Navigator.of(context).push(createRoute(
                                                                        AddPage(
                                                                          englishTitle: "edit_property",
                                                                          isEdit: true,
                                                                          fields: addBranchFields,
                                                                          title: translate(context).edit_center,
                                                                          onPressed: () async {
                                                                            Map result = await ApiService().editProprty({
                                                                              "id": property["id"],
                                                                              "name": addBranchFields[0]["value"],
                                                                              "capacity": 0,
                                                                              "description": addBranchFields[1]["value"],
                                                                              "property_type":
                                                                                  addBranchFields[2]["value"] == translate(context).school
                                                                                      ? "school"
                                                                                      : "mosque",
                                                                              "branch_id": widget.area["id"],
                                                                              "phone": addBranchFields[3]["value"],
                                                                              "email": addBranchFields[4]["value"],
                                                                              "whatsapp": addBranchFields[5]["value"],
                                                                              "instagram": addBranchFields[6]["value"],
                                                                              "facebook": addBranchFields[7]["value"],
                                                                              "location": addBranchFields[8]["value"],
                                                                              "mainImage": addBranchFields[9]["value"].path == ''
                                                                                  ? null
                                                                                  : addBranchFields[9]["value"]?.path
                                                                            }, jsonDecode(authService.user.toUser())["token"]);
                                                                            if (result["api"] == "SUCCESS") {
                                                                              setState(() {
                                                                                properties.insert(properties.indexOf(property), result["data"]);
                                                                                properties.removeAt(properties.indexOf(property));
                                                                              });
                                                                            }
                                                                            return result["api"];
                                                                          },
                                                                        ),
                                                                      ));
                                                                    });
                                                                  },
                                                                  editPageTitle: translate(context).edit_center,
                                                                  deleteOnTap: () {
                                                                    showCustomDialog(
                                                                        context, translate(context).confirm_delete, AppConstants.appLogo, "delete",
                                                                        () async {
                                                                      Map result = await ApiService().deleteProperty(
                                                                          property["id"], jsonDecode(authService.user.toUser())["token"]);
                                                                      if (result["api"] == "SUCCESS") {
                                                                        setState(() {
                                                                          properties.removeWhere((element) => element["id"] == property["id"]);
                                                                          if (properties.isEmpty) isPropertiesNull = true;
                                                                        });
                                                                      }
                                                                      return result["api"];
                                                                    });
                                                                  }),
                                                          ],
                                                        ),
                                                        Text(property["description"] ?? ""),
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
                                      FocusManager.instance.primaryFocus?.unfocus();
                                    },
                                    displayedPage: BranchDetails(branch: {...property, "area_id": widget.area["id"]}),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
