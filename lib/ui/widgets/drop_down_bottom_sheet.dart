import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/ui/helper/App_Colors.dart';
import 'package:hudayi/ui/helper/App_Constants.dart';
import 'package:hudayi/ui/helper/App_Consts.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:hudayi/ui/helper/String_Casing_Extension.dart';
import 'package:hudayi/ui/widgets/Circule_Progress.dart';
import 'package:hudayi/ui/widgets/TextFields/search_Text_Field.dart';
import 'package:hudayi/ui/widgets/grid_View_List.dart';
import 'package:hudayi/ui/widgets/helper.dart';
import 'package:provider/provider.dart';

import '../../services/API/api.dart';
import '../helper/App_Dialog.dart';

class DropDown extends StatefulWidget {
  final List words;
  final String? type;
  final List selectedWords;
  final bool isMultiple;
  final bool? isPagnet;
  final bool? isNullable;
  final Function(dynamic)? getData;
  const DropDown(
      {Key? key,
      required this.words,
      required this.isMultiple,
      required this.selectedWords,
      this.isPagnet,
      this.getData,
      this.isNullable,
      this.type})
      : super(key: key);

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  final TextEditingController searchDropController = TextEditingController();
  int page = 1;
  ScrollController _controller = ScrollController();
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  List selectedWords = [];

  getData() async {
    if (!mounted) return;
    setState(() {
      _isLoadMoreRunning = true;
    });
    List words = await widget.getData!(page);
    if (!mounted) return;
    // Deduplicate and determine if there are any new items
    final List newWords =
        words.where((w) => !widget.words.contains(w)).toList();
    if (newWords.isEmpty) {
      setState(() {
        _hasNextPage = false;
      });
    } else {
      page += 1;
    }

    if (!mounted) return;
    setState(() {
      widget.words.addAll(newWords);
      _isLoadMoreRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 100) {
      try {
        getData();
      } catch (err) {}
    }
  }

  setUpdaData(words) {
    if (!mounted) return;
    setState(() {
      selectedWords = widget.selectedWords;
    });
    bool allIntegers = words.every((item) => item is int);
    if (widget.selectedWords.isEmpty) {
      if (widget.isMultiple &&
              widget.selectedWords.isEmpty &&
              !allIntegers &&
              widget.isPagnet == false ||
          widget.type == translate(Get.context!).present_students) {
        selectedWords.addAll(words.map((word) => word.toString()));
      }
    }
  }

  bool isLodaing = true;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      setState(() {
        isLodaing = false;
      });
    });
    if (widget.isPagnet == true) {
      () async {
        List words = await widget.getData!(1);
        if (!mounted) return;
        // Seed with unique items only
        final List newWords =
            words.where((w) => !widget.words.contains(w)).toList();
        if (newWords.isEmpty) {
          _hasNextPage = false;
        } else {
          page += 1;
          widget.words.addAll(newWords);
        }
        setUpdaData(words);
      }();
    } else {
      setUpdaData(widget.words);
    }

    super.initState();
    if (widget.isPagnet == true) {
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
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    _controller.dispose();
    searchDropController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Color(0x3B1D2429),
            offset: Offset(0, -3),
          )
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Stack(alignment: Alignment.topCenter, children: <Widget>[
        Container(
          width: 50,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFDBE2E7),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                child: Scrollbar(
                  controller: _controller,
                  radius: const Radius.circular(18),
                  thickness: 2,
                  interactive: true,
                  child: ListView(
                    controller: _controller,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Row(
                          children: [
                            if (widget.isMultiple)
                              GestureDetector(
                                child: CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  radius: 15,
                                  child: Icon(
                                    selectedWords.length != widget.words.length
                                        ? Icons.check_circle_outline_outlined
                                        : Icons.check_circle_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                onTap: () {
                                  if (selectedWords.length !=
                                      widget.words.length) {
                                    selectedWords = [];
                                    selectedWords.addAll(widget.words
                                        .map((word) => word.toString()));
                                  } else {
                                    selectedWords = [];
                                  }
                                  setState(() {});
                                },
                              ),
                            Expanded(
                              child: Container(
                                child: SearchTextField(
                                  searchController: searchDropController,
                                  title: translate(Get.context!).search,
                                  onChanged: (_) {
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isLodaing && widget.words.isEmpty)
                        const CirculeProgress(),
                      if (!isLodaing && widget.words.isEmpty)
                        Center(
                            child:
                                Text(translate(Get.context!).noDataAvailable)),
                      if (widget.words.isNotEmpty)
                        for (var word in searchDropController.text == ""
                            ? widget.words
                            : widget.words
                                .where((e) =>
                                    e.contains(searchDropController.text
                                        .toTitleCase()) ||
                                    e.contains(searchDropController.text) ||
                                    e.contains(searchDropController.text
                                        .toCapitalized()))
                                .toList())
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 10, 0),
                            child: InkWell(
                                splashColor: AppColors.primary,
                                onTap: () {
                                  if (widget.isMultiple) {
                                    if (!selectedWords
                                        .contains(word.toString())) {
                                      setState(() {
                                        selectedWords.add(word.toString());
                                      });
                                    } else {
                                      setState(() {
                                        selectedWords.remove(word.toString());
                                      });
                                    }
                                  } else {
                                    Navigator.of(context).pop(word.toString());
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(7),
                                        border: Border.all(
                                          color: const Color(0xFFF1F4F8),
                                          width: 2,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16, 12, 16, 12),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                word.toString(),
                                                style: const TextStyle(
                                                  color: Color(0xFF090F13),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            if (selectedWords
                                                .contains(word.toString()))
                                              const Icon(
                                                Icons.check,
                                                color: Colors.black,
                                              )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10)
                                  ],
                                )),
                          ),
                    ],
                  ),
                ),
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
        if (widget.isMultiple)
          Positioned(
              bottom: 10,
              left: 0,
              child: GestureDetector(
                child: const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  if (selectedWords.isNotEmpty) {
                    Navigator.of(context).pop(selectedWords);
                  }
                },
              )),
      ]),
    );
  }
}

class LongDropDown extends StatefulWidget {
  final List group;
  final List selectedWords;
  final bool? isPagnet;
  final Function(dynamic)? getData;
  final Function(dynamic)? onAdd;
  final Function(dynamic)? onDelete;
  const LongDropDown(
      {Key? key,
      required this.group,
      required this.selectedWords,
      this.isPagnet,
      this.getData,
      this.onAdd,
      this.onDelete})
      : super(key: key);

  @override
  State<LongDropDown> createState() => _LongDropDownState();
}

class _LongDropDownState extends State<LongDropDown> {
  final TextEditingController searchDropController = TextEditingController();
  int page = 1;
  ScrollController _controller = ScrollController();
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  List selectedWords = [];

  getData() async {
    if (!mounted) return;
    setState(() {
      _isLoadMoreRunning = true;
    });
    List words = await widget.getData!(page);
    if (!mounted) return;
    if (words.isEmpty) {
      setState(() {
        _hasNextPage = false;
      });
    } else {
      page += 1;
    }

    if (!mounted) return;
    setState(() {
      // Deduplicate
      for (var w in words) {
        if (!widget.group.contains(w)) {
          widget.group.add(w);
        }
      }
      _isLoadMoreRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 100) {
      try {
        getData();
      } catch (err) {}
    }
  }

  var authService;
  @override
  void initState() {
    authService = Provider.of<AuthService>(context, listen: false);
    if (widget.isPagnet == true) {
      () async {
        List words = await widget.getData!(1);
        if (!mounted) return;
        if (words.isEmpty) {
          _hasNextPage = false;
        } else {
          page += 1;
          for (var w in words) {
            if (!widget.group.contains(w)) {
              widget.group.add(w);
            }
          }
        }
      }();
    }
    super.initState();
    if (widget.isPagnet == false) {
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
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    _controller.dispose();
    searchDropController.dispose();
    super.dispose();
  }

  getUnassignedAdmins(page) {
    return ApiService()
        .getUnassignedAdmins(jsonDecode(authService.user.toUser())["token"],
            page: page)
        .then((data) {
      try {
        List admins = data["data"]
            .map((e) =>
                '${e["name"] ?? e["user"]["first_name"]} ${e["user"]["last_name"] ?? ""} - ${e["id"]}')
            .toList();

        return admins;
      } catch (e) {
        return [];
      }
    });
  }

  getProprtyData(id) {
    return ApiService()
        .getPropretyGrade(jsonDecode(authService.user.toUser())["token"], id)
        .then((data) {
      try {
        List<dynamic> gradeClassStrings = data["data"];

        return gradeClassStrings;
      } catch (e) {
        return [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Color(0x3B1D2429),
            offset: Offset(0, -3),
          )
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Stack(alignment: Alignment.topCenter, children: <Widget>[
        Container(
          width: 50,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFDBE2E7),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                      child: GridViewList(
                    onRefresh: () async {},
                    searchController: TextEditingController(),
                    controller: ScrollController(),
                    itemClick: widget.onDelete != null && widget.onAdd != null
                        ? null
                        : (item) async {
                            showLoadingDialog(context);
                            List data = await getProprtyData(item["id"]);
                            Navigator.of(context).pop();
                            dropDown(context, data, false, isPagnet: false, [])
                                .then((value) async {
                              if (value != null) {
                                Map result = {};
                                if (widget.selectedWords.contains("student")) {
                                  result = await ApiService().transferStudent(
                                      {
                                        "studnet_id": widget.selectedWords[1]
                                            ["id"],
                                        "new_property_id":
                                            item["id"].toString(),
                                        "new_class_id": int.parse(
                                            value.toString().split(" - ")[2]),
                                      },
                                      jsonDecode(
                                          authService.user.toUser())["token"]);
                                } else if (widget.selectedWords
                                    .contains("teacher")) {
                                  result = await ApiService().transferTeacher(
                                      {
                                        "teacher_id": widget.selectedWords[1]
                                            ["id"],
                                        "new_property_id":
                                            item["id"].toString(),
                                        "new_class_id": int.parse(
                                            value.toString().split(" - ")[2]),
                                      },
                                      jsonDecode(
                                          authService.user.toUser())["token"]);
                                }
                                String status = result["api"];
                                Navigator.of(context).pop(status);
                              }
                            });
                          },
                    addPage: null,
                    isClickable: widget.onDelete == null && widget.onAdd == null
                        ? false
                        : jsonDecode(authService.user.toUser())["role"] ==
                                "admin" ||
                            jsonDecode(authService.user.toUser())['role'] ==
                                    "branch_admin" &&
                                jsonDecode(authService.user.toUser())["role"] ==
                                    "property_admin",
                    permmission: widget.onDelete == null && widget.onAdd == null
                        ? false
                        : jsonDecode(authService.user.toUser())["role"] ==
                                "admin" ||
                            jsonDecode(authService.user.toUser())['role'] ==
                                    "branch_admin" &&
                                jsonDecode(authService.user.toUser())["role"] ==
                                    "property_admin",
                    onTap: () {
                      dropDown(context, [], true, isPagnet: true,
                              getData: (page) async {
                        return await getUnassignedAdmins(page);
                      }, [], isNullable: true)
                          .then((value) async {
                        if (value != null) {
                          // ignore: unused_local_variable
                          final authService =
                              Provider.of<AuthService>(context, listen: false);
                          List newAdmins = value
                              .map((item) => item.split(" - ")[1])
                              .toList();
                          showLoadingDialog(context);
                          Map result = await widget.onAdd!(newAdmins);

                          String status = result["api"];
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.of(context).pop(status);
                          Navigator.of(context).pop(status);
                        }
                      });
                    },
                    list: widget.group,
                    tabs: getAdminTabs(context),
                    pageType: "admin",
                    onDeletePressed: (item, index) async {
                      // ignore: unused_local_variable
                      final authService =
                          Provider.of<AuthService>(context, listen: false);
                      showCustomDialog(
                          context,
                          translate(Get.context!).confirm_delete,
                          AppConstants.appLogo,
                          "delete", () async {
                        Map result = await widget.onDelete!(item);
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop(result["api"]);

                        return result["api"];
                      });
                    },
                  )),
                ],
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
      ]),
    );
  }
}

Future<dynamic> dropDown(
    BuildContext context, List words, bool isMultiple, List selectedWords,
    {bool? isPagnet,
    String? type,
    Function(dynamic)? getData,
    bool? longDropDown,
    final Function(dynamic)? onAdd,
    final Function(dynamic)? onDelete,
    bool? isNullable}) {
  return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      useSafeArea: true,
      constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height * 0.95),
      isScrollControlled: longDropDown == true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, dialogSetState) {
          return longDropDown == true
              ? LongDropDown(
                  group: words,
                  selectedWords: selectedWords,
                  isPagnet: isPagnet,
                  getData: getData,
                  onAdd: onAdd,
                  onDelete: onDelete,
                )
              : DropDown(
                  words: words,
                  type: type,
                  isMultiple: isMultiple,
                  selectedWords: selectedWords,
                  isPagnet: isPagnet,
                  getData: getData,
                  isNullable: isNullable);
        });
      });
}

imageDropDown(BuildContext context, String title, Function() deleteOnTap,
    Function() galleryOnTap, Function() cameraOnTap) {
  return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, dialogSetState) {
          return Container(
            padding: EdgeInsets.zero,
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14))),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 18),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            deleteOnTap();
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: AppColors.primary,
                            size: 28,
                          )),
                    ],
                  ),
                  Helper.sizedBoxH10,
                  Row(
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 31,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    galleryOnTap();
                                  },
                                  icon: const Icon(
                                    Icons.photo,
                                    color: AppColors.primary,
                                    size: 32,
                                  )),
                            ),
                          ),
                          Text(translate(Get.context!).fromTheExhibition),
                        ],
                      ),
                      Helper.sizedBoxW20,
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 31,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    cameraOnTap();
                                  },
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: AppColors.primary,
                                    size: 32,
                                  )),
                            ),
                          ),
                          Text(translate(Get.context!).fromTheCamera),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      });
}
