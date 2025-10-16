import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/main.dart';
import 'package:hudayi/models/language_provider.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/screens/home.dart';
import 'package:hudayi/screens/profiles/profile_Page.dart';
import 'package:hudayi/services/API/api.dart';
import 'package:hudayi/ui/helper/App_Colors.dart';
import 'package:hudayi/ui/helper/App_Constants.dart';
import 'package:hudayi/ui/helper/App_Consts.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';

import 'package:hudayi/ui/widgets/TextFields/String_Text_Field.dart';
import 'package:hudayi/ui/widgets/animated_Header.dart';
import 'package:hudayi/ui/widgets/helper.dart';
import 'package:hudayi/ui/widgets/no_Internet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final bool? is_second_login;
  const Login({super.key, this.is_second_login});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var authService;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  @override
  void initState() {
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: "Login",
        parameters: {
          'screen_name': "Login",
          'screen_class': "main",
        },
      );
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return authService.user.toUser() != "null" && widget.is_second_login == null
        ? ProfilePage(
            tabs: jsonDecode(authService.user.toUser())["role"] == "student"
                ? getStudentMainTabs(context)
                : jsonDecode(authService.user.toUser())["role"] == "admin" ||
                        jsonDecode(authService.user.toUser())["role"] ==
                            "branch_admin" ||
                        jsonDecode(authService.user.toUser())["role"] ==
                            "property_admin"
                    ? getAdminTabs(context)
                    : getStudentMainTabs(context),
            pageType:
                jsonDecode(authService.user.toUser())["role"] == "admin" ||
                        jsonDecode(authService.user.toUser())["role"] ==
                            "branch_admin" ||
                        jsonDecode(authService.user.toUser())["role"] ==
                            "property_admin"
                    ? "admin"
                    : jsonDecode(authService.user.toUser())["role"],
            isActionBardisabled: true,
            profileDetails: jsonDecode(authService.user.toUser()),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Stack(
                children: [
                  AnimatedHeader(
                    height: 110,
                    text: translate(context).welcome_hidaya_foundation,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      mainAxisAlignment:
                          MediaQuery.of(context).viewInsets.bottom > 0.0
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                      children: [
                        AnimatedCrossFade(
                            duration: const Duration(milliseconds: 300),
                            crossFadeState:
                                MediaQuery.of(context).viewInsets.bottom > 0.0
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                            firstChild: const SizedBox(
                              height: 120,
                              width: 120,
                            ),
                            secondChild:
                                MediaQuery.of(context).viewInsets.bottom > 0.0
                                    ? Container()
                                    : Image.asset(AppConstants.appLogo,
                                        height: 100, width: 100)),
                        Helper.sizedBoxH20,
                        StringTextField(
                          controller: userNameController,
                          title: translate(context).username,
                          readOnly: false,
                          isRequired: true,
                        ),
                        StringTextField(
                            controller: passwordController,
                            title: translate(context).password,
                            readOnly: false,
                            isRequired: true,
                            obscureText: true),
                        Helper.sizedBoxH20,
                        !isConnected
                            ? const NoInternet()
                            : Center(
                                child: GestureDetector(
                                    onTap: () async {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      if (userNameController.text != "" &&
                                          passwordController.text != "") {
                                        if (isConnected) {
                                          showLoadingDialog(context);
                                          Map result = await ApiService().login(
                                              userNameController.text,
                                              passwordController.text);
                                          String status =
                                              result["message"] ?? "";
                                          if (status == "") {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            Map user = {
                                              ...result["data"]["user"],
                                              "token": result["data"]["token"],
                                              "role": result["data"]["role"] ==
                                                      "org_admin"
                                                  ? "admin"
                                                  : result["data"]["role"],
                                              "user_id": result["data"]["user"]
                                                  ["id"],
                                              "id": result["data"][
                                                  "${result["data"]["role"] == "org_admin" || result["data"]["role"] == "property_admin" || result["data"]["role"] == "branch_admin" ? "admin" : result["data"]["role"]}_id"],
                                              "belongs_to_id": result["data"]
                                                          ["role"] ==
                                                      "student"
                                                  ? result["data"]["Belongs_to"]
                                                      ["class_room_id"]
                                                  : result["data"]["role"] ==
                                                          "branch_admin"
                                                      ? result["data"]
                                                              ["Belongs_to"]
                                                          ["branch_id"]
                                                      : result["data"]
                                                              ["Belongs_to"]
                                                          ["property_id"],
                                              "class_room_id": result["data"]
                                                      ["Belongs_to"]
                                                  ["class_room_id"],
                                              "grade_id": result["data"]
                                                  ["Belongs_to"]["grade_id"],
                                            };
                                            if (widget.is_second_login ==
                                                true) {
                                              prefs.setBool('is_user_2', false);
                                              await prefs.setString(
                                                  'user_2', jsonEncode(user));
                                              authService
                                                  .register(jsonEncode(user));
                                            } else {
                                              await prefs.setString(
                                                  'user', jsonEncode(user));
                                              authService
                                                  .register(jsonEncode(user));
                                            }

                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    createRoute(HomeScreen(
                                                      isUser2: widget
                                                          .is_second_login,
                                                    )),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          } else {
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  translate(context)
                                                      .incorrect_username_password,
                                                  style: TextStyle(
                                                      fontFamily: getFontName(
                                                          context))),
                                              duration:
                                                  const Duration(seconds: 1),
                                            ));
                                          }
                                        } else {
                                          setState(() {});
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              translate(context)
                                                  .enter_username_password,
                                              style: TextStyle(
                                                  fontFamily:
                                                      getFontName(context))),
                                          duration: const Duration(seconds: 1),
                                        ));
                                      }
                                    },
                                    child: Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(21)),
                                          color: AppColors.primary,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 3,
                                              color: AppColors.primary,
                                              offset: Offset(0, 0),
                                            )
                                          ],
                                        ),

                                        // minWidth: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4,
                                              bottom: 4,
                                              left: 20,
                                              right: 20),
                                          child: Text(
                                            translate(context).log_in,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ))),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
