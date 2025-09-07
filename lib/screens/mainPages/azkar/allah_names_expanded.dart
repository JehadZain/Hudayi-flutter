import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/models/allah_name.dart';
import 'package:hudayi/ui/styles/appBoxShadow.dart';
import 'package:hudayi/ui/widgets/athkar_title.dart';
import 'package:hudayi/ui/widgets/close_button.dart';
import 'package:hudayi/ui/widgets/drawer.dart';
import 'package:hudayi/ui/widgets/helper.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AllahNamesList extends StatefulWidget {
  const AllahNamesList({
    Key? key,
    this.index = 0,
    required this.allahNames,
  }) : super(key: key);
  final int index;
  final List allahNames;
  @override
  _AllahNamesListState createState() => _AllahNamesListState();
}

class _AllahNamesListState extends State<AllahNamesList> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<AllahNamesList> {
  @override
  get wantKeepAlive => true;
  ItemScrollController? controller;
  ItemPositionsListener listener = ItemPositionsListener.create();
  late Animation<double> animation;
  late AnimationController animationController;
  late int pagePosition;

  @override
  void initState() {
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: "allah_names_${widget.allahNames[pagePosition].name}",
        parameters: {
          'screen_name': "allah_names_${widget.allahNames[pagePosition].name}",
          'screen_class': "main",
        },
      );
    }();
    super.initState();
    pagePosition = widget.index;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listener.itemPositions.addListener(changeAppBar);
    });

    animationController = AnimationController(vsync: this);
    animation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticIn),
    );
    controller = ItemScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  changeAppBar() {
    if (pagePosition != listener.itemPositions.value.first.index) {
      setState(() {
        pagePosition = listener.itemPositions.value.first.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(width: 45),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      widget.allahNames[pagePosition].name,
                      textAlign: TextAlign.center,
                      key: ValueKey<String?>(
                        widget.allahNames[pagePosition].name,
                      ),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  HudayiCloseButton(color: Theme.of(context).colorScheme.secondary),
                ],
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: ScrollablePositionedList.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemScrollController: controller,
                itemPositionsListener: listener,
                itemCount: widget.allahNames.length,
                addAutomaticKeepAlives: true,
                initialScrollIndex: widget.index,
                padding: const EdgeInsets.only(bottom: 20),
                itemBuilder: (_, int index) {
                  final AllahName name = widget.allahNames[index];

                  List<String> textList = name.text.split('.');
                  textList = textList.map((String e) => e.trim()).toList();

                  return Column(
                    children: [
                      ThekrTitleCard(
                        title: name.name,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [AppBoxShadow.containerBoxShadow],
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${textList[0]}.',
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(fontSize: 20, color: Colors.black),
                              ),
                              Helper.sizedBoxH15,
                              Text(
                                '${textList[1]}.',
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
// Column(
//                     children: <Widget>[
//                       NameTitleCard(title: name.name),
//                       CardTemplate(
//                         ribbon: Ribbon.ribbon6,
//                         additionalContent: name.inApp ? backToMainLocation(name) : null,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             CardText(text: textList[0] + '.'),
//                             const SizedBox(height: 10),
//                             CardText(text: textList[1] + '.'),
//                           ],
//                         ),
//                         actions: <Widget>[FavAction(name), CopyAction('اسم الله (${name.name}): ${name.text}')],
//                       ),
//                     ],
//                   );