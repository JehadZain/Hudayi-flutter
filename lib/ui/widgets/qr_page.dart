import 'package:flutter/material.dart';

class QrPage extends StatelessWidget {
  final String code;
  const QrPage({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                blurRadius: 5,
                color: Color(0x44111417),
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.network("https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=$code}"),
          ),
        ),
      ],
    );
  }
}
