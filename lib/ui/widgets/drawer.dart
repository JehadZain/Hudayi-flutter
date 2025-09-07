import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hudayi/main.dart';
import 'package:hudayi/models/Languageprovider.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/analytics/index.dart';
import 'package:hudayi/screens/drawerPages/activities/activities.dart';
import 'package:hudayi/screens/drawerPages/admins.dart';
import 'package:hudayi/screens/drawerPages/books/books.dart';
import 'package:hudayi/screens/drawerPages/subject/subject.dart';
import 'package:hudayi/screens/filters/teacher_filter.dart';
import 'package:hudayi/screens/filters/student_filter.dart';
import 'package:hudayi/screens/home.dart';
import 'package:hudayi/screens/mainPages/login.dart';
import 'package:hudayi/ui/helper/AppColors.dart';
import 'package:hudayi/ui/helper/AppConstants.dart';
import 'package:hudayi/ui/helper/AppConsts.dart';
import 'package:hudayi/ui/helper/AppDialog.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/widgets/appLogo.dart';
import 'package:hudayi/ui/widgets/helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../screens/drawerPages/acceptence/acceptence.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  var authService;
  Map user = {};

  @override
  void initState() {
    authService = Provider.of<AuthService>(context, listen: false);
    if (authService.user.toUser() != "null") {
      user = jsonDecode(authService.user.toUser());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return user.isEmpty
        ? const Login()
        : SafeArea(
            child: Container(
              width: 300,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x33000000),
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(12)),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Helper.sizedBoxH20,
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                      child: Row(
                        children: [
                          const AppLogo(height: 45),
                          Helper.sizedBoxW10,
                          Text(
                            translate(context).organization_name,
                            style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),

                    Helper.sizedBoxH10,
                    const Divider(
                      height: 12,
                      thickness: 2,
                      color: Color(0xFFE0E3E7),
                    ),
                    // drwerRaw(
                    //     icon: Icons.location_on,
                    //     text: "الخريطة",
                    //     onTap: () {
                    //       Navigator.of(context).pop();
                    //       Navigator.of(context).push(createRoute(const MapPage()));
                    //     }),
                    // drwerRaw(
                    //     icon: Icons.add,
                    //     text: "إضافة",
                    //     onTap: () {
                    //       Navigator.of(context).pop();
                    //       Navigator.of(context).push(createRoute(const AddAll()));
                    //     }),
                    // drwerRaw(
                    //     icon: Icons.login,
                    //     text: "تسجيل الدخول بالحساب الآخر",
                    //     onTap: () async {
                    //       final prefs = await SharedPreferences.getInstance();
                    //       if (prefs.getString('user_2') != null) {
                    //         if (prefs.getBool("is_user_2") != null) {
                    //           bool isUser2 = prefs.getBool("is_user_2")!;
                    //           prefs.setBool('is_user_2', !isUser2);
                    //           Navigator.of(context).pushAndRemoveUntil(
                    //               createRoute(HomeScreen(
                    //                 is_user_2: isUser2,
                    //               )),
                    //               (Route<dynamic> route) => false);
                    //         }
                    //       } else {
                    //         Navigator.of(context).push(createRoute(const Login(is_second_login: true)));
                    //       }
                    //     }),
                    if (user["role"] == "admin")
                      drwerRaw(
                          icon: Icons.local_activity,
                          text: translate(context).types_of_activities,
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(createRoute(const Activites()));
                          }),
                    if (user["role"] == "admin")
                      drwerRaw(
                          icon: Icons.book,
                          text: translate(context).book,
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(createRoute(const Books()));
                          }),
                    if (user["role"] == "admin")
                      drwerRaw(
                          icon: Icons.play_lesson,
                          text: translate(context).subjects,
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(createRoute(const Subjects()));
                          }),
                    if (user["role"] == "admin")
                      drwerRaw(
                          icon: Icons.person,
                          text: translate(context).managers,
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(createRoute(const Admins()));
                          }),
                    if (user["role"] == "admin")
                      drwerRaw(
                          icon: Icons.switch_access_shortcut_sharp,
                          text: translate(context).awaitingApproval,
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(createRoute(const Acceptence()));
                          }),
                    if (user["role"] == "admin")
                      drwerRaw(
                          icon: Icons.manage_search,
                          text: translate(context).statistics,
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(createRoute(const Analytics()));
                          }),

                    if (user["role"] == "admin")
                      drwerRaw(
                          icon: Icons.person_search,
                          text: translate(context).search_filter_student,
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(createRoute(const StudentFilterPage()));
                          }),
                    if (user["role"] == "admin")
                      drwerRaw(
                          icon: Icons.find_in_page,
                          text: translate(context).search_filter_teacher,
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(createRoute(const TeacherFilterPage()));
                          }),

                    drwerRaw(
                        icon: Icons.phone,
                        text: translate(context).contactSupervisor,
                        onTap: () {
                          launchUrl(
                            Uri.parse("https://wa.me/+905370368662"),
                            mode: LaunchMode.externalApplication,
                          );
                        }),
                    drwerRaw(
                        icon: user.isEmpty ? Icons.login : Icons.logout,
                        text: user.isEmpty ? translate(context).log_in : translate(context).logout,
                        onTap: () {
                          if (user.isEmpty) {
                            Navigator.of(context).pushAndRemoveUntil(
                                createRoute(const HomeScreen(
                                  currentIndex: 4,
                                )),
                                (Route<dynamic> route) => false);
                          } else {
                            showCustomDialog(context, translate(context).confirmLogout, AppConstants.appLogo, "logout", () async {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              final prefs = await SharedPreferences.getInstance();
                              prefs.remove('user');
                              Provider.of<AuthService>(context, listen: false).logout();
                              Navigator.of(context).pushAndRemoveUntil(createRoute(const HomeScreen()), (Route<dynamic> route) => false);
                            });
                          }
                        }),
                    drwerRaw(
                        icon: Icons.language,
                        text:translate(context).chooseLanguage,
                        onTap: () => Get.dialog(const ChangeLanguageDialog())),

                    // drwerRaw(
                    //     icon: Icons.language,
                    //     text: "العربية",
                    //     onTap: () async {
                    //       SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                    //       sharedPreferences.setString("language", 'ar');
                    //       var languageProvider = Provider.of<Languageprovider>(context, listen: false);
                    //       languageProvider.setLocale(const Locale("ar"));
                    //       Get.updateLocale((const Locale("ar")));
                    //     }),

                    // drwerRaw(
                    //     icon: Icons.language,
                    //     text: "Turkish",
                    //     onTap: () async {
                    //       SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                    //       sharedPreferences.setString("language", 'tr');
                    //       var languageProvider = Provider.of<Languageprovider>(context, listen: false);
                    //       languageProvider.setLocale(const Locale("tr"));
                    //       Get.updateLocale((const Locale("tr")));
                    //     }),
                    // drwerRaw(
                    //     icon: Icons.logout,
                    //     text: "الخروج من جميع الحسابات",
                    //     onTap: () {
                    //       showCustomDialog(context, "هل أنت متأكد من أنك تريد تسجيل الخروج من التطبيق", AppConstants.appLogo, "logout", () async {
                    //         Navigator.of(context).pop();
                    //         Navigator.of(context).pop();
                    //         final prefs = await SharedPreferences.getInstance();
                    //         prefs.remove('user');
                    //         prefs.remove('user_2');
                    //         Provider.of<AuthService>(context, listen: false).logout();
                    //         Navigator.of(context).pushAndRemoveUntil(createRoute(const HomeScreen()), (Route<dynamic> route) => false);
                    //       });
                    //     }),

                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Divider(
                          height: 12,
                          thickness: 2,
                          color: Color(0xFFE0E3E7),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 0, 8),
                          child: GestureDetector(
                            // onTap: isConnected
                            //     ? () {
                            //         if (user.isEmpty) {
                            //           Navigator.of(context).pushAndRemoveUntil(
                            //               createRoute(const HomeScreen(
                            //                 currentIndex: 4,
                            //               )),
                            //               (Route<dynamic> route) => false);
                            //         } else {
                            //           Navigator.of(context).pop();
                            //           Navigator.of(context).push(createRoute(ProfilePage(
                            //             tabs: user["role"] == "student" ? getStudentTabs( context) : getStudentMainTabs( context),
                            //             pageType: user["role"],
                            //             profileDetails: user,
                            //           )));
                            //         }
                            //       }
                            //     : () {},
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: user.isEmpty
                                      ? const Icon(
                                          Icons.login,
                                          size: 44,
                                          color: Colors.black,
                                        )
                                      : Image.asset(
                                          'assets/images/profile.png',
                                          width: 66,
                                          height: 66,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.isEmpty ? translate(context).log_in : '${user["first_name"]} ${user["last_name"]}',
                                          style: const TextStyle(
                                            color: Color(0xFF101213),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (authService.user.toUser() != "null")
                                          Padding(
                                            padding: const EdgeInsetsDirectional.only(end: 14.0),
                                            child: Text(
                                              user["email"] ?? "",
                                              style: const TextStyle(
                                                color: Color(0xFF57636C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          height: 0,
                          thickness: 2,
                          color: Color(0xFFE0E3E7),
                        ),
                        Container(
                          color: AppColors.primary,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 0, 8),
                            child: GestureDetector(
                              onTap: () {
                                launchUrl(
                                  Uri.parse("https://zaad-tech.com/"),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.only(end: 14.0, top: 2),
                                        child: Text(
                                          translate(context).operatedBy,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.only(end: 14.0, top: 4),
                                        child: Text(
                                          translate(context).appVersion,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class drwerRaw extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function()? onTap;
  const drwerRaw({Key? key, required this.icon, required this.text, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isConnected ? onTap : () {},
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                  child: Container(
                    width: 4,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F4F8),
                    ),
                  ),
                ),
                Icon(
                  icon,
                  color: const Color(0xFF57636C),
                  size: 28,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Color(0xFF57636C),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: translate(context).localeName == "tr" ? "Roboto" : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChangeLanguageDialog extends StatefulWidget {
  const ChangeLanguageDialog({Key? key}) : super(key: key);

  @override
  _ChangeLanguageDialogState createState() => _ChangeLanguageDialogState();
}

class _ChangeLanguageDialogState extends State<ChangeLanguageDialog> {
  String language = Get.locale!.languageCode; // Initialize with the current language

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:Colors.white,
      actionsPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7.0))),
      title: Text(translate(context).chooseLanguage),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            value: "ar",
            groupValue: language,
            title: const Text("العربية"),
            onChanged: (value) {
              setState(() => language = value!);
            },
          ),
          RadioListTile<String>(
            value: "tr",
            groupValue: language,
            title: const Text("Türkçe"),
            onChanged: (value) {
              setState(() => language = value!);
            },
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(translate(context).cancel,
              style: const TextStyle(color: Colors.black)),
        ),
        TextButton(
          onPressed: () async{
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.setString("language", language);
            var languageProvider = Provider.of<Languageprovider>(context, listen: false);
            languageProvider.setLocale( Locale(language));
            Get.updateLocale(( Locale(language)));
            Get.back(); // Close the dialog
          },
          child: Text(translate(context).confirm,
              style: TextStyle(color:Colors.black)),
        ),
      ],
    );
  }
}
