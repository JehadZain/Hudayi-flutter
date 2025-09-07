import 'package:flutter/material.dart';

class CirculeProgress extends StatelessWidget {
  const CirculeProgress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
