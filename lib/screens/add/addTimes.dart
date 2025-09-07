import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/models/Languageprovider.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/services/API/api.dart';
import 'package:hudayi/ui/helper/AppColors.dart';
import 'package:hudayi/ui/helper/AppConstants.dart';
import 'package:hudayi/ui/helper/AppDialog.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/widgets/TextFields/DatePickerField.dart';
import 'package:hudayi/ui/widgets/TextFields/OneSelectionField.dart';
import 'package:hudayi/ui/widgets/accordion.dart';
import 'package:hudayi/ui/widgets/drawer.dart';
import 'package:hudayi/ui/widgets/dropDownBottomSheet.dart';
import 'package:hudayi/ui/widgets/helper.dart';
import 'package:hudayi/ui/widgets/pageHeader.dart';
import 'package:hudayi/ui/widgets/saveButton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';

class AddTimesPage extends StatefulWidget {
  final Function(dynamic)? onPressed;
  final Map? time;
  final List books;
  const AddTimesPage({Key? key, this.onPressed, this.time, required this.books}) : super(key: key);

  @override
  State<AddTimesPage> createState() => _AddTimesPageState();
}

final _selectedDayController = TextEditingController();
final _selectedSubjectController = TextEditingController();
final _selectedStartTimeController = TextEditingController();
final _selectedEndTimeController = TextEditingController();

String idGenerator() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}

class _AddTimesPageState extends State<AddTimesPage> {
  var authService;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  List times = [];
  late List selectedDays;

  String removeLastComma(String input) {
    // Find the last comma in the string
    int lastCommaIndex = input.lastIndexOf(',');

    // If there's no comma in the string, no need to remove anything
    if (lastCommaIndex != -1) {
      // Remove the last comma
      input = input.substring(0, lastCommaIndex) + input.substring(lastCommaIndex + 1);
    }

    return input;
  }

  @override
  void initState() {
    FirebaseAnalytics.instance.logEvent(
      name: "add_calender_page",
      parameters: {
        'screen_name': "add_calender_page",
        'screen_class': "Adding",
      },
    );
    authService = Provider.of<AuthService>(context, listen: false);
    times.add({
      "id": widget.time == null ? "firstItem" : widget.time!["id"] ?? "firstItem",
      "day": widget.time == null ? "" : widget.time!["day"] ?? "",
      "startTime": widget.time == null ? "" : widget.time!["startTime"] ?? "",
      "endTime": widget.time == null ? "" : widget.time!["endTime"] ?? "",
      "subject": widget.time == null ? "" : widget.time!["subject"] ?? "",
      "isOpen": true
    });
    selectedDays = [];
    if (widget.time == null) {
      _selectedDayController.clear();
      _selectedSubjectController.clear();
      _selectedStartTimeController.clear();
      _selectedEndTimeController.clear();
    } else {
      _selectedDayController.text = widget.time!["day"];
      _selectedSubjectController.text = widget.time!["subject"];
      _selectedStartTimeController.text = widget.time!["startTime"];
      _selectedEndTimeController.text = widget.time!["endTime"];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_selectedDayController.text != "") {
          showCustomDialog(context, translate(context).question_exist_page, AppConstants.appLogo, "exit", () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
          return Future.value(true);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        drawer: const DrawerWidget(),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                PageHeader(
                  checkedValue: _selectedDayController.text == "" ? null : "",
                  path: XFile(" "),
                  title: translate(context).program_schedule,
                  isCircle: false,
                ),
                Column(
                  children: [
                    for (var time in times)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 20, bottom: 0),
                        child: GestureDetector(
                          child: Accordion(
                            showContent: time["isOpen"],
                            disableClick: false,
                            title: Container(
                              height: 81,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 5,
                                      color: Color(0x44111417),
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(14)),
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        if (widget.time == null)
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(Icons.delete),
                                            color: Colors.white,
                                            onPressed: () {
                                              if (times.length != 1) {
                                                setState(() {
                                                  times.removeWhere((element) => element["id"] == time["id"]);
                                                });
                                              }
                                            },
                                          ),
                                        Text(
                                          translate(context).schedule_details_section,
                                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    if (widget.time == null)
                                      GestureDetector(
                                        child: const Icon(
                                          Icons.add,
                                          size: 27,
                                          color: Colors.white,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            times.add(
                                                {"id": idGenerator(), "day": "", "startTime": "", "endTime": "", "subject": "", "isOpen": false});
                                          });
                                        },
                                      )
                                  ],
                                ),
                              ),
                            ),
                            content: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 2,
                                    color: Colors.grey,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 81,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 5,
                                            color: Color(0x44111417),
                                            offset: Offset(0, 2),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(14)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              if (widget.time == null)
                                                IconButton(
                                                  padding: EdgeInsets.zero,
                                                  icon: const Icon(Icons.delete),
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    if (times.length != 1) {
                                                      setState(() {
                                                        times.removeWhere((element) => element["id"] == time["id"]);
                                                      });
                                                    }
                                                  },
                                                ),
                                              Text(
                                                translate(context).schedule_details_section,
                                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          if (widget.time == null)
                                            GestureDetector(
                                              child: const Icon(
                                                Icons.add,
                                                size: 27,
                                                color: Colors.white,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  times.add({
                                                    "id": idGenerator(),
                                                    "day": "",
                                                    "startTime": "",
                                                    "endTime": "",
                                                    "subject": "",
                                                    "isOpen": false
                                                  });
                                                });
                                              },
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                                    child: Column(
                                      children: [
                                        OneSelectionField(
                                          title: translate(context).today,
                                          readOnly: false,
                                          isRequired: true,
                                          controller: _selectedDayController,
                                          onTap: () {
                                            dropDown(
                                                    context,
                                                    [
                                                      translate(context).week_days,
                                                      translate(context).week_days2,
                                                      translate(context).week_days3,
                                                      translate(context).week_days4,
                                                      translate(context).week_days5,
                                                      translate(context).week_days6,
                                                      translate(context).week_days7
                                                    ],
                                                    true,
                                                    time["day"]?.split(", ") ?? [])
                                                .then((value) {
                                              if (value != null) {
                                                time["day"] = removeLastComma(value.join(", "));
                                                _selectedDayController.text = value.join(", ");
                                              }
                                            });
                                          },
                                        ),
                                        OneSelectionField(
                                          title: translate(context).book,
                                          isRequired: true,
                                          readOnly: false,
                                          controller: _selectedSubjectController,
                                          onTap: () {
                                            dropDown(
                                                    context,
                                                    widget.books.map((e) => '${e["name"] ?? ""}').toList(),
                                                    false,
                                                    isPagnet: false,
                                                    [],
                                                    isNullable: true)
                                                .then((value) async {
                                              if (value != null) {
                                                time["subject"] = value;
                                                _selectedSubjectController.text = value;
                                              }
                                            });
                                          },
                                        ),
                                        DatePickerField(
                                          title: translate(context).start_time,
                                          readOnly: false,
                                          controller: _selectedStartTimeController,
                                          onTap: () {
                                            selectTime(context).then((value) {
                                              if (value != null) {
                                                setState(() {
                                                  _selectedStartTimeController.text = value;
                                                  time["startTime"] = value;
                                                });
                                              }
                                            });
                                          },
                                        ),
                                        DatePickerField(
                                          title: translate(context).end_time,
                                          readOnly: false,
                                          controller: _selectedEndTimeController,
                                          onTap: () {
                                            selectTime(context).then((value) {
                                              if (value != null) {
                                                setState(() {
                                                  _selectedEndTimeController.text = value;
                                                  time["endTime"] = value;
                                                });
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            for (var i = 0; i < times.length; i++) {
                              if (time != times[i]) {
                                times[i]["isOpen"] = false;
                              }
                            }
                            setState(() {
                              if (time["day"] != "") {
                                setState(() {
                                  selectedDays.clear();
                                  selectedDays.add(time["day"]);
                                });
                              } else {
                                setState(() {
                                  selectedDays.clear();
                                });
                              }
                              _selectedDayController.text = time["day"];
                              _selectedSubjectController.text = time["subject"];
                              _selectedStartTimeController.text = time["startTime"];
                              _selectedEndTimeController.text = time["endTime"];
                              time["isOpen"] = !time["isOpen"];
                            });
                          },
                        ),
                      ),
                  ],
                ),
                Helper.sizedBoxH10,
                SaveButton(onPressed: () async {
                  if (widget.onPressed != null) {
                    // ignore: use_build_context_synchronously
                    showLoadingDialog(context);
                    String status = await widget.onPressed!(times);

                    FocusManager.instance.primaryFocus?.unfocus();
                    if (status == "SUCCESS") {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(translate(context).operation_successfully, style: TextStyle(fontFamily: getFontName(context))),
                        duration: const Duration(milliseconds: 500),
                      ));
                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.of(context).pop();
                      });
                    } else if (status == "FAILED") {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                      await FirebaseAnalytics.instance.logEvent(
                        name: "an_expected_error_occured_while_adding_or_editnig_in_add_times_$status",
                        parameters: {
                          'screen_name': "an_expected_error_occured_while_adding_or_adding_in_add_times_$status",
                          'screen_class': "Adding",
                        },
                      );
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(translate(context).unexpected_error, style: TextStyle(fontFamily: getFontName(context))),
                        duration: const Duration(milliseconds: 500),
                      ));
                    }
                    Future.delayed(const Duration(milliseconds: 850), () {
                      Navigator.of(context).pop();
                    });
                    {}
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
