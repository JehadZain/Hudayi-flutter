import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/services/API/api.dart';
import 'package:hudayi/ui/helper/App_Consts.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:hudayi/ui/widgets/Circule_Progress.dart';
import 'package:hudayi/ui/widgets/drawer.dart';
import 'package:hudayi/ui/widgets/helper.dart';
import 'package:hudayi/ui/widgets/list_View_Component.dart';
import 'package:hudayi/ui/widgets/page_Header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class StudentFilterPage extends StatefulWidget {
  const StudentFilterPage({super.key});

  @override
  State<StudentFilterPage> createState() => _StudentFilterPageState();
}

class _StudentFilterPageState extends State<StudentFilterPage> {
  final TextEditingController searchController = TextEditingController();
  ScrollController _controller = ScrollController();
  List students = [];
  var authService;
  int page = 1;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  bool isEmpty = false;
  bool isLoading = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  getData({String? search}) {
    if (search == null) {
      setState(() {
        _isLoadMoreRunning = true;
      });
    }
    setState(() {
      isLoading = true;
    });
    ApiService().getAllStudents(jsonDecode(authService.user.toUser())["token"], page, search: search).then((data) {
      if (data["api"] == "NO_DATA") {
        setState(() {
          _hasNextPage = false;
          isEmpty = true;
          isLoading = false;
        });
      } else {
        if (data["data"] == null) {
          setState(() {
            _hasNextPage = false;
            _isLoadMoreRunning = false;
            isEmpty = true;
            isLoading = false;
          });
        } else {
          if (data["data"]["data"].isEmpty) {
            setState(() {
              _hasNextPage = false;
              isEmpty = true;
              isLoading = false;
            });
          } else {
            page += 1;
          }
          setState(() {
            students.addAll(data["data"]["data"]);
            _isLoadMoreRunning = false;
            isLoading = false;
          });
        }
      }
    });
  }

  @override
  void initState() {
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: 'all_students_filter_page',
        parameters: {
          'screen_name': "all_students_filter_page",
          'screen_class': "profile",
        },
      );
    }();
    authService = Provider.of<AuthService>(context, listen: false);
    getData();
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
    if (_hasNextPage == true && _isLoadMoreRunning == false && _controller.position.extentAfter < 100) {
      try {
        getData();
      } catch (err) {}
    }
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
                title: translate(context).search_filter_student,
                isCircle: false,
              ),
              Expanded(
                child: ListViewComponent(
                  isEmpty: isEmpty,
                  isLoading: isLoading,
                  onRefresh: () async {
                    setState(() {
                      students.clear();
                      page = 1;
                      _hasNextPage = true;
                    });
                    getData();
                  },
                  onSearch: (value) {
                    if (value != "") {
                      setState(() {
                        students.clear();
                        page = 1;
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
                  searchController: searchController,
                  controller: _controller,
                  list: students.asMap().entries.map((entry) {
                    return {
                      "id": entry.value["id"],
                      "name": entry.value["name"] ?? translate(context).not_available,
                      "image": entry.value["image"],
                      "gender": getGenderValue(context, entry.value["gender"]),
                      "type":getStatusValue(context,  entry.value["status"]),
                      "description": '${translate(context).serial_number}: ${entry.value["id"] ?? translate(context).not_available}',
                    };
                  }).toList(),
                  isAdding: false,
                  permmission: true,
                  addPage: null,
                  tabs: getStudentTabs(context),
                  pageType: "student",
                ),
              ),
              if (_isLoadMoreRunning && students.length != 0)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [Helper.sizedBoxH5, const CirculeProgress()],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
