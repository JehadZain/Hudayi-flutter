import 'package:flutter/material.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/ui/helper/app_consts.dart';
import 'package:hudayi/ui/widgets/drawer.dart';
import 'package:hudayi/ui/widgets/page_header.dart';
import 'package:image_picker/image_picker.dart';

class AddAll extends StatelessWidget {
  const AddAll({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      body: SafeArea(
          child: Column(
        children: [
          PageHeader(
            checkedValue: "noDialog",
            path: XFile(" "),
            title: 'إضافة',
            isCircle: false,
          ),
          Expanded(
              child: ListView(children: [
            GestureDetector(
              child: const AddContainer(text: "إضــافة كــتاب"),
              onTap: () {
                Navigator.of(context).push(createRoute(AddPage(
                    englishTitle: "add_all",
                    isEdit: false,
                    fields: [
                      const {"type": "flutterText", "title": "معلومات الطالب"},
                      const {"type": "number", "value": null, "title": "ابحث من خلال رقم الطالب"},
                      const {"type": "flutterText", "title": "معلومات الكتاب"},
                      ...addBookFields
                    ],
                    title: "إضافة كتاب")));
              },
            ),
            GestureDetector(
              child: const AddContainer(text: "إضــافة نشاط"),
              onTap: () {
                Navigator.of(context).push(createRoute(AddPage(
                    englishTitle: "add_all",
                    isEdit: false,
                    fields: [
                      const {"type": "flutterText", "title": "معلومات الطالب"},
                      const {"type": "number", "value": null, "title": "ابحث من خلال رقم الطالب"},
                      const {"type": "flutterText", "title": "معلومات النشاط"},
                      ...addActivityFields
                    ],
                    title: "إضافة نشاط")));
              },
            ),
            GestureDetector(
              child: const AddContainer(text: "إضــافة إنجاز قرآني"),
              onTap: () {
                Navigator.of(context).push(createRoute(AddPage(
                    englishTitle: "add_all",
                    isEdit: false,
                    fields: [
                      const {"type": "flutterText", "title": "معلومات الطالب"},
                      const {"type": "number", "value": null, "title": "ابحث من خلال رقم الطالب"},
                      const {"type": "flutterText", "title": "معلومات الإنجاز القرآني"},
                      ...addQuranFields
                    ],
                    title: "إضافة إنجاز قرآني")));
              },
            ),
            GestureDetector(
              child: const AddContainer(text: "إضــافة مــقابلة"),
              onTap: () {
                Navigator.of(context).push(createRoute(AddPage(
                    englishTitle: "add_all",
                    isEdit: false,
                    fields: [
                      const {"type": "flutterText", "title": "معلومات الطالب"},
                      const {"type": "number", "value": null, "title": "ابحث من خلال رقم الطالب"},
                      const {"type": "flutterText", "title": "معلومات المقابلة"},
                      ...addInterviewFields
                    ],
                    title: "إضافة مقابلة")));
              },
            ),
            GestureDetector(
              child: const AddContainer(text: "إضــافة اخــتبار"),
              onTap: () {
                Navigator.of(context).push(createRoute(AddPage(
                    englishTitle: "add_all",
                    isEdit: false,
                    fields: [
                      const {"type": "flutterText", "title": "معلومات الطالب"},
                      const {"type": "number", "value": null, "title": "ابحث من خلال رقم الطالب"},
                      const {"type": "flutterText", "title": "معلومات الاختبار"},
                      ...addExamFields
                    ],
                    title: "إضافة اخــتبار")));
              },
            ),
            GestureDetector(
              child: const AddContainer(text: "إضــافة درس"),
              onTap: () {
                Navigator.of(context).push(createRoute(AddPage(
                    englishTitle: "add_all",
                    isEdit: false,
                    fields: [
                      const {"type": "flutterText", "title": "معلومات الطالب"},
                      const {"type": "number", "value": null, "title": "ابحث من خلال رقم الطالب"},
                      const {"type": "flutterText", "title": "معلومات الدرس"},
                      ...addLessonFields
                    ],
                    title: "إضافة درس")));
              },
            ),
          ]))
        ],
      )),
    );
  }
}

class AddContainer extends StatelessWidget {
  final String text;
  const AddContainer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 12, bottom: 4),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(14)),
        child: Container(
          height: 81,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 5,
                  color: Color(0x44111417),
                  offset: Offset(0, 2),
                )
              ],
              borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.keyboard_arrow_left_rounded)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
