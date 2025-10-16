import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/models/doaa.dart';
import 'package:hudayi/services/json.dart';
import 'package:hudayi/ui/helper/App_Consts.dart';
import 'package:hudayi/ui/helper/App_Icons.dart';
import 'package:hudayi/ui/styles/app_Box_Shadow.dart';
import 'package:hudayi/ui/widgets/athkar_title.dart';
import 'package:hudayi/ui/widgets/close_button.dart';
import 'package:hudayi/ui/widgets/drawer.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Ad3yahList extends StatefulWidget {
  const Ad3yahList({
    Key? key,
    this.index = 0,
    required this.category,
  }) : super(key: key);
  final int index;
  final HudayiCategory category;
  @override
  _Ad3yahListState createState() => _Ad3yahListState();
}

class _Ad3yahListState extends State<Ad3yahList> with AutomaticKeepAliveClientMixin<Ad3yahList> {
  @override
  get wantKeepAlive => true;
  List<List<Doaa>> data = [];
  Map dataModel = {"quraan": [], "sunnah": [], "ruqiya": []};
  ItemScrollController controller = ItemScrollController();
  getDoaa() async {
    final List<dynamic> data = await JsonService.instance.init();
    if (dataModel["quraan"].isEmpty) {
      dataModel["quraan"] = data[1]
          .map((dynamic e) {
            e['category'] = HudayiCategory.quraan;
            e['ribbon'] = AppIcons.ad3yahCard;
            e['sectionName'] = categoryTitle[HudayiCategory.quraan];

            return Doaa.fromMap(e);
          })
          .toList()
          .cast<Doaa>();
    }
    if (dataModel["sunnah"].isEmpty) {
      dataModel["sunnah"] = data[2]
          .map((dynamic e) {
            e['category'] = HudayiCategory.sunnah;
            e['ribbon'] = AppIcons.ad3yahCard;
            e['sectionName'] = categoryTitle[HudayiCategory.sunnah];

            return Doaa.fromMap(e);
          })
          .toList()
          .cast<Doaa>();
    }
    if (dataModel["ruqiya"].isEmpty) {
      dataModel["ruqiya"] = data[3]
          .map((dynamic e) {
            e['ribbon'] = AppIcons.ad3yahCard;
            e['category'] = HudayiCategory.ruqiya;
            e['sectionName'] = categoryTitle[HudayiCategory.ruqiya];

            return Doaa.fromMap(e);
          })
          .toList()
          .cast<Doaa>();
    }
    setState(() {});
  }

  @override
  void initState() {
    () async {
      await getDoaa();
      data = <List<Doaa>>[
        dataModel["quraan"],
        dataModel["sunnah"],
        dataModel["ruqiya"],
      ];
      await FirebaseAnalytics.instance.logEvent(
        name: "ad3yah_page_${categoryTitle[widget.category]}",
        parameters: {
          'screen_name': "ad3yah_page_${categoryTitle[widget.category]}",
          'screen_class': "main",
        },
      );
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      body: Column(
        children: <Widget>[
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(width: 45),
                  Text(
                    categoryTitle[widget.category] ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                  HudayiCloseButton(color: Theme.of(context).colorScheme.secondary),
                ],
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: ScrollablePositionedList.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: data.isNotEmpty ? data[widget.category.index - 1].length : 0,
                initialScrollIndex: widget.index,
                itemScrollController: controller,
                itemBuilder: (BuildContext context, int index) {
                  Doaa item = data[widget.category.index - 1][index];

                  return Column(
                    children: [
                      item.info.isNotEmpty
                          ? ThekrTitleCard(
                              title: item.info,
                            )
                          : Container(),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [AppBoxShadow.containerBoxShadow],
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item.text,
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
