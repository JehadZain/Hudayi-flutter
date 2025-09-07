import 'package:flutter/material.dart';

class Accordion extends StatefulWidget {
  final Widget title;
  final Widget content;
  final bool disableClick;
  bool showContent;
  Accordion({Key? key, required this.title, required this.showContent, required this.content, required this.disableClick}) : super(key: key);
  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [widget.showContent ? Container() : widget.title, widget.showContent ? widget.content : Container()]);
  }
}
