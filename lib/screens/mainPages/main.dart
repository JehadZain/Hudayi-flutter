import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/main.dart';
import 'package:hudayi/models/Languageprovider.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/screens/mainPages/login.dart';
import 'package:hudayi/services/API/api.dart';
import 'package:hudayi/services/pref_utils.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/helper/AppIcons.dart';
import 'package:hudayi/ui/styles/appBorderRadius.dart';
import 'package:hudayi/ui/widgets/appBar.dart';
import 'package:hudayi/ui/widgets/appLogo.dart';
import 'package:hudayi/ui/widgets/helper.dart';
import 'package:provider/provider.dart';

import '../../ui/helper/AppConsts.dart';

class MainPage extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();

  MainPage({super.key, required this.scaffoldkey});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: "MainPage",
        parameters: {
          'screen_name': "MainPage",
          'screen_class': "main",
        },
      );
      String quranGroup = await PrefUtils.getQuran() ?? "";
      List qurans = quranGroup == "" ? [] : jsonDecode(await PrefUtils.getQuran());

      int i = 0;

      if (isConnected && qurans.isNotEmpty) {
        showLoadingDialog(context);
        for (Map quran in qurans) {
          quran.removeWhere((key, value) => key == "removeItem");
          ApiService().createStudentQuran(quran, jsonDecode(Provider.of<AuthService>(context, listen: false).user.toUser())["token"]);
          i += 1;
        }

        if (i == qurans.length) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(translate(context).upload_success_Quran, style:  TextStyle(fontFamily: getFontName(context))),
            duration: const Duration(milliseconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(12),
          ));
          PrefUtils.removeQuran();
          Navigator.pop(context);
        }
      }
      String sessionGroup = await PrefUtils.getSession() ?? "";
      List sessions = sessionGroup == "" ? [] : jsonDecode(await PrefUtils.getSession());
      int j = 0;
      if (isConnected && sessions.isNotEmpty) {
        showLoadingDialog(context);
        for (Map session in sessions) {
          session.removeWhere((key, value) => key == "removeItem");
          Map result =
              await ApiService().createGroupSession(session, jsonDecode(Provider.of<AuthService>(context, listen: false).user.toUser())["token"]);
          
          Map reult = await ApiService().addSessionPer(result["data"]["id"], session["session_attendances"],
              jsonDecode(Provider.of<AuthService>(context, listen: false).user.toUser())["token"]);

              print("reultreult${reult}");
          j += 1;
        }

        if (j == sessions.length) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(translate(context).upload_success_lessons, style:  TextStyle(fontFamily: getFontName(context))),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(12),
          ));
          PrefUtils.removeSession();
          Navigator.pop(context);
        }
      }
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              firstIcon: Icons.menu,
              firstIconOnTap: () {
                widget.scaffoldkey.currentState!.openDrawer();
              },
              secondIcon: Icons.person,
              secondIconOnTap: () {
                Navigator.of(context).push(createRoute(const Login()));
              },
            ),
            Helper.sizedBoxH15,
            Expanded(
              child: CarouselSlider(
                items: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: AppBorderRadius.timeContainerRadius,
                      image: DecorationImage(
                        image: AssetImage(AppIcons.mosque),
                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.srcOver),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppLogo(height: 175),
                        Helper.sizedBoxH15,
                        Text(
                          localize("organization_name"),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Helper.sizedBoxH15,
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              translate(context).organization_description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height,
                  viewportFraction: 0.85,
                  enableInfiniteScroll: true,
                  reverse: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                ),
              ),
            ),
            Helper.sizedBoxH30,
          ],
        ),
      ),
    );
  }
}
