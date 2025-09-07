import 'package:flutter/material.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';

class NoData extends StatelessWidget {
  const NoData({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Text(
       translate(context).noDataAvailable,
      style:const TextStyle(fontSize: 22),
    ));
  }
}
