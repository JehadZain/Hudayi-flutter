import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/services/API/api.dart';
import 'package:hudayi/ui/helper/App_Colors.dart';
import 'package:hudayi/ui/helper/App_Consts.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:hudayi/ui/widgets/Circule_Progress.dart';
import 'package:hudayi/ui/widgets/list_View_Component.dart';
import 'package:hudayi/ui/widgets/no_Data.dart';
import 'package:provider/provider.dart';

class Admin extends StatefulWidget {
  final TextEditingController searchController;
  final ScrollController scrollController;
  final TabController tabController;
  final Map details;
  const Admin({Key? key, required this.searchController, required this.scrollController, required this.tabController, required this.details})
      : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  List viewTeacherFields = [];
  int tabIndex = 0;
  Map teacher = {};
  List rates = [];
  var authService;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  getData() {
    ApiService().getAdminDetails(widget.details["id"], jsonDecode(authService.user.toUser())["token"]).then((data) {
      if (data != null) {
        setState(() {
          teacher.addAll(data["data"]);
          rates = data["data"]["user"]["rates"];
        });
        viewTeacherFields = [];
        viewTeacherFields.addAll([
          {"type": "text", "value": teacher["user"]["id"].toString(), "title": translate(context).serial_number},
          {
            "type": "text",
            "value": "${teacher["user"]["user"]["first_name"]} ${teacher["user"]["user"]["last_name"]}",
            "title": translate(context).first_name_last_name
          },
          {"type": "text", "value": teacher["user"]["user"]["father_name"], "title": translate(context).father_name},
          {"type": "text", "value": teacher["user"]["user"]["mother_name"], "title": translate(context).mother_name},
          {"type": "date", "value": teacher["user"]["user"]["birth_date"]?.split("T")[0], "title": translate(context).date_of_birth},
          {
            "type": "oneSelection",
            "value": getGenderValue(context, teacher["user"]["user"]["gender"]),
            "title": translate(context).gender,
            "selections": [translate(context).female, translate(context).male]
          },
          {"type": "number", "value": teacher["user"]["user"]["phone"], "title": translate(context).personal_phone_number},
          {"type": "number", "value": teacher["user"]["user"]["identity_number"], "title": translate(context).national_id_number},
          {"type": "text", "value": teacher["user"]["user"]["email"] ?? translate(context).not_available, "title": translate(context).email_address},
          {"type": "text", "value": teacher["user"]["user"]["birth_place"], "title": translate(context).place_of_birth},
          {
            "type": "oneSelection",
            "value": getStatusValue(context, teacher["user"]["user"]["status"]),
            "title": translate(context).manager_status,
            "selections": [translate(context).inactive, translate(context).active]
          },
          {
            "type": "oneSelection",
            "value": teacher.isEmpty
                ? translate(context).not_available
                : teacher["role"] != null
                    ? teacher["role"] == "org_admin"
                        ? translate(context).organization_manager
                        : teacher["role"] == "property_admin"
                            ? translate(context).center_manager
                            : teacher["role"] == "branch_admin"
                                ? translate(context).region_manager
                                : translate(context).general_manager
                    : translate(context).not_available,
            "title": translate(context).manager_type,
            "selections": [translate(context).first_grade]
          },
          {
            "type": "oneSelection",
            "value": teacher.isEmpty
                ? translate(context).not_available
                : teacher["Belongs_to"] != null
                    ? teacher["Belongs_to"]["property_name"] ?? translate(context).not_available
                    : translate(context).not_available,
            "title": translate(context).center_name,
            "selections": [translate(context).first_grade]
          },
          {
            "type": "oneSelection",
            "value": teacher.isEmpty
                ? translate(context).not_available
                : teacher["Belongs_to"] != null
                    ? teacher["Belongs_to"]["branch_name"] ?? translate(context).not_available
                    : translate(context).not_available,
            "title": translate(context).region_name,
            "selections": [translate(context).first_grade]
          },
          {"type": "flutterText", "title": translate(context).private_account_information},
          {
            "type": "text",
            "value": teacher["user"]["current_address"] ?? teacher["user"]["user"]["current_address"] ?? translate(context).not_available,
            "title": translate(context).current_residence
          },
          {
            "type": "oneSelection",
            "value": teacher["user"]["user"]["blood_type"],
            "title": translate(context).blood_type,
            "selections": ["A+", "A-", "B+", "B-", "O+", "O-", "-AB", "+AB"]
          },
          {
            "type": "oneSelection",
            "value": getMarriedValue(context, teacher['user']?["marital_status"]??""),
            "title": translate(context).marital_status,
            "selections": [translate(context).no, translate(context).yes]
          },
          {
            "type": "number",
            "value": teacher['user']["wives_count"] == "null" ? "0" : teacher['user']["wives_count"],
            "title": translate(context).number_of_wives
          },
          {"type": "number", "value": teacher['user']["children_count"], "title": translate(context).number_of_children},
          {
            "type": "oneSelection",
            "value": getYesOrNoValue(context, teacher["user"]["user"]["is_has_disease"]),
            "title": translate(context).chronic_illness,
            "selections": [translate(context).no, translate(context).yes]
          },
          {
            "type": "text",
            "value": teacher["user"]["user"]["disease_name"] == "null" ? "" : teacher["user"]["user"]["disease_name"],
            "title": translate(context).illness_name
          },
          {
            "type": "oneSelection",
            "value": getYesOrNoValue(context, teacher["user"]["user"]["is_has_treatment"]),
            "title": translate(context).treatment_available,
            "selections": [translate(context).no, translate(context).yes]
          },
          {
            "type": "text",
            "value": teacher["user"]["user"]["treatment_name"] == "null" ? "" : teacher["user"]["user"]["treatment_name"],
            "title": translate(context).treatment_name
          },
          {
            "type": "oneSelection",
            "value": getYesOrNoValue(context, teacher["user"]["user"]["are_there_disease_in_family"]),
            "title": translate(context).chronic_illness_home,
            "selections": [translate(context).no, translate(context).yes]
          },
          {
            "type": "text",
            "value": teacher["user"]["user"]["family_disease_note"] == "null" ? "" : teacher["user"]["user"]["family_disease_note"],
            "title": translate(context).illness_name
          },
        ]);
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    FirebaseAnalytics.instance.logEvent(
      name: 'admin_profile_page',
      parameters: {
        'screen_name': "admin_profile_page",
        'screen_class': "profile",
      },
    );

    authService = Provider.of<AuthService>(context, listen: false);
    getData();
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
        child: teacher.isEmpty
            ? const CirculeProgress()
            : TabBarView(physics: const BouncingScrollPhysics(), controller: widget.tabController, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8, top: 12, bottom: 4),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (jsonDecode(authService.user.toUser())["role"] == "admin")
                            GestureDetector(
                              onTap: () async {
                                showLoadingDialog(context);

                                await ApiService()
                                    .getAdminDetails(teacher["user"]["id"], jsonDecode(authService.user.toUser())["token"])
                                    .then((data) async {
                                  if (data != null && data["data"] != null) {
                                    await AppFunctions.getImageXFileByUrl(AppFunctions().getImage(data["data"]["user"]["user"]["image"]))
                                        .then((value) {
                                      addTeachersFields[14]["value"] = value;
                                      addTeachersFields[1]["value"] = data["data"]["user"]["user"]["username"];
                                      addTeachersFields[2]["value"] = data["data"]["user"]["user"]["password"];
                                      addTeachersFields[3]["value"] = data["data"]["user"]["user"]["first_name"];
                                      addTeachersFields[4]["value"] = data["data"]["user"]["user"]["last_name"];
                                      addTeachersFields[5]["value"] = data["data"]["user"]["user"]["father_name"];
                                      addTeachersFields[6]["value"] = data["data"]["user"]["user"]["mother_name"];
                                      addTeachersFields[7]["value"] = data["data"]["user"]["user"]["birth_date"]?.split("T")[0];
                                      addTeachersFields[8]["value"] = getGenderValue(context, data["data"]["user"]["user"]["gender"]);
                                      addTeachersFields[9]["value"] = data["data"]["user"]["user"]["phone"];
                                      addTeachersFields[10]["value"] = data["data"]["user"]["user"]["identity_number"];
                                      addTeachersFields[11]["value"] = data["data"]["user"]["user"]["birth_place"];
                                      addTeachersFields[12]["value"] = data["data"]["user"]["user"]["email"];
                                      addTeachersFields[13]["value"] = getStatusValue(context, data["data"]["user"]["user"]["status"]);
                                      addTeachersFields[17]["value"] = data["data"]["user"]["user"]["current_address"];
                                      addTeachersFields[18]["value"] = data["data"]["user"]["user"]["blood_type"];
                                      addTeachersFields[19]["value"] = getMarriedValue(context, data["data"]["user"]?["marital_status"]??"");
                                      addTeachersFields[20]["value"] =
                                          data["data"]["user"]["wives_count"] == "null" ? "0" : data["data"]["user"]["wives_count"];
                                      addTeachersFields[21]["value"] = data["data"]["user"]["children_count"];
                                      addTeachersFields[22]["value"] = getYesOrNoValue(context, data["data"]["user"]['user']["is_has_disease"]);
                                      addTeachersFields[23]["value"] =
                                          data["data"]["user"]['user']["disease_name"] == "null" ? "" : data["data"]["user"]["user"]["disease_name"];
                                      addTeachersFields[24]["value"] = getYesOrNoValue(context, data["data"]["user"]['user']["is_has_treatment"]);
                                      addTeachersFields[25]["value"] = data["data"]["user"]['user']["treatment_name"] == "null"
                                          ? ""
                                          : data["data"]["user"]["user"]["treatment_name"];
                                      addTeachersFields[26]["value"] =
                                          getYesOrNoValue(context, data["data"]["user"]['user']["are_there_disease_in_family"]);
                                      addTeachersFields[27]["value"] = data["data"]["user"]['user']["family_disease_note"] == "null"
                                          ? ""
                                          : data["data"]["user"]["user"]["family_disease_note"];

                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(createRoute(
                                        AddPage(
                                          englishTitle: "edit_admins",
                                          isEdit: true,
                                          fields: addTeachersFields,
                                          title: translate(context).edit_manager,
                                          onPressed: () async {
                                            Map result = await ApiService().editAdmin({
                                              "id": teacher["user"]["id"],
                                              "user_id": teacher["user"]["user_id"],
                                              "marital_status": getMarriedKey(context, addTeachersFields[19]["value"]),
                                              "wives_count": addTeachersFields[20]["value"],
                                              "children_count": addTeachersFields[21]["value"],
                                              "user[mainImage]": addTeachersFields[14]["value"].path == '' ? null : addTeachersFields[14]["value"]?.path,
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
                                            }, jsonDecode(authService.user.toUser())["token"]);

                                            if (result["api"] == "SUCCESS") {
                                              getData();
                                            }
                                            return AppFunctions().getUserErrorMessage(result, context);
                                          },
                                        ),
                                      ));
                                    });
                                  }
                                });
                              },
                              child: const CircleAvatar(
                                backgroundColor: AppColors.primary,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          const SizedBox(width: 10),
                          Text(
                            translate(context).account_information,
                            style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TextFieldFor(
                            fields: viewTeacherFields,
                            deleteOnTap: () {},
                            galleryOnTap: () {},
                            cameraOnTap: () {},
                            scrollController: tabIndex == 0 ? widget.scrollController : ScrollController(),
                            readOnly: true),
                      ),
                    ],
                  ),
                ),
               rates.isEmpty? const NoData() : ListViewComponent(
                  permmission: true,
                  isAdding: false,
                  onRefresh: () async {},
                  searchController: widget.searchController,
                  controller: tabIndex == 3 ? widget.scrollController : ScrollController(),
                  tabs: const [],
                  list: rates.asMap().entries.map((entry) {
                    return {
                      "id": entry.value["id"] ?? "",
                      "name":
                          "${translate(context).resident_teacher_name_id}\n ${entry.value["teacher"] != null ? entry.value["teacher"]["user"] != null ? "${entry.value["teacher"]["user"]["first_name"] ?? ""} ${entry.value["teacher"]["user"]["last_name"] ?? ""} - ${entry.value["teacher"]["id"]}" : "" : ""}",
                      "description":
                          "${translate(context).total_evaluation}${entry.value["score"] ?? ""} ${translate(context).from} ${double.parse(entry.value["percentage"] ?? "").toStringAsFixed(2)} ${translate(context).added_on}${entry.value["date"] ?? ""} ${translate(context).from_time}${entry.value["start_date"] ?? ""} ${translate(context).to}${entry.value["end_date"] ?? ""}",
                      "type": entry.value["student_count"] ?? translate(context).not_available,
                      "date": "${entry.value["date"] ?? ""}",
                      "student_id": entry.value["teacher"]["id"],
                      "teacher_id": entry.value["teacher_id"],
                      "admin": teacher['user'],
                      "teacher": entry.value["teacher"]["user"],
                      "admin_id": entry.value["admin_id"],
                      "date_1": entry.value["date"],
                      "start_date": entry.value["start_date"],
                      "end_date": entry.value["end_date"],
                      "correct_reading_skill": entry.value["correct_reading_skill"],
                      "teaching_skill": entry.value["teaching_skill"],
                      "academic_skill": entry.value["academic_skill"],
                      "following_skill": entry.value["following_skill"],
                      "plan_commitment": entry.value["plan_commitment"],
                      "time_commitment": entry.value["time_commitment"],
                      "student_commitment": entry.value["student_commitment"],
                      "activity": entry.value["activity"],
                      "commitment_to_administrative_instructions": entry.value["commitment_to_administrative_instructions"],
                      "exam_and_quizzes": entry.value["exam_and_quizzes"],
                      "percentage": entry.value["percentage"],
                      "score": entry.value["score"],
                      "note": entry.value["note"],
                      "student_count": entry.value["student_count"],
                    };
                  }).toList(),
                  pageType: 'rate',
                ),
              ]));
  }
}
