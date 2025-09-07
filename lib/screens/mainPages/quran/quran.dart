import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hudayi/models/surah.dart';
import 'package:hudayi/screens/mainPages/quran/reading_page.dart';
import 'package:hudayi/ui/helper/AppColors.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/helper/AppIcons.dart';
import 'package:hudayi/ui/helper/StringCasingExtension.dart';
import 'package:hudayi/ui/widgets/animatedHeader.dart';
import 'package:hudayi/ui/widgets/anmiation_card.dart';
import 'package:hudayi/ui/widgets/helper.dart';
import 'package:hudayi/ui/widgets/textfield_container.dart';

class Quran extends StatefulWidget {
  const Quran({super.key});

  @override
  State<Quran> createState() => _QuranState();
}

class _QuranState extends State<Quran> with AutomaticKeepAliveClientMixin<Quran> {
  @override
  bool get wantKeepAlive => true;
  List surahList = [];
  bool isScolled = false;
  ScrollController _controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  getSurahs() async {
    if (surahList.isEmpty) {
      final String response = await rootBundle.loadString('assets/json/surah.json');
      final data = await json.decode(response);
      for (var item in data) {
        setState(() {
          surahList.add(Surah.fromMap(item));
        });
      }
      debugPrint(surahList.length.toString());
    }
  }

  @override
  void initState() {
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: 'quran_main_page',
        parameters: {
          'screen_name': "quran_main_page",
          'screen_class': "main",
        },
      );
    }();
    getSurahs();
    super.initState();
    _controller = ScrollController()
      ..addListener(() {
        if (AppFunctions().scrollListener(_controller, "slow") != null) {
          if (AppFunctions().scrollListener(_controller, "slow") != isScolled) {
            setState(() {
              isScolled = AppFunctions().scrollListener(_controller, "slow");
            });
          }
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: FadeIn(
          animate: true,
          duration: const Duration(seconds: 1),
          child: Column(
            children: [
              AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: !isScolled ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  firstChild: AnimatedHeader(
                    height: 110,
                    text: translate(context).holy_quran,
                  ),
                  secondChild: Container()),
              Expanded(
                child: surahList.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ))
                    : Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Column(
                          children: [
                            Directionality(
                              textDirection: translate(context).localeName == "ar" ? TextDirection.rtl : TextDirection.ltr,
                              child: TextFieldContainer(
                                hintText: translate(context).search,
                                hintTextSize: 14,
                                hintTextColor: Colors.grey,
                                controller: _searchController,
                                fillcolor: Colors.white,
                                errorMsg: "",
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.name,
                                onChanged: (_) {
                                  setState(() {});
                                },
                                suffixIcon: const Icon(
                                  Icons.search,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                controller: _controller,
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  for (Surah item in _searchController.text == ""
                                      ? surahList
                                      : surahList
                                          .where((e) =>
                                              "${translate(context).surah} ${e.arabicName}".contains(_searchController.text.toTitleCase()) ||
                                              "${translate(context).surah} ${e.arabicName}".contains(_searchController.text) ||
                                              "${translate(context).surah} ${e.arabicName}".contains(_searchController.text.toCapitalized()))
                                          .toList())
                                    Stack(
                                      children: [
                                        AnmiationCard(
                                            onTap: () {
                                              FocusManager.instance.primaryFocus?.unfocus();
                                            },
                                            page: GestureDetector(
                                              child: Container(
                                                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                                margin: const EdgeInsets.only(top: 6.0, bottom: 6),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(15),
                                                    border: Border.all(color: AppColors.primary, width: 1)),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                        width:  translate(context).localeName == "ar" ?85:125,
                                                        child: Text(
                                                         translate(context).localeName == "ar" ?  "${translate(context).surah} ${item.arabicName}": "${translate(context).surah} ${item.name}",
                                                          textAlign: TextAlign.right,
                                                        )),
                                                    Helper.sizedBoxW10,
                                                    Image.asset(
                                                      item.revelationPlace == "madinah" ? AppIcons.madinah : AppIcons.mekkah,
                                                      height: 25,
                                                      width: 25,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            displayedPage: SurahPage(surah: item)),
                                        Positioned(
                                            top: 7,
                                            left: 5,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image.asset(
                                                  AppIcons.ayah,
                                                  height: 40,
                                                  color: AppColors.primary,
                                                  width: 40,
                                                ),
                                                Text(
                                                  item.id.toString(),
                                                  style: TextStyle(fontFamily: "quranNumbers", fontSize: item.id.toString().length == 3 ? 6 : 8),
                                                ),
                                              ],
                                            )),
                                        Positioned(
                                            top: 7,
                                            right: 5,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image.asset(
                                                  AppIcons.ayah,
                                                  height: 40,
                                                  color: AppColors.primary,
                                                  width: 40,
                                                ),
                                                Text(
                                                  item.id.toString(),
                                                  style: TextStyle(fontFamily: "quranNumbers", fontSize: item.id.toString().length == 3 ? 6 : 8),
                                                ),
                                              ],
                                            )),
                                      ],
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
      ),
    );
  }
}
