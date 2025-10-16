import 'package:flutter/material.dart';

class Accordion extends StatefulWidget {
  final Widget title;
  final Widget content;
  final bool disableClick;
  final bool showContent;
  const Accordion(
      {super.key,
      required this.title,
      required this.showContent,
      required this.content,
      required this.disableClick});
  @override
  AccordionState createState() => AccordionState();
}

class AccordionState extends State<Accordion> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      widget.showContent ? Container() : widget.title,
      widget.showContent ? widget.content : Container()
    ]);
  }
}
