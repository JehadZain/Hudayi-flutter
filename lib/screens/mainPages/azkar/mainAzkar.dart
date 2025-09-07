import 'package:animate_do/animate_do.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/screens/mainPages/azkar/ad3yah.dart';
import 'package:hudayi/screens/mainPages/azkar/allah_names.dart';
import 'package:hudayi/screens/mainPages/azkar/athkar.dart';
import 'package:hudayi/screens/mainPages/azkar/prayerTimes.dart';
import 'package:hudayi/ui/helper/AppIcons.dart';
import 'package:hudayi/ui/widgets/animatedHeader.dart';
import 'package:hudayi/ui/widgets/home_card.dart';

class Azkar extends StatelessWidget {
  const Azkar({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.logEvent(
      name: "islamic_main_page",
      parameters: {
        'screen_name': "islamic_main_page",
        'screen_class': "main",
      },
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            FadeIn(
              animate: true,
              duration: const Duration(seconds: 1),
              child: const AnimatedHeader(
                text: "الأذكار",
                height: 110,
              ),
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 10),
                    FadeIn(
                      animate: true,
                      duration: const Duration(seconds: 1),
                      child: Stack(
                        children: <Widget>[
                          const Column(
                            children: <Widget>[
                              HomeCard(
                                page: AthkarPage(),
                                text: "الأذكار",
                                description: "من هنا تستطيع تصفح الأذكار",
                                image: AppIcons.athkarIcon,
                                count: 423,
                              ),
                              HomeCard(
                                page: Ad3yah(),
                                text: "الأدعية",
                                description: "من هنا تستطيع تصفح الأدعية",
                                image: AppIcons.doaIcon,
                                count: 3,
                              ),
                              HomeCard(
                                page: AllahNames(),
                                text: "أسماء الله الحسنى",
                                description: "من هنا تستطيع تصفح أسماء الله الحسنى",
                                image: AppIcons.allahNamesIcon,
                                count: 99,
                              ),
                              HomeCard(
                                page: Prayer(),
                                text: "أوقات الصلاة",
                                description: "من هنا تستطيع تصفح أوقات الصلاة",
                                image: AppIcons.prayerIcon,
                                count: 5,
                              ),
                            ],
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 400),
                            opacity: 0.0,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                color: Colors.transparent,
                                height: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
