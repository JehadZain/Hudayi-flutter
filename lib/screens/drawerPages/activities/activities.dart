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
import 'package:hudayi/ui/widgets/list_View_Component.dart';
import 'package:hudayi/ui/widgets/page_Header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Activites extends StatefulWidget {
  const Activites({Key? key}) : super(key: key);

  @override
  State<Activites> createState() => _ActivitesState();
}

class _ActivitesState extends State<Activites> {
  final TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List activityTypes = [];
  bool isScolled = false;
  var authService;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  getData() {
    activityTypes.clear();
    ApiService().getActivityTypes(jsonDecode(authService.user.toUser())["token"]).then((data) {
      if (data != null) {
        setState(() {
          activityTypes.addAll(data["data"]["data"]);
        });
      }
    });
  }

  @override
  void initState() {
    FirebaseAnalytics.instance.logEvent(
      name: 'activities_type_page',
      parameters: {
        'screen_name': "activities_type_page",
        'screen_class': "profile",
      },
    );
    authService = Provider.of<AuthService>(context, listen: false);
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(
              checkedValue: "noDialog",
              path: XFile(" "),
              title: translate(context).types_of_activities,
              isCircle: false,
            ),
            Expanded(
              child: ListViewComponent(
                onRefresh: () async {
                  getData();
                },
                searchController: searchController,
                controller: scrollController,
                disableContaineronTap: (item) {},
                addPage: AddPage(
                  isEdit: false,
                  fields: addActivtyType,
                  englishTitle: "add_subject_type",
                  title: translate(context).add_activity_type,
                  onPressed: () async {
                    Map result = await ApiService().createActivityType({
                      "id": null,
                      "name": addActivtyType[0]["value"],
                      "goal": addActivtyType[2]["value"],
                      "description": addActivtyType[1]["value"],
                    }, jsonDecode(authService.user.toUser())["token"]);
                    setState(() {
                      activityTypes.insert(0, result["data"]);
                    });
                    return result["api"];
                  },
                ),
                list: activityTypes.asMap().entries.map((entry) {
                  return {
                    "id": entry.value["id"],
                    "name": entry.value["name"] ?? translate(context).not_available,
                    "type": entry.value["goal"].toString().length >= 12
                        ? entry.value["goal"].toString().substring(0, 11)
                        : entry.value["goal"] ?? translate(context).not_available,
                    "description": entry.value["description"] ?? translate(context).not_available,
                    "date": entry.value["start_at"] ?? "",
                  };
                }).toList(),
                onEditPressed: (item, index) async {
                addActivtyType[0]["value"] = item["name"];
                addActivtyType[1]["value"] = item["description"];
                addActivtyType[2]["value"] = item["type"];
                  Navigator.of(context).push(createRoute(
                    AddPage(
                      isEdit: true,
                      fields: addActivtyType ,
                      englishTitle: "edit_subject_type",
                      title: translate(context).edit_activity_type,
                      onPressed: () async {
                        Map result = await ApiService().editActivityType({
                          "id": item["id"],
                          "name": addActivtyType[0]["value"],
                          "goal": addActivtyType[2]["value"],
                          "description": addActivtyType[1]["value"],
                        }, jsonDecode(authService.user.toUser())["token"]);
                        if (result["api"] == "SUCCESS") {
                          setState(() {
                            activityTypes.removeAt(index);
                            activityTypes.insert(index, result["data"]);
                          });
                        }
                        return result["api"];
                      },
                    ),
                  ));
                },
                onDeletePressed: (item, index) async {
                  showCustomDialog(context, translate(context).confirm_delete, AppConstants.appLogo, "delete", () async {
                    Map result = await ApiService().deleteActivityType(item["id"], jsonDecode(authService.user.toUser())["token"]);

                    if (result["api"] == "SUCCESS") {
                      setState(() {
                        activityTypes.removeAt(index);
                      });
                    }
                    return result["api"];
                  });
                },
                tabs: const [],
                pageType: "activityTypes",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
