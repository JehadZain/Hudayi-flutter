import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:hudayi/screens/mainPages/areas.dart';
import 'package:hudayi/screens/mainPages/azkar/main_Azkar.dart';
import 'package:hudayi/screens/mainPages/login.dart';
import 'package:hudayi/screens/mainPages/main.dart';
import 'package:hudayi/screens/mainPages/quran/quran.dart';
import 'package:hudayi/services/API/api.dart';
import 'package:hudayi/ui/helper/App_Colors.dart';
import 'package:hudayi/ui/helper/App_Constants.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:hudayi/ui/helper/App_Icons.dart';
import 'package:hudayi/ui/widgets/bottomBarWidgets/bottom_Bar.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/l10n/app_localizations.dart';
import 'package:hudayi/ui/helper/App_Dialog.dart';
import 'package:hudayi/ui/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  final int? currentIndex;
  final bool? isUser2;
  const HomeScreen({super.key, this.currentIndex, this.isUser2});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AuthService authService;
  Map version = {};
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  late ValueNotifier<int> currentIndex;
  late final PageController myPage;
  @override
  void initState() {
    currentIndex = ValueNotifier<int>(widget.currentIndex ?? 2);
    myPage = PageController(initialPage: widget.currentIndex ?? 2);
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: 'home_page',
        parameters: {
          'screen_name': "home_page",
          'screen_class': "main",
        },
      );

      final prefs = await SharedPreferences.getInstance();
      if (widget.isUser2 == true) {
        if (prefs.getString('user_2') != null) {
          Map user = jsonDecode(prefs.getString('user_2')!);
          authService.register(jsonEncode(user));
          version = await ApiService().checkVersion(
              jsonDecode(authService.user.toUser())["token"], '1.0.1');
          if (version["isCorrectVersion"] == false) {
                if (!mounted) return;

            showCustomDialog(
              
                context,
                translate(context).outdated_version_message,
                AppConstants.appLogo,
                "refresh", () async {
              launchUrl(
                Uri.parse("https://wa.me/+905370368662"),
                mode: LaunchMode.externalApplication,
              );
              return "";
            }, barrierDismissible: false);
          }
        }
      } else {
        if (prefs.getString('user') != null) {
          Map user = jsonDecode(prefs.getString('user')!);
          authService.register(jsonEncode(user));
          version = await ApiService().checkVersion(
              jsonDecode(authService.user.toUser())["token"], '1.3.3');
          if (version["isCorrectVersion"] == false) {
            // ignore: use_build_context_synchronously
                if (!mounted) return;

            showCustomDialog(
              context,
              translate(context).outdated_version_message,
              AppConstants.appLogo,
              "refresh",
              () async {
                launchUrl(
                  Uri.parse("https://wa.me/+905370368662"),
                  mode: LaunchMode.externalApplication,
                );
                return "";
              },
              barrierDismissible: false,
              noOnTap: version["newVersionLink"] == null
                  ? null
                  : () async {
                      launchUrl(
                        Uri.parse(version["newVersionLink"]),
                        mode: LaunchMode.externalApplication,
                      );
                    },
            );
          }
        }
      }
    }();
    super.initState();
  }

  final GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (!key.currentState!.isDrawerOpen &&
            !key.currentState!.isEndDrawerOpen) {
          if (currentIndex.value == 2) {
            showCustomDialog(
                context,
                translate(context).exit_application_confirmation,
                AppConstants.appLogo,
                "exit", () {
              Navigator.of(context).pop();
              SystemNavigator.pop();
            });
            return Future.value(true);
          } else {
            currentIndex.value = 2;
            myPage.jumpToPage(2);

            return Future.value(false);
          }
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        key: key,
        resizeToAvoidBottomInset: false,
        drawer: const DrawerWidget(),
        backgroundColor: AppColors.background,
        body: SafeArea(
            child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: myPage,
          children: [
            const Azkar(),
            const Quran(),
            MainPage(
              scaffoldkey: key,
            ),
            const Areas(),
            const Login(),
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            currentIndex.value = 2;
            myPage.jumpToPage(2);
          },
          backgroundColor: AppColors.primary,
          splashColor: AppColors.secondary,
          tooltip: AppLocalizations.of(context)!.homePage,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              AppIcons.homeFill,
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomBar(
          currentIndex: currentIndex,
          onTap: (int index) async {
            await FirebaseAnalytics.instance.logEvent(
              name: index == 4
                  ? "user_profile"
                  : index == 3
                      ? "lms_enter_page"
                      : index == 1
                          ? "quran_main_page"
                          : index == 0
                              ? "islamic_main_page"
                              : "HomeScreen_$index",
              parameters: {
                'screen_name': index == 4
                    ? "user_profile"
                    : index == 3
                        ? "lms_enter_page"
                        : index == 1
                            ? "quran_main_page"
                            : index == 0
                                ? "islamic_main_page"
                                : "HomeScreen $index",
                'screen_class': "main",
              },
            );
            myPage.jumpToPage(index);
          },
          fabLocation: FloatingActionButtonLocation.centerDocked,
          shape: const CircularNotchedRectangle(),
        ),
      ),
    );
  }
}
