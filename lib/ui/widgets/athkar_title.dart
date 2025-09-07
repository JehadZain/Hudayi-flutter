import 'package:flutter/material.dart';
import 'package:hudayi/ui/helper/AppIcons.dart';

class ThekrTitleCard extends StatelessWidget {
  const ThekrTitleCard({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
            ),
          ],
          borderRadius: BorderRadius.circular(15.0),
          image: const DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(AppIcons.titleBg),
          )),
      child: Container(
        height: 95,
        alignment: Alignment.center,
        child: Text(
          title!,
          textAlign: TextAlign.center,
          overflow: TextOverflow.clip,
          style: const TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }
}
