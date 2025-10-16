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
import 'package:hudayi/ui/widgets/add_Container.dart';
import 'package:hudayi/ui/widgets/helper.dart';
import 'package:hudayi/ui/widgets/list_View_Component.dart';
import 'package:hudayi/ui/widgets/page_Header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Subjects extends StatefulWidget {
  const Subjects({Key? key}) : super(key: key);

  @override
  State<Subjects> createState() => _BooksState();
}

class _BooksState extends State<Subjects> {
  final TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List subjects = [];
  bool isScolled = false;
  bool isEmpty = false;
  var authService;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  getData() {
    subjects.clear();
    ApiService().getSubjects(jsonDecode(authService.user.toUser())["token"]).then((data) {
      if (data["data"] != null) {
        setState(() {
          subjects.addAll(data["data"]);
        });
      } else {
        setState(() {
          isEmpty = true;
        });
      }
    });
  }

  @override
  void initState() {
    FirebaseAnalytics.instance.logEvent(
      name: 'subjects_page',
      parameters: {
        'screen_name': "subjects_page",
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
              title: translate(context).subjects,
              isCircle: false,
            ),
            if (isEmpty) Helper.sizedBoxH15,
            if (isEmpty)
              AddContainer(
                onTap: () {},
                text: translate(context).add_new_item,
                page: AddPage(
                  isEdit: false,
                  englishTitle: "add_subject",
                  fields: addSubjectFields,
                  title: translate(context).add_subject,
                  onPressed: () async {
                    Map result = await ApiService().addASubject(
                        {"id": null, "name": addSubjectFields[0]["value"], "description": addSubjectFields[1]["value"]},
                        jsonDecode(authService.user.toUser())["token"]);

                    if (result["api"] == "SUCCESS") {
                      setState(() {
                        subjects.insert(0, result["data"]);
                      });
                    }
                    return result["api"];
                  },
                ),
              ),
            subjects.isEmpty && isEmpty == false
                ? const CirculeProgress()
                : isEmpty == true
                    ? Center(child: Text(translate(context).no_books_available))
                    : Expanded(
                        child: ListViewComponent(
                          onRefresh: () async {
                            getData();
                          },
                          searchController: searchController,
                          controller: scrollController,
                          disableContaineronTap: (item) {},
                          addPage: AddPage(
                            englishTitle: "add_subject",
                            isEdit: false,
                            fields: addSubjectFields,
                            title: translate(context).add_subject,
                            onPressed: () async {
                              Map result = await ApiService().addASubject({
                                "id": null,
                                "name": addSubjectFields[0]["value"],
                                "description": addSubjectFields[1]["value"]
                              }, jsonDecode(authService.user.toUser())["token"]);
                              setState(() {
                                subjects.insert(0, result["data"]);
                              });
                              return result["api"];
                            },
                          ),
                          list: subjects.asMap().entries.map((entry) {
                            return {
                              "id": entry.value["id"],
                              "name": entry.value["name"] ?? translate(context).not_available,
                              "description": entry.value["description"] ?? translate(context).not_available,
                            };
                          }).toList(),
                          onEditPressed: (item, index) async {
                            addSubjectFields[0]["value"] = item["name"];
                            addSubjectFields[1]["value"] = item["description"];

                            Navigator.of(context).push(createRoute(
                              AddPage(
                                englishTitle: "edit_subject",
                                isEdit: true,
                                fields: addSubjectFields,
                                title: translate(context).edit_subject,
                                onPressed: () async {
                                  Map result = await ApiService().editSubject({
                                    "id": item["id"],
                                    "name": addSubjectFields[0]["value"],
                                    "description": addSubjectFields[1]["value"],
                                  }, jsonDecode(authService.user.toUser())["token"]);

                                  if (result["api"] == "SUCCESS") {
                                    setState(() {
                                      subjects.removeAt(index);
                                      subjects.insert(index, result["data"]);
                                    });
                                  }
                                  return result["api"];
                                },
                              ),
                            ));
                          },
                          onDeletePressed: (item, index) async {
                            showCustomDialog(context, translate(context).confirm_delete, AppConstants.appLogo, "delete", () async {
                              Map result = await ApiService().deleteSubject(item["id"], jsonDecode(authService.user.toUser())["token"]);

                              if (result["api"] == "SUCCESS") {
                                setState(() {
                                  subjects.removeAt(index);
                                });
                              }
                              return result["api"];
                            });
                          },
                          tabs: const [],
                          pageType: "book",
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
