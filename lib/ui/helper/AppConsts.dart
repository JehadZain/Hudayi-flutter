import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/widgets/tabBarContainer.dart';
import 'package:image_picker/image_picker.dart';

enum HudayiCategory { athkar, quraan, sunnah, ruqiya, allahname }

const Map<HudayiCategory, String> categoryTitle = <HudayiCategory, String>{
  HudayiCategory.athkar: 'الأذكار',
  HudayiCategory.quraan: 'أدعية من القرآن الكريم',
  HudayiCategory.sunnah: 'أدعية من السنة النبوية',
  HudayiCategory.ruqiya: 'الرقية الشرعية',
  HudayiCategory.allahname: 'أسماء الله الحسنى',
};

class Titles {
  static const String quraan = 'أدعية من القرآن الكريم';
  static const String sunnah = 'أدعية من السنة النبوية';
  static const String ruqya = 'الرقية الشرعية';
}

List<Widget> getMosqueLoginedTabsBranchDetails(BuildContext context) {
  List<Widget> mosqueLoginedTabsBranchDetails = [
    Tab(
      child: TabBarContainer(
        title: translate(context).description,
        onlyText: false,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).levels,
        onlyText: false,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).students,
        onlyText: false,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).teachers,
        onlyText: false,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).statistics,
        onlyText: false,
      ),
    ),
  ];
  return mosqueLoginedTabsBranchDetails;
}

List<Widget> getLoginedTabsBranchDetails(BuildContext context) {
  List<Widget> loginedTabsBranchDetails = [
    Tab(
      child: TabBarContainer(
        title: translate(context).description,
        onlyText: false,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).classes,
        onlyText: false,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).students,
        onlyText: false,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).teachers,
        onlyText: false,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).statistics,
        onlyText: false,
      ),
    ),
  ];
  return loginedTabsBranchDetails;
}

List<Widget> getClassTabs(BuildContext context) {
  List<Widget> classTabs = [
    Tab(
      child: TabBarContainer(
        title: translate(context).statistics,
        onlyText: true,
      ),
    ),
  ];
  return classTabs;
}

List<Widget> getStudentTabs(BuildContext context) {
  List<Widget> studentTabs = [
    Tab(
      child: TabBarContainer(
        title: translate(context).information,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).quran,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).interviews,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).book,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).lessons,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).lessonsMissed,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).events,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).eventsMissed,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).notes,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).exams,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).statistics,
        onlyText: true,
      ),
    ),
  ];
  return studentTabs;
}

List<Widget> getStudentMainTabs(BuildContext context) {
  List<Widget> studentMainTabs = [
    Tab(
      child: TabBarContainer(
        title: translate(context).information,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).quran,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).book,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).lessons,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).lessonsMissed,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).events,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).eventsMissed,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).exams,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).statistics,
        onlyText: true,
      ),
    ),
  ];
  return studentMainTabs;
}

List<Widget> getTeacherTabs(BuildContext context) {
  List<Widget> teacherTabs = [
    Tab(
      child: TabBarContainer(
        title: translate(context).information,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).teacherClasses,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).book,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).interviews,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).exams,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).quran,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).notes,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).statistics,
        onlyText: true,
      ),
    ),
  ];
  return teacherTabs;
}

List<Widget> getTeacherTabsWithRreviews(BuildContext context) {
  List<Widget> teacherTabsWithRreviews = [
    Tab(
      child: TabBarContainer(
        title: translate(context).information,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).teacherClasses,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).book,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).interviews,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).exams,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).quran,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).notes,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).evaluations,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).statistics,
        onlyText: true,
      ),
    ),
  ];
  return teacherTabsWithRreviews;
}

List<Widget> getAdminTabs(BuildContext context) {
  List<Widget> adminTabs = [
    Tab(
      child: TabBarContainer(
        title: translate(context).information,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).ratings,
        onlyText: true,
      ),
    ),
  ];
  return adminTabs;
}

List<Widget> getSubClassTabs(BuildContext context) {
  List<Widget> subClassTabs = [
    Tab(
      child: TabBarContainer(
        title: translate(context).members,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).lessons,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).events,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).schedule,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).book,
        onlyText: true,
      ),
    ),
    Tab(
      child: TabBarContainer(
        title: translate(context).statistics,
        onlyText: true,
      ),
    ),
  ];
  return subClassTabs;
}

//Maps
Map getMarks(BuildContext context) {
  Map marks = {
    "100": translate(context).excellent,
    "75": translate(context).veryGood,
    "50": translate(context).good,
    "25": translate(context).average,
    "0": translate(context).fail,
  };
  return marks;
}

Map getmMrksWords(BuildContext context) {
  Map marksWords = {
    translate(context).excellent: "100",
    translate(context).veryGood: "75",
    translate(context).good: "50",
    translate(context).average: "25",
    translate(context).fail: "0",
  };
  return marksWords;
}

//fields

List addAreaFields = [
  {"type": "text", "value": null, "title": translate(Get.context!).regionName},
];

List addBranchFields = [
  {"type": "text", "value": null, "title": translate(Get.context!).name},
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).description
  },
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).type,
    "selections": [
      translate(Get.context!).school,
      translate(Get.context!).mosque
    ]
  },
  {
    "type": "number",
    "value": null,
    "title": translate(Get.context!).phoneNumber
  },
  {
    "type": "text",
    "value": null,
    "title": translate(Get.context!).email_address
  },
  {"type": "number", "value": null, "title": translate(Get.context!).whatsapp},
  {"type": "text", "value": null, "title": translate(Get.context!).instagram},
  {"type": "text", "value": null, "title": translate(Get.context!).facebook},
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).schoolLocationDescription
  },
  {
    "type": "image",
    "value": XFile(""),
    "title": translate(Get.context!).branchPhoto,
    "multiple": false
  },
];

//Example
List addClassFields = [
  {"type": "text", "value": null, "title": translate(Get.context!).name},
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).description
  },
];

String getStatusValue(BuildContext context, String? value) {
  if (value == "1") {
    return translate(context).active;
  } else if (value == "0") {
    return translate(context).inactive;
  } else {
    return translate(context).not_available;
  }
}

String getStatusKey(BuildContext context, String? value) {
  if (value == translate(context).active) {
    return "1";
  } else {
    return "0";
  }
}

String getYesOrNoKey(BuildContext context, String? value) {
  if (value == translate(context).yes) {
    return "1";
  } else {
    return "0";
  }
}

String getYesOrNoValue(BuildContext context, String? value) {
  if (value == "1") {
    return translate(context).yes;
  } else if (value == "0") {
    return translate(context).no;
  } else {
    return translate(context).not_available;
  }
}

String getGenderValue(BuildContext context, String? value) {
  if (value == "male") {
    return translate(context).male;
  } else if (value == "female") {
    return translate(context).female;
  } else {
    return translate(context).not_available;
  }
}

String getMarriedValue(BuildContext context, String? value) {
  if (value == "single") {
    return translate(context).single;
  } else if (value == "married") {
    return translate(context).married;
  } else if (value == "widow") {
    return translate(context).widow;
  } else {
    return translate(context).not_available;
  }
}

String getMarriedKey(BuildContext context, String? value) {
  if (value == translate(context).single) {
    return "single";
  } else if (value == translate(context).married) {
    return "married";
  } else {
    return "widow";
  }
}

String getGenderKey(BuildContext context, String? value) {
  if (value == translate(context).male) {
    return "male";
  } else {
    return "female";
  }
}

List addStudentsFields = [
  {
    "type": "flutterText",
    "title": translate(Get.context!).addGeneralStudentInformation
  },
  {"type": "text", "value": null, "title": translate(Get.context!).username},
  {
    "isRequired": false,
    "type": "text",
    "value": null,
    "title": translate(Get.context!).password
  },
  {"type": "text", "value": null, "title": translate(Get.context!).first_name},
  {"type": "text", "value": null, "title": translate(Get.context!).surname},
  {"type": "text", "value": null, "title": translate(Get.context!).father_name},
  {"type": "text", "value": null, "title": translate(Get.context!).mother_name},
  {
    "type": "date",
    "value": null,
    "title": translate(Get.context!).date_of_birth
  },
  //TODO:translate
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).type,
    "selections": [translate(Get.context!).female, translate(Get.context!).male]
  },
  {
    "isRequired": false,
    "type": "number",
    "value": null,
    "title": translate(Get.context!).parentPhoneNumber
  },
  {
    "isRequired": false,
    "type": "number",
    "value": null,
    "title": translate(Get.context!).student_phone_number
  },
  {
    "isRequired": false,
    "type": "number",
    "value": null,
    "title": translate(Get.context!).national_id_number
  },
  {
    "type": "text",
    "value": null,
    "title": translate(Get.context!).place_of_birth
  },
  {
    "isRequired": false,
    "type": "text",
    "value": null,
    "title": translate(Get.context!).email_address
  },
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).student_status,
    "selections": [
      translate(Get.context!).inactive,
      translate(Get.context!).active
    ]
  },
  {
    "type": "image",
    "value": XFile(""),
    "title": translate(Get.context!).studentPhoto,
    "multiple": false
  },
  {
    "type": "image",
    "value": [XFile("")],
    "title": translate(Get.context!).certificatePhotos,
    "multiple": true,
    "hide": true,
  },
  {
    "type": "flutterText",
    "title": translate(Get.context!).addPrivateStudentInformation
  },
  {
    "type": "text",
    "value": null,
    "title": translate(Get.context!).currentPlaceOfResidence
  },
  {
    "isRequired": false,
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).blood_type,
    "selections": ["A+", "A-", "B+", "B-", "O+", "O-", "-AB", "+AB"]
  },
  {
    "type": "number",
    "value": null,
    "title": translate(Get.context!).familyMembersCount
  },
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).is_chronic_illness,
    "selections": [translate(Get.context!).no, translate(Get.context!).yes]
  },
  {
    "isRequired": false,
    "type": "text",
    "value": null,
    "title": translate(Get.context!).treatment
  },
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).treatment_available,
    "selections": [translate(Get.context!).no, translate(Get.context!).yes]
  },
  {
    "isRequired": false,
    "type": "text",
    "value": null,
    "title": translate(Get.context!).treatment
  },
  {"type": "text", "value": null, "title": translate(Get.context!).guardian},
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).family_chronic_illness,
    "selections": [translate(Get.context!).no, translate(Get.context!).yes]
  },
  {
    "isRequired": false,
    "type": "text",
    "value": null,
    "title": translate(Get.context!).treatment
  },
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).isStudentOrphan,
    "selections": [translate(Get.context!).no, translate(Get.context!).yes]
  },
];

List addTeachersFields = [
  {
    "type": "flutterText",
    "title": translate(Get.context!).addGeneralTeacherInformation
  },
  {"type": "text", "value": null, "title": translate(Get.context!).username},
  {
    "isRequired": false,
    "type": "text",
    "value": null,
    "title": translate(Get.context!).password
  },
  {"type": "text", "value": null, "title": translate(Get.context!).first_name},
  {"type": "text", "value": null, "title": translate(Get.context!).surname},
  {"type": "text", "value": null, "title": translate(Get.context!).father_name},
  {"type": "text", "value": null, "title": translate(Get.context!).mother_name},
  {
    "type": "date",
    "value": null,
    "title": translate(Get.context!).date_of_birth
  },
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).type,
    "selections": [translate(Get.context!).female, translate(Get.context!).male]
  },
  {
    "type": "number",
    "value": null,
    "title": translate(Get.context!).phoneNumber
  },
  {
    "type": "number",
    "value": null,
    "title": translate(Get.context!).national_id_number
  },
  {
    "type": "text",
    "value": null,
    "title": translate(Get.context!).place_of_birth
  },
  {
    "type": "text",
    "value": null,
    "title": translate(Get.context!).email_address
  },
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).teacherStatus,
    "selections": [
      translate(Get.context!).inactive,
      translate(Get.context!).active
    ]
  },
  {
    "type": "image",
    "value": XFile(""),
    "title": translate(Get.context!).teacherPhoto,
    "multiple": false
  },
  {
    "type": "image",
    "value": [XFile("")],
    "title": translate(Get.context!).certificatePhotos,
    "multiple": true,
    "hide": true,
  },
  {
    "type": "flutterText",
    "title": translate(Get.context!).addPrivateTeacherInformation
  },
  {
    "type": "text",
    "value": null,
    "title": translate(Get.context!).currentPlaceOfResidence
  },
  {
    "type": "oneSelection",
    "value": null,
    "isRequired": false,
    "title": translate(Get.context!).blood_type,
    "selections": ["A+", "A-", "B+", "B-", "O+", "O-", "-AB", "+AB"]
  },
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).marital_status,
    "selections": [
      translate(Get.context!).single,
      translate(Get.context!).married,
      translate(Get.context!).widow
    ]
  },
  {
    "isRequired": false,
    "type": "number",
    "value": null,
    "title": translate(Get.context!).wivesCount
  },
  {
    "isRequired": false,
    "type": "number",
    "value": null,
    "title": translate(Get.context!).number_of_children
  },
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).is_chronic_illness,
    "selections": [translate(Get.context!).no, translate(Get.context!).yes]
  },
  {
    "isRequired": false,
    "type": "text",
    "value": null,
    "title": translate(Get.context!).treatment
  },
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).treatment_available,
    "selections": [translate(Get.context!).no, translate(Get.context!).yes]
  },
  {
    "isRequired": false,
    "type": "text",
    "value": null,
    "title": translate(Get.context!).treatment
  },
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).householdChronicIllness,
    "selections": [translate(Get.context!).no, translate(Get.context!).yes]
  },
  {
    "isRequired": false,
    "type": "text",
    "value": null,
    "title": translate(Get.context!).treatment
  },
];

List addSubjectFields = [
  {"type": "text", "value": null, "title": translate(Get.context!).subjectName},
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).subjectDescription
  },
];

String getBookTypeKey(BuildContext context, String? value) {
  if (value == translate(Get.context!).methodological) {
    return "methodological";
  } else {
    return "cultural";
  }
}

String getBookTypeValue(BuildContext context, String? value) {
  if (value == "methodological") {
    return translate(context).methodological;
  } else if (value == "cultural") {
    return translate(context).cultural;
  } else {
    return translate(context).not_available;
  }
}

List addBookFields = [
  {"type": "text", "value": null, "title": translate(Get.context!).book_name},
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).book_size,
    "selections": ["A4", "A5"]
  },
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).bookType,
    "selections": [
      translate(Get.context!).cultural,
      translate(Get.context!).methodological
    ]
  },
  {"type": "text", "value": null, "title": translate(Get.context!).book_author},
  {
    "type": "number",
    "value": null,
    "title": translate(Get.context!).book_pages_count
  },
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).center_type,
    "selections": [
      translate(Get.context!).school,
      translate(Get.context!).mosque
    ]
  },
  {
    "type": "image",
    "value": XFile(""),
    "title": translate(Get.context!).bookCover,
    "multiple": false
  },
];

List addActivtyType = [
  {
    "type": "text",
    "value": null,
    "title": translate(Get.context!).activityTypeName
  },
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).activityTypeDescription
  },
  {
    "type": "text",
    "value": null,
    "title": translate(Get.context!).activityTypeGoal
  },
];

List addActivityFields = [
  {
    "type": "text",
    "value": null,
    "title": translate(Get.context!).activity_name
  },
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).activity_description
  },
  {
    "type": "text",
    "value": null,
    "title": translate(Get.context!).activityLocation
  },
  {
    "type": "date",
    "value": null,
    "title": translate(Get.context!).activity_date
  },
  {
    "type": "number",
    "value": null,
    "title": translate(Get.context!).activity_cost
  },
  {
    "type": "image",
    "value": XFile(""),
    "title": translate(Get.context!).activityPhoto,
    "multiple": false
  },
];

List addReportFields = [
  {
    "type": "flutterText",
    "title": translate(Get.context!).weeklyEducationalReport
  },
  {"type": "text", "value": null, "title": translate(Get.context!).place},
  {"type": "date", "value": null, "title": translate(Get.context!).startDate},
  {"type": "date", "value": null, "title": translate(Get.context!).endDate},
  {
    "type": "text",
    "value": null,
    "title": translate(Get.context!).responsiblePerson
  },
  {
    "type": "number",
    "value": null,
    "title": translate(Get.context!).activity_cost
  },
  {"type": "flutterText", "title": translate(Get.context!).educationalTopics},
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).educationalTopics
  },
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).teacherRelatedTopics
  },
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).curriculumRelatedTopics
  },
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).studentRelatedTopics
  },
  {
    "type": "flutterText",
    "title": translate(Get.context!).activityAndEventTopics
  },
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).activityAndEventTopics
  },
  {
    "type": "flutterText",
    "title": translate(Get.context!).guestsAndOfficialFiguresTopics
  },
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).guestsAndOfficialFiguresTopics
  },
  {"type": "flutterText", "title": translate(Get.context!).needsAndLogistics},
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).needsAndLogistics
  },
  {"type": "flutterText", "title": translate(Get.context!).postponedTopics},
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).postponedTopics
  },
  {
    "type": "image",
    "value": XFile(""),
    "title": translate(Get.context!).reportImage,
    "multiple": false
  },
];

List addSubClassFields = [
  {"type": "text", "value": null, "title": translate(Get.context!).name},
  {"type": "number", "value": null, "title": translate(Get.context!).capacity},
  {
    "type": "image",
    "value": XFile(""),
    "title": translate(Get.context!).sectionPhoto,
    "multiple": false
  },
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).description
  },
];

List addLessonFields = [
  {"type": "text", "value": null, "title": translate(Get.context!).lessonName},
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).lessonDescription
  },
  {"type": "text", "value": null, "title": translate(Get.context!).lessonplace},
  {"type": "date", "value": null, "title": translate(Get.context!).lessonDate},
  {"type": "time", "value": null, "title": translate(Get.context!).lessonTime},
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).lessonDuration,
    "selections": ["90", "60", "30"]
  },
];

List addBookInterviewFields = [
  {
    "type": "text",
    "value": null,
    "title": translate(Get.context!).interviewReason
  },
  {
    "type": "text",
    "value": null,
    "title": translate(Get.context!).interviewPlace
  },
  {
    "type": "date",
    "value": null,
    "title": translate(Get.context!).interviewDate
  },
  {
    "type": "time",
    "value": null,
    "title": translate(Get.context!).interviewTime
  },
  {
    "type": "text",
    "value": null,
    "title": translate(Get.context!).interviewResult
  },
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).bookSummary
  },
  {
    "type": "image",
    "value": XFile(""),
    "title": translate(Get.context!).summaryImage,
    "multiple": false
  },
];

String getInterviewTypeKey(BuildContext context, String? value) {
  return "pedagogical";
}

String getInterviewTypeValue(BuildContext context, String? value) {
  if (value == "pedagogical") {
    return translate(context).pedagogical;
  } else {
    return translate(context).not_available;
  }
}

List addInterviewFields = [
  {
    "type": "text",
    "value": null,
    "title": translate(Get.context!).interviewName
  },
  {
    "type": "text",
    "value": null,
    "title": translate(Get.context!).interviewReason
  },
  {
    "type": "text",
    "value": null,
    "title": translate(Get.context!).interviewPlace
  },
  {
    "type": "date",
    "value": null,
    "title": translate(Get.context!).interviewDate
  },
  {
    "type": "time",
    "value": null,
    "title": translate(Get.context!).interviewTime
  },
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).interviewType,
    "selections": [translate(Get.context!).pedagogical]
  },
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).interviewResult
  },
  {
    "type": "number",
    "value": null,
    "title": translate(Get.context!).interviewGrade
  },
];

String getQuizTypeKey(BuildContext context, String? value) {
  if (value == translate(Get.context!).quran) {
    return "quran";
  } else if (value == translate(Get.context!).correctArabicReading) {
    return "correctArabicReading";
  } else {
    return "curriculum";
  }
}

String getQuizTypeValue(BuildContext context, String? value) {
  if (value == "quran") {
    return translate(context).quran;
  } else if (value == "curriculum") {
    return translate(context).curriculum;
  } else if (value == "correctArabicReading") {
    return translate(context).correctArabicReading;
  } else {
    return translate(context).not_available;
  }
}

List addExamFields = [
  {"type": "text", "value": null, "title": translate(Get.context!).testName},
  {"type": "text", "value": null, "title": translate(Get.context!).testSubject},
  {"type": "date", "value": null, "title": translate(Get.context!).testDate},
  {"type": "time", "value": null, "title": translate(Get.context!).testTime},
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).testType,
    "selections": [
      translate(Get.context!).quran,
      translate(Get.context!).curriculum,
      translate(Get.context!).correctArabicReading
    ]
  },
  {"type": "number", "value": null, "title": translate(Get.context!).testGrade},
];

String getExamTypeKey(BuildContext context, String? value) {
  if (value == translate(Get.context!).memorization) {
    return "memorization";
  } else if (value == translate(Get.context!).recitationFromQuran) {
    return "recitationFromQuran";
  } else {
    return "correctArabicReading";
  }
}

String getExamTypeValue(BuildContext context, String? value) {
  if (value == "memorization") {
    return translate(context).memorization;
  } else if (value == "recitationFromQuran") {
    return translate(context).recitationFromQuran;
  } else if (value == "correctArabicReading") {
    return translate(context).correctArabicReading;
  } else {
    return translate(context).not_available;
  }
}

List addQuranFields = [
  {
    "type": "multipleSelectionQuranJuz",
    "value": null,
    "title": translate(Get.context!).juz,
    "selections": [
      translate(Get.context!).correctArabicReading,
      ...List<int>.generate(30, (i) => i + 1)
    ]
  },
  {
    "type": "multipleSelectionQuranPages",
    "value": null,
    "title": translate(Get.context!).page,
    "selections": []
  },
  {
    "type": "date",
    "value": null,
    "title": translate(Get.context!).recitationDate
  },
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).recitationType,
    "selections": [
      translate(Get.context!).memorization,
      translate(Get.context!).recitationFromQuran,
      translate(Get.context!).correctArabicReading
    ]
  },
  {
    "type": "oneSelection",
    "value": null,
    "title": translate(Get.context!).recitationGrade,
    "selections": [
      translate(Get.context!).excellent,
      translate(Get.context!).veryGood,
      translate(Get.context!).good,
      translate(Get.context!).average,
      translate(Get.context!).fail
    ]
  },
];

List addNotesFields = [
  {
    "type": "description",
    "value": null,
    "title": translate(Get.context!).addNote
  },
  {
    "type": "date",
    "value": null,
    "title": translate(Get.context!).observationDate
  },
  {
    "type": "time",
    "value": null,
    "title": translate(Get.context!).observationTime
  },
];

List addRatingFields = [
  {"type": "flutterText", "title": translate(Get.context!).teachersEvaluation},
  {
    "isRequired": false,
    "type": "text",
    "value": null,
    "title": translate(Get.context!).teacherCount,
    "readOnly": true
  },
  {
    "isRequired": false,
    "type": "text",
    "value": null,
    "title": translate(Get.context!).teacherName,
    "readOnly": true
  },
  //{"type": "text", "hide": true, "value": null, "title": "عدد الطلاب", "readOnly": true},
  {
    "isRequired": false,
    "type": "text",
    "value": null,
    "title": translate(Get.context!).observer,
    "readOnly": true
  },
  {
    "isRequired": false,
    "type": "date",
    "value": null,
    "title": translate(Get.context!).date
  },
  {
    "isRequired": false,
    "type": "flutterText",
    "title": translate(Get.context!).visitTime
  },
  {"type": "time", "value": null, "title": translate(Get.context!).start_time},
  {"type": "time", "value": null, "title": translate(Get.context!).end_time},
  {
    "isRequired": false,
    "type": "flutterText",
    "title": translate(Get.context!).lessons
  },
  {
    "isRequired": false,
    "type": "number",
    "value": null,
    "title": translate(Get.context!).arabicReadingGradeOutOf10
  },
  {
    "isRequired": false,
    "type": "number",
    "value": null,
    "title": translate(Get.context!).recitationTeachingGradeOutOf10
  },
  {
    "isRequired": false,
    "type": "number",
    "value": null,
    "title": translate(Get.context!).scientificLessonGradeOutOf10
  },
  {
    "isRequired": false,
    "type": "number",
    "value": null,
    "title": translate(Get.context!).individualFollowUpTimeGradeOutOf10
  },
  {
    "isRequired": false,
    "type": "flutterText",
    "title": translate(Get.context!).circleManagement
  },
  {
    "isRequired": false,
    "type": "number",
    "value": null,
    "title": translate(Get.context!).planCommitmentGradeOutOf10
  },
  {
    "isRequired": false,
    "type": "number",
    "value": null,
    "title": translate(Get.context!).punctualityGradeOutOf10
  },
  {
    "isRequired": false,
    "type": "number",
    "value": null,
    "title": translate(Get.context!).studentDisciplineGradeOutOf10
  },
  {
    "isRequired": false,
    "type": "flutterText",
    "title": translate(Get.context!).activities
  },
  {
    "isRequired": false,
    "type": "number",
    "value": null,
    "title": translate(Get.context!).activitiesGradeOutOf10
  },
  {
    "isRequired": false,
    "type": "flutterText",
    "title": translate(Get.context!).administrativeDiscipline
  },
  {
    "isRequired": false,
    "type": "number",
    "value": null,
    "title": translate(Get.context!).administrativeDisciplineGradeOutOf10
  },
  {
    "isRequired": false,
    "type": "flutterText",
    "title": translate(Get.context!).exams
  },
  {
    "isRequired": false,
    "type": "number",
    "value": null,
    "title": translate(Get.context!).testandstudies
  },
  {
    "isRequired": false,
    "type": "flutterText",
    "title": translate(Get.context!).notes
  },
  {
    "isRequired": false,
    "type": "description",
    "value": null,
    "title": translate(Get.context!).notes
  },
  {
    "isRequired": false,
    "type": "number",
    "value": null,
    "title": translate(Get.context!).studentsAttendingCount
  },
];

//Route option
Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0, 1);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
