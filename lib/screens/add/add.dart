import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/main.dart';
import 'package:hudayi/models/Languageprovider.dart';
import 'package:hudayi/ui/helper/AppColors.dart';
import 'package:hudayi/ui/helper/AppConstants.dart';
import 'package:hudayi/ui/helper/AppDialog.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/widgets/TextFields/DatePickerField.dart';
import 'package:hudayi/ui/widgets/TextFields/DescriptiontextField.dart';
import 'package:hudayi/ui/widgets/TextFields/OneSelectionField.dart';
import 'package:hudayi/ui/widgets/TextFields/NumberTextField.dart';
import 'package:hudayi/ui/widgets/TextFields/StringTextField.dart';
import 'package:hudayi/ui/widgets/TextFields/phoneTextField.dart';
import 'package:hudayi/ui/widgets/drawer.dart';
import 'package:hudayi/ui/widgets/dropDownBottomSheet.dart';
import 'package:hudayi/ui/widgets/pageHeader.dart';
import 'package:hudayi/ui/widgets/pickers/imagePicker.dart';
import 'package:hudayi/ui/widgets/saveButton.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AddPage extends StatefulWidget {
  final List fields;
  final String title;
  final String englishTitle;
  final bool isEdit;
  final bool? isAcceptence;
  final Function()? onPressed;
  final Function()? acceptPressed;
  final Function()? rejectPressed;
  const AddPage(
      {super.key,
      required this.fields,
      required this.isEdit,
      required this.englishTitle,
      required this.title,
      this.onPressed,
      this.isAcceptence,
      this.acceptPressed,
      this.rejectPressed});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> with AutomaticKeepAliveClientMixin<AddPage> {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  cameraOnTap(index) async {
    try {
      ImagePicker().pickImage(imageQuality: 40, source: ImageSource.camera).then((value) async {
        int maxSizeInBytes = 2 * 1024 * 1024; // 2MB
        int fileLength = await value!.length();
        if (fileLength <= maxSizeInBytes) {
          ImageCropper().cropImage(
            sourcePath: value.path,
            compressFormat: ImageCompressFormat.jpg,
            compressQuality: 40,
            uiSettings: [
              AndroidUiSettings(
                  toolbarTitle: 'Cropper',
                  toolbarColor: AppColors.primary,
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false),
              IOSUiSettings(
                title: 'Cropper',
              ),
            ],
          ).then((value) {
            widget.fields[index]["value"] = XFile(value!.path);
            setState(() {});
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.primary,
            content: Text(translate(context).image_size_exceeded, style: TextStyle(fontFamily: getFontName(context), color: Colors.white)),
          ));
        }
      });
    } catch (e) {}
  }

  deleteOnTap(index) {
    widget.fields[index]["value"] = XFile("");
    setState(() {});
  }

  galleryOnTap(index) async {
    try {
      ImagePicker().pickImage(imageQuality: 40, source: ImageSource.gallery).then((value) async {
        int maxSizeInBytes = 2 * 1024 * 1024; // 2MB
        int fileLength = await value!.length();
        if (fileLength <= maxSizeInBytes) {
          ImageCropper().cropImage(
            sourcePath: value.path,
            compressFormat: ImageCompressFormat.jpg,
            compressQuality: 40,
            uiSettings: [
              AndroidUiSettings(
                  toolbarTitle: 'Cropper',
                  toolbarColor: AppColors.primary,
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false),
              IOSUiSettings(
                title: 'Cropper',
              ),
            ],
          ).then((value) {
            widget.fields[index]["value"] = XFile(value!.path);
            setState(() {});
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.primary,
            content: Text(translate(context).image_size_exceeded_message, style: TextStyle(fontFamily: getFontName(context), color: Colors.white)),
          ));
        }
      });
    } catch (e) {}
  }

  @override
  void initState() {
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: "add_${widget.englishTitle}_page",
        parameters: {
          'screen_name': "add_${widget.englishTitle}_page",
          'screen_class': "Adding",
        },
      );
    }();
    if (widget.isEdit == false) {
      setState(() {
        for (Map field in widget.fields) {
          if (field["value"].toString() == "Instance of 'XFile'") {
            field["value"] = XFile("");
          } else if (field["value"].toString() == "[Instance of 'XFile']") {
            field["value"] = [XFile("")];
          } else {
            if (field["type"] != "flutterText" && field["type"] != "image") {
              if (field["multiple"] == false) {
                field["value"] = XFile("");
              } else {
                field["value"] = null;
              }
            }
          }
        }
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.isAcceptence == true) {
          return Future.value(true);
        } else if (widget.fields[0]["value"] != null) {
          showCustomDialog(context, translate(context).leave_page_confirmation, AppConstants.appLogo, "exit", () {
            try {
              setState(() {
                for (Map field in widget.fields) {
                  if (field["value"].toString() == "Instance of 'XFile'") {
                    field["value"] = XFile("");
                  } else if (field["value"].toString() == "[Instance of 'XFile']") {
                    field["value"] = [XFile("")];
                  } else {
                    if (field["type"] != "flutterText") {
                      try {
                        field["value"] = null;
                      } catch (e) {
                        field["value"] = [XFile("")];
                      }
                    }
                  }
                }
              });
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            } catch (e) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
          });
          return Future.value(true);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        drawer: const DrawerWidget(),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PageHeader(
                  checkedValue: widget.isAcceptence == true ? "noDialog" : widget.fields[0]["value"],
                  path: widget.fields.indexWhere((element) => element["type"] == "image") == -1
                      ? XFile(" ")
                      : widget.fields[widget.fields.indexWhere((element) => element["type"] == "image")]["value"],
                  title: widget.title,
                  //TODOD: translate
                  isCircle: widget.fields.length <= 3 &&
                          widget.title != translate(context).add_region &&
                          widget.title != translate(context).edit_region &&
                          widget.title != translate(context).add_activity_type &&
                          widget.title != translate(context).edit_activity_type &&
                          widget.title != translate(context).add_subject &&
                          widget.title != translate(context).edit_subject &&
                          widget.title != translate(context).addNote &&
                          widget.title != translate(context).editNote &&
                          widget.title == translate(context).edit_class &&
                          widget.title == translate(context).add_class ||
                      widget.title == translate(context).addEpisode ||
                      widget.title == translate(context).addDivision ||
                      widget.title == translate(context).editEpisode ||
                      widget.title == translate(context).editDivision ||
                      widget.title == translate(context).editEpisodeOrDivision,
                  uploadTap: () {
                    int index = widget.fields.indexWhere((element) => element["type"] == "image");
                    imageDropDown(context, widget.title, () {
                      deleteOnTap(index);
                    }, () {
                      galleryOnTap(index);
                    }, () {
                      cameraOnTap(index);
                    });
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 4),
                    child: Form(
                        key: _formkey,
                        child: TextFieldFor(
                          fields: widget.fields,
                          deleteOnTap: deleteOnTap,
                          galleryOnTap: galleryOnTap,
                          cameraOnTap: cameraOnTap,
                          scrollController: ScrollController(),
                          readOnly: false,
                        )),
                  ),
                ),
                if (widget.isAcceptence == null)
                  SaveButton(onPressed: () async {
                    List filteredFields = widget.fields.where((field) => isValidated(field)).toList();

                    if (_formkey.currentState!.validate()) {
                      if (filteredFields.isEmpty) {
                        try {
                          if (widget.onPressed != null) {
                            // ignore: use_build_context_synchronously
                            if (isConnected) {
                              showLoadingDialog(context);
                            }
                            String status = await widget.onPressed!.call();
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (status == "SUCCESS") {
                              // ignore: use_build_context_synchronously
                              if (isConnected) {
                                //TODO: TRANSLATE
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(status == "SUCCESS" ? "تمت العملية بنجاح" : "تمت العملية بنجاح و بنتظار الموافقة من المدير العام",
                                      style: TextStyle(fontFamily: getFontName(context))),
                                  duration: const Duration(milliseconds: 500),
                                ));
                              }

                              Future.delayed(const Duration(seconds: 1), () {
                                Navigator.of(context).pop();
                              });

                              for (Map field in widget.fields) {
                                if (field["value"].toString() == "Instance of 'XFile'") {
                                  field["value"] = XFile("");
                                } else if (field["value"].toString() == "[Instance of 'XFile']") {
                                  field["value"] = [XFile("")];
                                } else {
                                  if (field["type"] != "flutterText") {
                                    try {
                                      field["value"] = null;
                                    } catch (e) {
                                      field["value"] = [XFile("")];
                                    }
                                  }
                                }
                              }
                            } else if (status == "Duplicate") {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(translate(context).item_already_exists, style: TextStyle(fontFamily: getFontName(context))),
                                duration: const Duration(milliseconds: 500),
                              ));
                            } else if (status == "FAILED") {
                              // ignore: use_build_context_synchronously
                              //Navigator.of(context).pop();
                              // ignore: use_build_context_synchronously
                              await FirebaseAnalytics.instance.logEvent(
                                name: "an_error_occured_${widget.englishTitle}_API_$status",
                                parameters: {
                                  'screen_name': "an_error_occured_${widget.englishTitle}_API_$status",
                                  'screen_class': "Adding",
                                },
                              );
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(translate(context).unexpected_error_message, style: TextStyle(fontFamily: getFontName(context))),
                                duration: const Duration(milliseconds: 500),
                              ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(status, style: TextStyle(fontFamily: getFontName(context))),
                                duration: const Duration(milliseconds: 500),
                              ));
                            }
                            Future.delayed(const Duration(milliseconds: 850), () {
                              Navigator.of(context).pop();
                            });
                            {}
                          }
                        } catch (e, st) {
                          Navigator.of(context).pop();
                          await FirebaseAnalytics.instance.logEvent(
                            name: "an_expected_${widget.englishTitle}_$e",
                            parameters: {
                              'screen_name': "an_expected_error_${widget.englishTitle}_$e",
                              'screen_class': "Adding",
                            },
                          );
                          if (isConnected) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(translate(context).unexpected_error_occurred, style: TextStyle(fontFamily: getFontName(context))),
                              duration: const Duration(milliseconds: 500),
                            ));
                          }
                          print("stst$st");
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(translate(context).fields_required_message, style: TextStyle(fontFamily: getFontName(context))),
                          duration: const Duration(milliseconds: 500),
                        ));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(translate(context).fields_required_message, style: TextStyle(fontFamily: getFontName(context))),
                        duration: const Duration(milliseconds: 500),
                      ));
                    }
                  }),
                if (widget.isAcceptence == true)
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 4),
                          child: GestureDetector(
                              onTap: widget.acceptPressed,
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 41,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(14)),
                                    color: AppColors.primary,
                                  ),

                                  // minWidth: double.infinity,
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 25, right: 25),
                                    child: Center(
                                      child: Text(
                                        "قبول",
                                        style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ))),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 4),
                          child: GestureDetector(
                              onTap: widget.rejectPressed,
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 41,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(14)),
                                    color: Colors.red,
                                  ),

                                  // minWidth: double.infinity,
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 25, right: 25),
                                    child: Center(
                                      child: Text(
                                        "إلغاء",
                                        style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ))),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldFor extends StatefulWidget {
  final List fields;
  final Function cameraOnTap;
  final Function deleteOnTap;
  final Function galleryOnTap;
  final ScrollController scrollController;
  final bool readOnly;
  const TextFieldFor(
      {super.key,
      required this.fields,
      required this.cameraOnTap,
      required this.deleteOnTap,
      required this.galleryOnTap,
      required this.scrollController,
      required this.readOnly});

  @override
  State<TextFieldFor> createState() => _TextFieldForState();
}

class _TextFieldForState extends State<TextFieldFor> {
  Map quranPages = {1: []};
  String clickedNumber = "0";
  getQuranCount() {
    int numbers = 42;
    int countr = 1;
    for (var i = 1; i < 31; i++) {
      for (var j = countr; j <= numbers - 20; j++) {
        quranPages[i] = [...quranPages[i] ?? [], j];
        countr = j;
      }
      if (countr == 582) {
        numbers = numbers + 22;
      } else {
        numbers = numbers + 20;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
              controller: widget.scrollController,
        physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (Map i in widget.fields)
            i["type"] == "flutterText"
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: Text(
                        i["title"],
                        style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : i["type"] == "text"
                    ? StringTextField(
                        controller: TextEditingController(text: i["value"]),
                        title: i["title"],
                        isRequired: i["isRequired"] ?? true,
                        readOnly: i["readOnly"] ?? widget.readOnly,
                        onChanged: (value) {
                          i["value"] = value;
                        },
                      )
                    : i["type"] == "multipleSelection" ||
                            i["type"] == "oneSelection" ||
                            i["type"] == "multipleSelectionQuranJuz" ||
                            i["type"] == "multipleSelectionQuranPages"
                        ? OneSelectionField(
                            isRequired: i["isRequired"] ?? true,
                            title: i["title"],
                            readOnly: widget.readOnly,
                            controller: TextEditingController(text: i["value"]),
                            onTap: () {
                              try {
                                dropDown(
                                        context,
                                        i["type"] == "multipleSelectionQuranPages"
                                            ? clickedNumber == translate(context).correctArabicReading
                                                ? List<int>.generate(100, (i) => i + 1)
                                                : quranPages[int.parse(clickedNumber)]
                                            : i["selections"],
                                        i["type"] == "multipleSelection" || i["type"] == "multipleSelectionQuranPages",
                                        i["value"]?.split(", ") ?? [],
                                        type: i["title"])
                                    .then((value) {
                                  if (value != null) {
                                    setState(() {
                                      if (i["type"] == "multipleSelection" || i["type"] == "multipleSelectionQuranPages") {
                                        i["value"] = value.join(", ");
                                      } else {
                                        i["value"] = value;
                                        setState(() {
                                          if (i["type"] == "multipleSelectionQuranJuz") {
                                            clickedNumber =
                                                value == translate(context).correctArabicReading ? translate(context).correctArabicReading : value;
                                            getQuranCount();
                                          }
                                        });
                                      }
                                    });
                                  }
                                });
                              } catch (e) {
                                print("error: $e");
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(translate(context).select_section_message, style: TextStyle(fontFamily: getFontName(context))),
                                ));
                              }
                            },
                          )
                        : i["type"] == "description"
                            ? DescriptionField(
                                controller: TextEditingController(text: i["value"]),
                                title: i["title"],
                                readOnly: widget.readOnly,
                                onChanged: (value) {
                                  i["value"] = value;
                                },
                              )
                            : i["type"] == "number"
                                ? i["title"].contains(translate(context).phone) ||
                                        i["title"].contains(translate(context).phoneNumberLabel) ||
                                        i["title"].contains(translate(context).whatsapp)
                                    ? PhoneTextField(
                                        controller: TextEditingController(text: i["value"]),
                                        title: i["title"],
                                        isRequired: i["isRequired"] ?? true,
                                        readOnly: widget.readOnly,
                                        onChanged: (PhoneNumber number) {
                                          print(number.dialCode);
                                          print(number.isoCode);
                                          print(number.phoneNumber);
                                          i["value"] = number.phoneNumber!;
                                        },
                                      )
                                    : i["hide"] == true
                                        ? Container()
                                        : NumberTextField(
                                            controller: TextEditingController(text: i["value"]),
                                            title: i["title"],
                                            isRequired: i["isRequired"] ?? true,
                                            readOnly: widget.readOnly,
                                            onChanged: (value) {
                                              i["value"] = value;
                                            },
                                          )
                                : i["type"] == "date" || i["type"] == "time"
                                    ? DatePickerField(
                                        title: i["title"],
                                        onChanged: (value) {
                                          i["value"] = value;
                                        },
                                        readOnly: widget.readOnly,
                                        controller: TextEditingController(text: i["value"]),
                                        onTap: () {
                                          if (i["type"] == "time") {
                                            selectTime(context).then((value) {
                                              if (value != null) {
                                                setState(() {
                                                  i["value"] = value;
                                                });
                                              }
                                            });
                                          } else {
                                            selectDate(context).then((value) {
                                              if (value != null) {
                                                setState(() {
                                                  i["value"] = value;
                                                });
                                              }
                                            });
                                          }
                                        },
                                      )
                                    : widget.fields.length <= 3 || widget.fields.length <= 4
                                        ? Container()
                                        : i["hide"] == true
                                            ? Container()
                                            : ImagePickerWidget(
                                                path: i["multiple"] == false ? i["value"] : null,
                                                isMultiple: i["multiple"],
                                                paths: i["multiple"] == true ? i["value"] : null,
                                                cameraOnTap: () {
                                                  if (i["multiple"] == false) {
                                                    int index = widget.fields.indexOf(i);
                                                    widget.cameraOnTap(index);
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                      backgroundColor: AppColors.primary,
                                                      content: Text(translate(context).option_not_available,
                                                          style: TextStyle(fontFamily: getFontName(context), color: Colors.white)),
                                                    ));
                                                  }
                                                },
                                                deleteOnTap: () {
                                                  if (i["multiple"] == false) {
                                                    int index = widget.fields.indexOf(i);
                                                    widget.deleteOnTap(index);
                                                  } else {
                                                    i["value"] = [XFile("")];
                                                    setState(() {});
                                                  }
                                                },
                                                galleryOnTap: () async {
                                                  if (i["multiple"] == false) {
                                                    int index = widget.fields.indexOf(i);
                                                    widget.galleryOnTap(index);
                                                  } else {
                                                    await ImagePicker().pickMultiImage(imageQuality: 40).then((values) async {
                                                      try {
                                                        for (var value in values) {
                                                          int maxSizeInBytes = 2 * 1024 * 1024; // 2MB
                                                          int fileLength = await value.length();
                                                          if (fileLength <= maxSizeInBytes) {
                                                            i["value"].add(value);
                                                          } else {
                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                              backgroundColor: AppColors.primary,
                                                              content: Text(translate(context).image_exceeds_the_maximum_size,
                                                                  style: TextStyle(fontFamily: getFontName(context), color: Colors.white)),
                                                            ));
                                                          }
                                                        }
                                                      } catch (e) {
                                                        i["value"] = values;
                                                      }
                                                      setState(() {});
                                                    });
                                                  }
                                                },
                                                title: i["title"],
                                              ),
        ],
      ),
    );
  }
}

Future<Object?> showLoadingDialog(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierColor: Colors.white.withOpacity(0.5),
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: const Duration(milliseconds: 200),
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim1),
        child: child,
      );
    },
    pageBuilder: (_, __, ___) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
        ),
      );
    },
  );
}

bool isValidated(Map<String, dynamic> field) {
  if (field['value'] == null && field['type'] != 'flutterText') {
    if (!field.containsKey('isRequired')) {
      return true;
    }
  }
  return false;
}
