import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/models/thekr.dart';
import 'package:hudayi/ui/styles/appBoxShadow.dart';
import 'package:hudayi/ui/widgets/athkar_title.dart';
import 'package:hudayi/ui/widgets/close_button.dart';
import 'package:hudayi/ui/widgets/drawer.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Athkar extends StatefulWidget {
  const Athkar({Key? key, required this.thekr}) : super(key: key);
  final Thekr thekr;
  @override
  _AthkarState createState() => _AthkarState();
}

class _AthkarState extends State<Athkar> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<Athkar> {
  @override
  get wantKeepAlive => true;
  late ItemScrollController controller;
  ItemPositionsListener listener = ItemPositionsListener.create();
  late int pagePosition;

  @override
  void initState() {
    () async {
      await FirebaseAnalytics.instance.logEvent(
        name: "azkar_page_${widget.thekr.sectionName}",
        parameters: {
          'screen_name': "azkar_page_${widget.thekr.sectionName}",
          'screen_class': "main",
        },
      );
    }();
    super.initState();

    controller = ItemScrollController();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          widget.thekr.sectionName,
                          textAlign: TextAlign.center,
                          key: ValueKey<String?>(
                            widget.thekr.sectionName,
                          ),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  HudayiCloseButton(color: Theme.of(context).colorScheme.secondary),
                ],
              ),
            ),
          ),
          Expanded(
            child: ScrollablePositionedList.builder(
              key: const ValueKey<String>('list'),
              physics: const AlwaysScrollableScrollPhysics(),
              itemScrollController: controller,
              itemPositionsListener: listener,
              itemCount: widget.thekr.athkar.length,
              addAutomaticKeepAlives: true,
              minCacheExtent: 900,
              padding: const EdgeInsets.only(bottom: 20),
              itemBuilder: (_, int index) {
                return Column(
                  children: [
                    if (widget.thekr.athkar[index]["title"] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: ThekrTitleCard(title: widget.thekr.athkar[index]["title"]),
                      ),
                    Stack(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.thekr.athkar[index]["counter"]--;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                            padding: const EdgeInsets.only(bottom: 50.0, left: 5, right: 5),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [AppBoxShadow.containerBoxShadow],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.thekr.athkar[index]["text"],
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: widget.thekr.athkar[index]["counter"] < 1
                                ? AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.bounceInOut,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).brightness == Brightness.light ? Colors.white : const Color(0xff202b54),
                                        border: Border.all(color: const Color(0xff6f86d6), width: 2),
                                        borderRadius: BorderRadius.circular(50.0)),
                                    width: 45.0,
                                    height: 45.0,
                                    child: const Icon(
                                      Icons.done,
                                      color: Color(0xff58d1ed),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).brightness == Brightness.light ? Colors.white : const Color(0xff202b54),
                                      border: Border.all(
                                          color: Theme.of(context).brightness == Brightness.light ? Colors.grey[400]! : const Color(0xff33477f),
                                          width: 2),
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    width: 45.0,
                                    height: 45.0,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 250),
                                      child: Text(
                                        '${widget.thekr.athkar[index]["counter"]}',
                                        key: ValueKey<int?>(widget.thekr.counter),
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.secondary,
                                          fontSize: 16,
                                          height: 1.25,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
