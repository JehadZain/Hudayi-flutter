import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/models/allah_name.dart';
import 'package:hudayi/screens/mainPages/azkar/allah_names_expanded.dart';
import 'package:hudayi/services/json.dart';
import 'package:hudayi/ui/helper/App_Constants.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:hudayi/ui/helper/App_Icons.dart';
import 'package:hudayi/ui/widgets/card_sliver_app_bar.dart';
import 'package:hudayi/ui/widgets/drawer.dart';
import 'package:hudayi/ui/widgets/list_item.dart';

class AllahNames extends StatefulWidget {
  const AllahNames({Key? key}) : super(key: key);

  @override
  _AllahNamesState createState() => _AllahNamesState();
}

class _AllahNamesState extends State<AllahNames> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<AllahNames> {
  @override
  bool get wantKeepAlive => true;
  int index = 0;
  List<AllahName> allahNames = [];
  getAthker() async {
    final List<dynamic> data = await JsonService.instance.init();
    if (allahNames.isEmpty) {
      allahNames = data[4]
          .map((dynamic e) {
            e['ribbon'] = AppIcons.ad3yahCardDark;
            return AllahName.fromMap(e);
          })
          .toList()
          .cast<AllahName>();
    }
  }

  @override
  initState() {
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: "allah_names",
        parameters: {
          'screen_name': "allah_names",
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
                  ? AppIcons.allahNamesCardDark
                  : AppIcons.allahNamesCard),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final AllahName title = allahNames[index];
                return ListItem(
                  title: title.name,
                  icon: AppConstants.appLogo,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<AllahNamesList>(
                        builder: (_) => AllahNamesList(
                          index: index,
                          allahNames: allahNames,
                        ),
                      ),
                    );
                  },
                );
              },
              childCount: allahNames.length,
            ),
          )
        ],
      ),
    );
  }
}
