import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/analytics/analytics_details.dart';
import 'package:hudayi/services/API/api.dart';
import 'package:hudayi/ui/helper/app_functions.dart';
import 'package:hudayi/ui/helper/string_casing_extension.dart';
import 'package:hudayi/ui/widgets/TextFields/search_text_field.dart';
import 'package:hudayi/ui/widgets/add_container.dart';
import 'package:hudayi/ui/widgets/drawer.dart';
import 'package:hudayi/ui/widgets/page_header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Analytics extends StatefulWidget {
  const Analytics({Key? key}) : super(key: key);

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  final TextEditingController searchController = TextEditingController();
  ScrollController _controller = ScrollController();
  bool isScolled = false;
  bool isEmpty = false;
  List props = [];
  bool isLoading = false;
  var authService;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  getData() {
    setState(() {
      isLoading = true;
    });
    props.clear();
    ApiService().getStatics(jsonDecode(Provider.of<AuthService>(context, listen: false).user.toUser())["token"]).then((data) {
      if (data["data"] != null) {
        setState(() {
          props.addAll(data["data"]);
          isLoading = false;
        });
      } else {
        setState(() {
          isEmpty = true;
          isLoading = true;
        });
      }
    });
  }

  @override
  void initState() {
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: "analytics_index_page",
        parameters: {
          'screen_name': "analytics_index_page",
          'screen_class': "Analytics",
        },
      );
    }();
    getData();
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
    return Scaffold(
      drawer: const DrawerWidget(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PageHeader(
              checkedValue: "noDialog",
              path: XFile(" "),
              title: translate(context).statistics,
              isCircle: false,
            ),
            AnimatedCrossFade(
              firstChild: SearchTextField(
                searchController: searchController,
                title: translate(context).search,
                onChanged: (_) {
                  setState(() {});
                },
              ),
              crossFadeState: !isScolled ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 500),
              secondChild: Container(),
            ),
            isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView(
                    controller: _controller,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      for (var item in searchController.text == ""
                          ? props
                          : props
                              .where((e) =>
                                  e["name"].contains(searchController.text.toTitleCase()) ||
                                  e["name"].contains(searchController.text) ||
                                  e["name"].contains(searchController.text.toCapitalized()))
                              .toList())
                        AddContainer(
                          isArrow: true,
                          text: item["name"],
                          color: Colors.white,
                          page: AnalyticsDetails(
                            name: item["name"],
                            item: item,
                          ),
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        )
                    ],
                  ))
          ],
        ),
      ),
    );
  }
}
