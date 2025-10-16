import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hudayi/l10n/l10n.dart';
import 'package:hudayi/models/language_provider.dart';
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/home.dart';
import 'package:hudayi/services/network_info.dart';
import 'package:hudayi/ui/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hudayi/l10n/app_localizations.dart';
import 'package:hudayi/ui/widgets/custom_scroll_bhaviour.dart';
import 'package:hudayi/ui/widgets/translations.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSizeBytes =
      1024 * 1024 * 300; // 300 MB
  //Paint.enableDithering = true;
  await Firebase.initializeApp();

  Future<String> setLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      final String sysytemLanguage =
          WidgetsBinding.instance.platformDispatcher.locale.languageCode.toString() == "tr" ? "tr" : "ar";
      String language =
          sharedPreferences.getString('language') ?? sysytemLanguage;
      return language == "tr" ? "tr" : "ar";
    } catch (error) {
      return "ar";
    }
  }

  String language = await setLanguage();
  runApp(MyApp(language: language));
}

final isMenueOpended = ValueNotifier<bool>(false);
bool isConnected = true;

class MyApp extends StatefulWidget {
  final String language;
  const MyApp({super.key, required this.language});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
void initState() {
    super
        .initState(); // Moving super.initState() to the top as per best practices

    () async {
      Connectivity connectivity = Connectivity();
      isConnected = await NetworkInfo(connectivity).isConnected();
    
      NetworkInfo(connectivity)
          .onConnectivityChanged
          .listen((List<ConnectivityResult> results) {
        setState(() {
          // Check if any connection type is not none
          isConnected =
              results.any((result) => result != ConnectivityResult.none);
        });
      });
    }();
}
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthService(),
          ),
          ChangeNotifierProvider(
            create: (context) => LanguageProvider(),
          ),
          Provider<FirebaseAnalytics>.value(value: analytics),
          Provider<FirebaseAnalyticsObserver>.value(value: observer),
        ],
        builder: (context, snapshot) {
          return GetMaterialApp(
            translations: Messages(),
            locale: Locale(widget.language),
            navigatorObservers: <NavigatorObserver>[observer],
            fallbackLocale: const Locale("ar"),
            title: 'Hudayi',
            debugShowCheckedModeBanner: false,
            theme: themeLightData(
                getCurrentLocaleCode() == "tr" ? "Roboto" : "PNU"),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: L10n.all,
            builder: (BuildContext context, Widget? child) {
              final MediaQueryData data = MediaQuery.of(context);
              return MediaQuery(
                data: data.copyWith(
                    textScaler: TextScaler.linear(data.textScaler.scale(1) > 1.2
                        ? 1.2
                        : data.textScaler.scale(1))),
                child: ScrollConfiguration(
                  behavior: CustomScrollBehavior(),
                  child: GestureDetector(
                      onTap: () {
                        isMenueOpended.value = false;
                      },
                      child: child!),
                ),
              );
            },
            home: const HomeScreen(),
          );
        });
  }
}
