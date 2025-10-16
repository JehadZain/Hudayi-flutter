import 'dart:math';
import 'package:hudayi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AppFunctions {
  final _random = Random();
  int next(int min, int max) => min + _random.nextInt(max - min);

  getImage(String? image) {
    return image == null || image == "" ? null : "https://www.hidayetnuru.org/${image.toString().replaceAll("public", "storage")}";
  }

  static Future<XFile> getImageXFileByUrl(String? url) async {
    try {
      if (url != null) {
        var file = await DefaultCacheManager().getSingleFile(url);
        XFile result = XFile(file.path);
        return result;
      } else {
        return XFile("");
      }
    } catch (e) {
      return XFile("");
    }
  }

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  bool isValidTimeRange(TimeOfDay startTime, TimeOfDay endTime) {
    TimeOfDay now = TimeOfDay.now();
    return ((now.hour > startTime.hour) || (now.hour == startTime.hour && now.minute >= startTime.minute)) &&
        ((now.hour < endTime.hour) || (now.hour == endTime.hour && now.minute <= endTime.minute));
  }

  scrollListener(controller, type) {
    if (controller.position.userScrollDirection == ScrollDirection.reverse) {
      return true;
    }

    if (controller.position.userScrollDirection == ScrollDirection.forward &&
        controller.position.extentAfter >= controller.position.maxScrollExtent) {
      return false;
    }
  }

  getCountryCodeFromNumber(String phoneNumber) async {
    try {
      PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber);
      return number.dialCode;
    } catch (e) {
      // Handle any exceptions here
      return '';
    }
  }

  getCountryCode(String phoneNumber) async {
    try {
      PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber);
      return number.isoCode;
    } catch (e) {
      // Handle any exceptions here
      return '';
    }
  }

  getUserErrorMessage(Map object, BuildContext context) async {
    try {
      String message = object["hints"]["Error"];
      if (message == 'Username already exists.') {
        return translate(context).usernameAlreadyExists;
      } else if (message == 'Email address is already in use.') {
        return translate(context).emailAlreadyInUse;
      } else if (message == 'Identity number is already in use.') {
        return translate(context).idNumberAlreadyInUse;
      } else if (message == 'Identity number is already in use.') {
        return translate(context).idNumberAlreadyInUse;
      } else {
        return object["api"];
      }
    } catch (e) {
      String hints = object["hints"].toString();
      if (hints == "{0: Object name is already exist, total: 0}") {
        return translate(context).bookAlreadyAssigned;
      } else {
        return object["api"];
      }
    }
  }

  List<Map<String, dynamic>> removeDuplicates(List<Map<String, dynamic>> list, String key) {
    Set<dynamic> uniqueKeys = Set<dynamic>();
    List<Map<String, dynamic>> uniqueList = [];

    for (var element in list) {
      if (uniqueKeys.add(element[key])) {
        uniqueList.add(element);
      }
    }

    return uniqueList;
  }

  getClassRoomErrorMessage(Map object) async {
    try {
      List<String> parts = object["hints"].toString().split(':');

      String message = parts[1].trim();
      print(message);
      if (message.split(",")[0] == 'Class with the same name already exists.') {
        return "هذا العنصر موجود بالفعل لايمكن إضافته مرو أخرى"; //Todo : translate(context).itemAlreadyExists
      } else {
        return object["api"];
      }
    } catch (e) {
      return "SUCCESS";
    }
  }
}

AppLocalizations translate(BuildContext context) {
  return AppLocalizations.of(Get.context!)!;
}

String localize(String key) {
  return key.tr;
}