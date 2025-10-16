import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:hudayi/ui/widgets/page_Header.dart';
import 'package:image_picker/image_picker.dart';

class Notes extends StatelessWidget {
  final ScrollController scrollController;
  final Map details;
  const Notes({super.key, required this.scrollController, required this.details});

  @override
  Widget build(BuildContext context) {
    List viewNotesFields = [
      {"type": "text", "value": details["id"].toString(), "title": translate(context).serial_number},
      {"type": "description", "value": details["description"], "title": translate(context).notes},
      {"type": "date", "value": details["date"], "title": translate(context).noteDate},
      {"type": "time", "value": details["type"], "title": translate(context).noteTime},
    ];
    FirebaseAnalytics.instance.logEvent(
      name: 'notes_profile_page',
      parameters: {
        'screen_name': "admin_profile_page",
        'screen_class': "profile",
      },
    );
    return Expanded(
      child: Column(
        children: [
          PageHeader(
            path: XFile(""),
            title: translate(context).noteInformation,
            isCircle: false,
            checkedValue: "noDialog",
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 0, bottom: 4),
            child: TextFieldFor(
                fields: viewNotesFields,
                deleteOnTap: () {},
                galleryOnTap: () {},
                cameraOnTap: () {},
                scrollController: scrollController,
                readOnly: true),
          )),
        ],
      ),
    );
  }
}
