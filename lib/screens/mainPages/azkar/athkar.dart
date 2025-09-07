import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/models/thekr.dart';
import 'package:hudayi/services/json.dart';
import 'package:hudayi/ui/helper/AppConstants.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/helper/AppIcons.dart';
import 'package:hudayi/ui/widgets/card_sliver_app_bar.dart';
import 'package:hudayi/ui/widgets/drawer.dart';
import 'package:hudayi/ui/widgets/list_item.dart';

import 'athkar_expanded.dart';

class AthkarPage extends StatefulWidget {
  const AthkarPage({Key? key}) : super(key: key);

  @override
  _AthkarPageState createState() => _AthkarPageState();
}

class _AthkarPageState extends State<AthkarPage> with AutomaticKeepAliveClientMixin<AthkarPage> {
  @override
  bool get wantKeepAlive => true;
  List<Thekr> athkarTitles = [];
  getAthker() async {
    final List<dynamic> data = await JsonService.instance.init();
    if (athkarTitles.isEmpty) {
      int section = 0;

      //add الأذكار
      data[0].forEach((String k, dynamic v) {
        final Thekr title = Thekr.fromMap(
          <String, dynamic>{
            'text': k,
            'isTitle': true,
            'sectionName': k,
            'section': section,
            "athkar": v,
          },
        );

        athkarTitles = <Thekr>[...athkarTitles, title];

        v.forEach((dynamic value) {
          value['sectionName'] = k;
          value['section'] = section;

          athkarTitles = <Thekr>[...athkarTitles, Thekr.fromMap(value)];
        });

        section++;
      });
    }
  }

  @override
  initState() {
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: "azkar_page",
        parameters: {
          'screen_name': "azkar_page",
          'screen_class': "main",
        },
      );
    }();
    getAthker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const DrawerWidget(),
        body: CustomScrollView(
          slivers: [
            CardSliverAppBar(
                cardImagePath: !AppFunctions().isValidTimeRange(const TimeOfDay(hour: 06, minute: 00), const TimeOfDay(hour: 18, minute: 00))
                    ? AppIcons.athkarCardDark
                    : AppIcons.athkarCard),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final Thekr title = athkarTitles[index];
                  return title.isTitle
                      ? ListItem(
                          title: title.text,
                          icon: AppConstants.appLogo,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<Athkar>(
                                builder: (_) => Athkar(
                                  thekr: athkarTitles[index],
                                ),
                              ),
                            );
                          },
                        )
                      : Container();
                },
                childCount: athkarTitles.length,
              ),
            )
          ],
        ));
  }
}
