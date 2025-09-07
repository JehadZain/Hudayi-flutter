import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/models/Languageprovider.dart';
import 'package:hudayi/screens/home.dart';
import 'package:hudayi/ui/helper/AppColors.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/helper/AppIcons.dart';
import 'package:hudayi/ui/widgets/card_sliver_app_bar.dart';
import 'package:hudayi/ui/widgets/drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class Prayer extends StatefulWidget {
  const Prayer({super.key});

  @override
  State<Prayer> createState() => _PrayerState();
}

class _PrayerState extends State<Prayer> with AutomaticKeepAliveClientMixin<Prayer> {
  @override
  bool get wantKeepAlive => true;
  bool _permissionDenied = false;
  Map prayers = {};
  _getUserLocation() async {
  }

  @override
  void initState() {
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: "prayer_times",
        parameters: {
          'screen_name': "prayer_times",
          'screen_class': "main",
        },
      );
    }();
    _getUserLocation();
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
                    ? AppIcons.prayerBannerNight
                    : AppIcons.prayerBannerMorning),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: prayers.isNotEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
                      children: [
                         Center(
                          child: Text(
                            "أوقات الصلاة حسب توقيتك المحلي",
                            style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: getFontName(context), fontWeight: FontWeight.bold),
                          ),
                        ),
                        _permissionDenied == true
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(18.0),
                                    child: Text(
                                        "تم رفض الإذن بالوصول إالى الموقع الرجاء السماح للتطبيق بالوصول إلى الموقع من أجل إعطائك أوقات الصلاة الصحيحة",
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: TextButton(
                                        onPressed: () async {
                                          await Permission.locationWhenInUse.request();
                                          openAppSettings().then((value) => Navigator.pushAndRemoveUntil(
                                              context, MaterialPageRoute(builder: (context) => const HomeScreen()), (Route<dynamic> route) => false));
                                        },
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                                            padding: MaterialStateProperty.all<EdgeInsets>(
                                                const EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40)),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(7),
                                                side: const BorderSide(width: 0, color: Colors.transparent)))),
                                        child: const Text(
                                          "أطلب الإذن",
                                          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                                        )),
                                  ),
                                ],
                              )
                            : prayers.isEmpty
                                ? Center(
                                    child: Padding(
                                        padding: const EdgeInsets.only(top: 200),
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context).primaryColor,
                                        )))
                                : Column(
                                    children: [
                                      PrayRow(AppIcons.sabah, "صلاة الصبح", prayers["fajrTime"]),
                                      PrayRow(AppIcons.doha, "صلاة الضحى", prayers["sunriseTime"]),
                                      PrayRow(AppIcons.dahr, "صلاة الظهر", prayers["dhuhrTime"]),
                                      PrayRow(AppIcons.asr, "صلاة العصر", prayers["asrTime"]),
                                      PrayRow(AppIcons.mgreb, "صلاة المغرب", prayers["maghribTime"]),
                                      PrayRow(AppIcons.moon, "صلاة العشاء", prayers["ishaTime"]),
                                      PrayRow(AppIcons.moon, "منتصف الليل", prayers["middleOfTheNight"]),
                                      PrayRow(AppIcons.stars, "الثلث الأخير من الليل", prayers["lastThirdOfTheNight"]),
                                    ],
                                  ),
                      ],
                    ),
                  );
                },
                childCount: 1,
              ),
            )
          ],
        ));
  }
}

class PrayRow extends StatelessWidget {
  final String image;
  final String text;
  final tz.TZDateTime time;
  const PrayRow(this.image, this.text, this.time, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            image,
            height: 30,
            width: 30,
            color: AppColors.primary,
          ),
          Text(text),
          Text(time.toString().split(" ")[1].toString().substring(0, 5))
        ],
      ),
    );
  }
}
