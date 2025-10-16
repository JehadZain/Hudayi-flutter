import 'package:flutter/material.dart';

class ContainerShadow extends StatelessWidget {
  final Widget? child;
  final double height;
  const ContainerShadow({super.key,  this.child, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * height ,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0x001E2429),
            Color(0xFF1E2429),
          ],
          stops: [0, 1],
          begin: AlignmentDirectional(0, 1),
          end: AlignmentDirectional(0, -3),
        ),
      ),
      child: child,
    );
  }
}
