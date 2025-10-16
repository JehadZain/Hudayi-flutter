import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/screens/mainPages/azkar/ad3yah_expanded.dart';
import 'package:hudayi/ui/helper/App_Constants.dart';
import 'package:hudayi/ui/helper/App_Consts.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:hudayi/ui/helper/App_Icons.dart';
import 'package:hudayi/ui/widgets/card_sliver_app_bar.dart';
import 'package:hudayi/ui/widgets/drawer.dart';
import 'package:hudayi/ui/widgets/list_item.dart';

class Ad3yah extends StatefulWidget {
  const Ad3yah({Key? key}) : super(key: key);

  @override
  State<Ad3yah> createState() => _Ad3yahState();
}

class _Ad3yahState extends State<Ad3yah> {
  @override
  initState() {
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: "ad3yah_page",
        parameters: {
          'screen_name': "ad3yah_page",
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
      body: CustomScrollView(
        slivers: [
          CardSliverAppBar(
              cardImagePath: !AppFunctions().isValidTimeRange(const TimeOfDay(hour: 06, minute: 00), const TimeOfDay(hour: 18, minute: 00))
                  ? AppIcons.ad3yahCardDark
                  : AppIcons.ad3yahCard),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const Ad3yahTitleCard(
                  title: Titles.quraan,
                  icon: AppConstants.appLogo,
                  category: HudayiCategory.quraan,
                ),
                const Ad3yahTitleCard(
                  title: Titles.sunnah,
                  icon: AppConstants.appLogo,
                  category: HudayiCategory.sunnah,
                ),
                const Ad3yahTitleCard(
                  title: Titles.ruqya,
                  icon: AppConstants.appLogo,
                  category: HudayiCategory.ruqiya,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Ad3yahTitleCard extends StatelessWidget {
  const Ad3yahTitleCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.category,
  }) : super(key: key);

  final String icon;
  final String title;
  final HudayiCategory category;

  @override
  Widget build(BuildContext context) {
    return ListItem(
      icon: icon,
      title: title,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<Ad3yahList>(
            builder: (_) => Ad3yahList(category: category),
            fullscreenDialog: true,
          ),
        );
      },
    );
  }
}
