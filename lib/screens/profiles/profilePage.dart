import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/main.dart';
import 'package:hudayi/screens/profiles/pages/activity.dart';
import 'package:hudayi/screens/profiles/pages/admin.dart';
import 'package:hudayi/screens/profiles/pages/book.dart';
import 'package:hudayi/screens/profiles/pages/class.dart';
import 'package:hudayi/screens/profiles/pages/exam.dart';
import 'package:hudayi/screens/profiles/pages/interview.dart';
import 'package:hudayi/screens/profiles/pages/notes.dart';
import 'package:hudayi/screens/profiles/pages/quran.dart';
import 'package:hudayi/screens/profiles/pages/rate.dart';
import 'package:hudayi/screens/profiles/pages/student.dart';
import 'package:hudayi/screens/profiles/pages/subClass.dart';
import 'package:hudayi/screens/profiles/pages/teacher.dart';
import 'package:hudayi/ui/helper/AppColors.dart';
import 'package:hudayi/ui/helper/AppConsts.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/helper/AppIcons.dart';
import 'package:hudayi/ui/widgets/actionBar.dart';
import 'package:hudayi/ui/widgets/drawer.dart';
import 'package:hudayi/ui/widgets/helper.dart';
import 'package:hudayi/ui/widgets/imageView.dart';

class ProfilePage extends StatefulWidget {
  final List<Widget> tabs;
  final String pageType;
  final Map? profileDetails;
  final bool? isActionBardisabled;

  const ProfilePage({super.key, required this.tabs, required this.pageType, this.profileDetails, this.isActionBardisabled});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  bool get wantKeepAlive => true;
  bool isScolled = false;
  late TabController tabController;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    tabController = TabController(length: widget.tabs.length, vsync: this);
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        if (AppFunctions().scrollListener(scrollController, "slow") != null) {
          if (AppFunctions().scrollListener(scrollController, "slow") != isScolled) {
            isMenueOpended.value = false;
            setState(() {
              isScolled = AppFunctions().scrollListener(scrollController, "slow");
            });
          }
        }
      });
  }

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                if (widget.pageType != "note" && widget.pageType != "quran" && widget.pageType != "exam")
                  AnimatedCrossFade(
                    firstChild: MainContainer(
                        profileDetails: widget.profileDetails ?? {},
                        fullHeight: widget.tabs.isEmpty ? 0.25 : 0.29,
                        tabController: tabController,
                        tabBars: widget.tabs,
                        widget: widget),
                    secondChild: MainContainer(
                        profileDetails: widget.profileDetails ?? {},
                        fullHeight: widget.tabs.isEmpty ? 0.105 : 0.14,
                        tabController: tabController,
                        tabBars: widget.tabs,
                        widget: widget),
                    duration: const Duration(milliseconds: 200),
                    crossFadeState: !isScolled ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  ),
                //Class Page
                if (widget.pageType == "class")
                  ClassProfile(
                      searchController: searchController,
                      scrollController: scrollController,
                      tabController: tabController,
                      details: widget.profileDetails ?? {}),
                //SubClass page
                if (widget.pageType == "subClass")
                  SubClassProfile(
                      searchController: searchController,
                      scrollController: scrollController,
                      tabController: tabController,
                      details: widget.profileDetails ?? {}),
                if (widget.pageType == "student")
                  StudentProfile(
                    searchController: searchController,
                    scrollController: scrollController,
                    tabController: tabController,
                    details: widget.profileDetails ?? {},
                  ),
                if (widget.pageType == "teacher")
                  TeacherProfile(
                    searchController: searchController,
                    scrollController: scrollController,
                    tabController: tabController,
                    details: widget.profileDetails ?? {},
                  ),
                if (widget.pageType == "admin")
                  Admin(
                    searchController: searchController,
                    scrollController: scrollController,
                    tabController: tabController,
                    details: widget.profileDetails ?? {},
                  ),
                if (widget.pageType == "book")
                  Book(
                    scrollController: scrollController,
                    details: widget.profileDetails ?? {},
                  ),
                if (widget.pageType == "activity")
                  Activity(
                    scrollController: scrollController,
                    activityDetails: widget.profileDetails ?? {},
                  ),
                if (widget.pageType == "interview")
                  Interview(
                    scrollController: scrollController,
                    details: widget.profileDetails ?? {},
                  ),
                if (widget.pageType == "exam")
                  Exam(
                    scrollController: scrollController,
                    details: widget.profileDetails ?? {},
                  ),
                if (widget.pageType == "quran")
                  QuranProfile(
                    scrollController: scrollController,
                    details: widget.profileDetails ?? {},
                  ),
                if (widget.pageType == "note")
                  Notes(
                    scrollController: scrollController,
                    details: widget.profileDetails ?? {},
                  ),
                if (widget.pageType == "rate")
                  Rates(
                    scrollController: scrollController,
                    details: widget.profileDetails ?? {},
                  )
              ],
            ),
            if (widget.pageType != "note" && widget.pageType != "quran" && widget.pageType != "exam" && widget.isActionBardisabled == null)
              const Positioned(
                child: ActionBar(
                  menuseItem: [],
                  containerColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MainContainer extends StatelessWidget {
  final double fullHeight;
  final TabController tabController;
  final List<Widget> tabBars;
  final Map profileDetails;
  final ProfilePage widget;
  const MainContainer(
      {Key? key, required this.fullHeight, required this.profileDetails, required this.tabController, required this.tabBars, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * fullHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * fullHeight,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(17), bottomRight: Radius.circular(17)), color: AppColors.primary),
            child: Column(
              mainAxisAlignment: tabBars.isNotEmpty ? MainAxisAlignment.end : MainAxisAlignment.center,
              children: [
                if (tabBars.isEmpty) Helper.sizedBoxH50,
                if (fullHeight != 0.14 && fullHeight != 0.105)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 50.0, bottom: 10, end: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            child: CircleAvatar(
                                radius: 50,
                                backgroundImage: profileDetails["image"] != null
                                    ? CachedNetworkImageProvider(
                                        AppFunctions().getImage(profileDetails["image"]) ?? AppIcons.branchTemp,
                                      )
                                    : AssetImage(widget.pageType == "class" || widget.pageType == "subClass"
                                        ? AppIcons.branchAvatr
                                        : widget.pageType == "teacher" || widget.pageType == "rate"
                                            ? AppIcons.teacherAvatar
                                            //TODO:Change this is equal
                                            : widget.pageType == "student" && widget.profileDetails!["gender"] == translate(context).male
                                                ? AppIcons.studentMaleAvatar
                                                //TODO:Change this is equal
                                                : widget.pageType == "student" && widget.profileDetails!["gender"] == translate(context).female
                                                    ? AppIcons.studentGirlAvatar
                                                    : widget.pageType == "book"
                                                        ? AppIcons.bookAvatar
                                                        : widget.pageType == "admin"
                                                            ? AppIcons.adminAvatar
                                                            : widget.pageType == "interview"
                                                                ? AppIcons.inteviewAvatar
                                                                : widget.pageType == "activity"
                                                                    ? AppIcons.activityAvatar
                                                                    : AppIcons.bookAvatar) as ImageProvider),
                            onTap: () {
                              Navigator.of(context)
                                  .push(createRoute(ImageView(image: AppFunctions().getImage(profileDetails["image"]) ?? AppIcons.branchTemp)));
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profileDetails["name"] ??
                                    "${profileDetails["first_name"] ?? translate(context).name} ${profileDetails["last_name"] ?? "الملف"}",
                                maxLines: 2,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              Text(
                                profileDetails["description"] ?? "",
                                style: TextStyle(
                                    fontSize: profileDetails["description"] == null ? 0 : 14, fontWeight: FontWeight.normal, color: Colors.white),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (tabBars.isNotEmpty)
                  TabBar(
                      tabAlignment: TabAlignment.center,
                      controller: tabController,
                      isScrollable: true,
                      labelColor: const Color(0xFFFFFFFF),
                      unselectedLabelColor: const Color(0XFF7EC9C4),
                      padding: EdgeInsets.zero,
                      indicatorPadding: EdgeInsets.zero,
                      labelPadding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
                      indicatorColor: Colors.white,
                      indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(width: 3.0, color: Colors.white), insets: EdgeInsets.symmetric(horizontal: 10.0)),
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                      tabs: tabBars)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
