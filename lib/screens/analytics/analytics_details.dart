import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hudayi/ui/helper/app_functions.dart';
import 'package:hudayi/ui/helper/string_casing_extension.dart';
import 'package:hudayi/ui/widgets/TextFields/search_text_field.dart';
import 'package:hudayi/ui/widgets/accordion.dart';
import 'package:hudayi/ui/widgets/drawer.dart';
import 'package:hudayi/ui/widgets/helper.dart';
import 'package:hudayi/ui/widgets/page_header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AnalyticsDetails extends StatefulWidget {
  final String name;
  final Map item;
  const AnalyticsDetails({Key? key, required this.name, required this.item}) : super(key: key);

  @override
  State<AnalyticsDetails> createState() => _AnalyticsDetailsState();
}

class _AnalyticsDetailsState extends State<AnalyticsDetails> {
  final TextEditingController searchController = TextEditingController();
  ScrollController _controller = ScrollController();
  bool isScolled = false;
  List stateTemp = [];
  List grades = [];
  @override
  void initState() {
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: "analytics_details_${widget.name}_page",
        parameters: {
          'screen_name': "analytics_details_${widget.name}_page",
          'screen_class': "Analytics",
        },
      );
    }();
    for (Map item in widget.item['grades']) {
      grades.add({
        ...item,
        "class_rooms": item['class_rooms'].map((e) => {...e, "accordion": false}).toList(),
      });
    }

    stateTemp.addAll([
      {
        "name": translate(Get.context!).number_of_rows,
        "from": widget.item["grade_count"] ?? 0,
        "to": widget.item["grade_count"] ?? 0,
      },
      {
        "name": translate(Get.context!).approved_students_count,
        "from": widget.item["approved_students_count"] ?? 0,
        "to": widget.item["approved_students_count"] ?? 0,
      },
      {
        "name": translate(Get.context!).number_of_sections,
        "from": widget.item["classroom_count"] ?? 0,
        "to": widget.item["classroom_count"] ?? 0,
      },
      {
        "name": translate(Get.context!).lessons_count,
        "from": widget.item["sessions_count"] ?? 0,
        "to": widget.item["sessions_count"] ?? 0,
      },
      {
        "name": translate(Get.context!).activities,
        "from": widget.item["activities_count"] ?? 0,
        "to": widget.item["activities_count"] ?? 0,
      },
    ]);
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
      resizeToAvoidBottomInset: false,
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
                title: widget.name,
                isCircle: false,
              ),
              Helper.sizedBoxH15,
              if (MediaQuery.of(context).viewInsets.bottom == 0)
                AnimatedCrossFade(
                  firstChild: stateTemp.isEmpty
                      ? Center(child: Text(translate(context).no_results))
                      : SizedBox(
                          height: 220,
                          child: GridView.count(
                            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 0, bottom: 4),
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 10,
                            crossAxisCount: 2,
                            childAspectRatio: 2.5,
                            children: <Widget>[
                              for (var listItem in stateTemp)
                                GestureDetector(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 14.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          CircularPercentIndicator(
                                            percent: listItem["from"] == 0 ? 1 : listItem["from"] / listItem["to"],
                                            radius: 30,
                                            lineWidth: 8,
                                            animation: true,
                                            progressColor: Theme.of(context).primaryColor,
                                            backgroundColor: const Color(0xFFF1F4F8),
                                            center: Text(
                                              '${listItem["from"]}',
                                              style: const TextStyle(
                                                color: Color(0xFF101213),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                listItem["name"],
                                                style: const TextStyle(
                                                  color: Color(0xFF57636C),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                            ],
                          ),
                        ),
                  crossFadeState: !isScolled ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 500),
                  secondChild: Container(),
                ),
              Expanded(
                child: Column(
                  children: [
                    SearchTextField(
                      searchController: searchController,
                      title: translate(context).search,
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        controller: _controller,
                        children: [
                          for (var item in searchController.text == ""
                              ? grades
                              : grades
                                  .where((e) =>
                                      e["name"].contains(searchController.text.toTitleCase()) ||
                                      e["name"].contains(searchController.text) ||
                                      e["name"].contains(searchController.text.toCapitalized()))
                                  .toList())
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                                  child: Text(
                                    item["name"],
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                for (Map class_room in item["class_rooms"])
                                  GestureDetector(
                                    child: Accordion(
                                      showContent: class_room["accordion"],
                                      disableClick: false,
                                      title: Padding(
                                        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 4),
                                        child: mainContainer(context, class_room["name"].toString(), Icons.keyboard_arrow_down_rounded),
                                      ),
                                      content: Padding(
                                        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
                                        child: Container(
                                          decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(14)),
                                          child: Column(
                                            children: [
                                              mainContainer(context, class_room["name"], Icons.keyboard_arrow_up_rounded),
                                              analticsRow(class_room, "sessions_count", "activities_count", translate(context).numberOfLessons, translate(context).numberOfActivities),
                                              analticsRow(class_room, "class_room_students_count", "", translate(context).numberOfStudents, ""),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        class_room["accordion"] = !class_room["accordion"];
                                      });
                                    },
                                  ),
                              ],
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row analticsRow(item, item1, item2, name1, name2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4, left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        name1,
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0, bottom: 6),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0XFF07B7AD),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 23.0, right: 23),
                          child: Text(
                            item[item1].toString(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (item2 != "")
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4, left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          name2,
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0, bottom: 6),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0XFF07B7AD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 23.0, right: 23),
                            child: Text(
                              item[item2].toString(),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Container mainContainer(BuildContext context, text, icon) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(14)),
      child: Container(
        height: 81,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
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
              Text(
                text,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Icon(icon)
            ],
          ),
        ),
      ),
    );
  }
}
