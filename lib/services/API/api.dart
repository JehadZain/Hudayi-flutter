import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hudayi/models/user_model.dart';
import 'package:hudayi/screens/home.dart';
import 'package:hudayi/services/API/endpoints.dart';
import 'package:hudayi/ui/helper/App_Colors.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class ApiService {

  static const String baseurl = "http://192.168.17.124:8000";

  final String appLink = "$baseurl/api/mobile/v1";

  //final String appLink = "http://192.168.64.1/api/mobile/v1";
  //String url = Platform.isAndroid ? 'http://192.168.178.23:3000' : 'http://localhost:3000';

  logOutFromTheSystem() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    Provider.of<AuthService>(Get.context!, listen: false).logout();
    Get.snackbar(
      translate(Get.context!).unexpected_error,
      translate(Get.context!).yourAccountDisabledOrApprovalStage,
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: const Duration(seconds: 2),
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
    );
    Get.off(const HomeScreen());
  }

  statusCodeHandler(http.StreamedResponse response) async {
    final String body = await response.stream.bytesToString();
    try {
      final method = response.request?.method;
      final uri = response.request?.url;
      // Always print backend response details
      print('API RESPONSE => [' +
          (method ?? '') +
          '] ' +
          (uri?.toString() ?? '') +
          ' (' +
          response.statusCode.toString() +
          ')');
      print(body);
    } catch (_) {}

    if (response.statusCode == 403) {
      try {
        var jsonFile = json.decode(body);
        if (jsonFile["error"] == "Your account is inactive" ||
            jsonFile["error"] == "Your account is pending") {
          logOutFromTheSystem();
        }
      } catch (_) {}
      return json.decode(body);
    }
    return json.decode(body);
  }

  getAreas(token, page, size) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseurl/api/mobile/v1/branches?page=$page&perpage=$size'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    return statusCodeHandler(response);
  }

  getArea(token, id) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET',
        Uri.parse('$baseurl/api/mobile/v1/branches/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getAreasDetails(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('GET', Uri.parse('$appLink/${EndPoints().areas}/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getProperty(page, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET', Uri.parse('$appLink/${EndPoints().property}?page= $page'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getPropertyDetails(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('GET', Uri.parse('$appLink/${EndPoints().property}/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getClassDetails(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('GET', Uri.parse('$appLink/${EndPoints().grades}/$id'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getClassGroupDetails(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('GET', Uri.parse('$appLink/${EndPoints().classRoom}/$id'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getSessionDetails(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('GET', Uri.parse('$appLink/${EndPoints().sessions}/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getStudentDetails(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('GET', Uri.parse('$appLink/${EndPoints().students}/$id'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getTeacherDetails(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('GET', Uri.parse('$appLink/${EndPoints().teachers}/$id'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  createArea(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('$baseurl/api/mobile/v1/branches'));
    request.body = json.encode(object);
    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteArea(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('DELETE',
        Uri.parse('$baseurl/api/mobile/v1/branches/$id'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editArea(area, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PUT',
        Uri.parse(
            '$baseurl/api/mobile/v1/branches/${area["id"]}?name=${area["name"]}&organization_id=${area["organization_id"]}'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  creatClass(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('$baseurl/api/mobile/v1/grades'));
    request.body = json.encode(object);
    request.headers.addAll(headers);

    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteClass(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('DELETE',
        Uri.parse('$baseurl/api/mobile/v1/grades/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editClass(area, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PUT',
        Uri.parse(
            '$baseurl/api/mobile/v1/grades/${area["id"]}?name=${area["name"]}&description=${area["description"]}&property_id=${area["property_id"]}'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  creatClassRoom(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var request = http.MultipartRequest('POST',
        Uri.parse('$baseurl/api/mobile/v1/class-room'));

    Map<String, String> data = {};
    object.forEach((key, value) {
      data[key] = value.toString();
    });
    if (data["mainImage"] != 'null') {
      request.files.add(
          await http.MultipartFile.fromPath('image', '${data["mainImage"]}'));
    } else {
      data.remove("mainImage");
    }
    data.remove("user[mainImage]");
    data.remove("mainImage");

    request.fields.addAll(
        data.map((key, value) => MapEntry(key, value == "null" ? "" : value)));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteClassRoom(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('DELETE',
        Uri.parse('$baseurl/api/mobile/v1/class-room/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteUser(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest('DELETE',
        Uri.parse('$baseurl/api/mobile/v1/users/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editClassRoom(object, token) async {
    print(object);
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '$baseurl/api/mobile/v1/class-room/${object["id"]}'));

    Map<String, String> data = {};
    object.forEach((key, value) {
      data[key] = value.toString();
    });
    if (data["mainImage"] != 'null') {
      request.files.add(
          await http.MultipartFile.fromPath('image', '${data["mainImage"]}'));
    } else {
      data.remove("mainImage");
    }
    data.remove("user[mainImage]");
    data.remove("mainImage");
    request.fields.addAll(
        data.map((key, value) => MapEntry(key, value == "null" ? "" : value)));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  createStudentInterview(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('$baseurl/api/mobile/v1/interviews'));
    request.body = json.encode(object);
    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  createStudentBookInterview(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var request = http.MultipartRequest('POST',
        Uri.parse('$baseurl/api/mobile/v1/interviews'));
    Map<String, String> data = {};
    object.forEach((key, value) {
      data[key] = value.toString();
    });
    if (data["mainImage"] != 'null') {
      request.files.add(
          await http.MultipartFile.fromPath('image', '${data["mainImage"]}'));
    } else {
      data.remove("mainImage");
    }
    data.remove("user[mainImage]");
    data.remove("mainImage");
    request.fields.addAll(
        data.map((key, value) => MapEntry(key, value == "null" ? "" : value)));
    request.headers.addAll(headers);
    print("result$object");
    http.StreamedResponse response = await request.send();
    request.headers.addAll(headers);

    return statusCodeHandler(response);
  }

  deleteStudentInterview(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('DELETE',
        Uri.parse('$baseurl/api/mobile/v1/interviews/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editStudentBookInterview(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '$baseurl/api/mobile/v1/interviews/${object["id"]}'));
    Map<String, String> data = {};
    object.forEach((key, value) {
      data[key] = value.toString();
    });
    request.headers.addAll(headers);

    if (data["mainImage"] != 'null') {
      request.files.add(
          await http.MultipartFile.fromPath('image', '${data["mainImage"]}'));
    } else {
      data.remove("mainImage");
    }
    data.remove("user[mainImage]");
    data.remove("mainImage");
    request.fields.addAll(
        data.map((key, value) => MapEntry(key, value == "null" ? "" : value)));
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  createStudentExam(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('$baseurl/api/mobile/v1/quizzes'));

    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editStudentExam(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PUT',
        Uri.parse(
            '$baseurl/api/mobile/v1/quizzes/${object["id"]}?name=${object["name"]}&quiz_subject=${object["quiz_subject"]}&date=${object["date"]}}&time=${object["time"]}&quiz_type=${object["quiz_type"]}&score=${object["score"]}&student_id=${object["student_id"]}&teacher_id=${object["teacher_id"]}'));

    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteStudentExam(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('DELETE',
        Uri.parse('$baseurl/api/mobile/v1/quizzes/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  createStudentQuran(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('$baseurl/api/mobile/v1/quran-quizzes'));

    request.body = json.encode(object);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editStudentQuran(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PUT',
        Uri.parse(
            '$baseurl/api/mobile/v1/quran-quizzes/${object["id"]}?name=${object["name"]}&juz=${object["juz"]}&page=${object["page"]}&date=${object["date"]}&score=${object["score"]}&student_id=${object["student_id"]}&teacher_id=${object["teacher_id"]}&exam_type=${object["type"]}'));

    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteStudentQuran(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            '$baseurl/api/mobile/v1/quran-quizzes/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  createStudentNotes(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('$baseurl/api/mobile/v1/notes'));

    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editStudentNotes(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PUT',
        Uri.parse(
            '$baseurl/api/mobile/v1/notes/${object["id"]}?content=${object["content"]}&date=${object["date"]}&student_id=${object["student_id"]}&teacher_id=${object["teacher_id"]}'));

    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteStudentNotes(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('DELETE',
        Uri.parse('$baseurl/api/mobile/v1/notes/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  createGroupSession(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('$baseurl/api/mobile/v1/sessions'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editGroupSession(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PUT',
        Uri.parse(
            '$baseurl/api/mobile/v1/sessions/${object["id"]}?name=${object["name"]}&description=${object["description"]}&date=${object["date"]}&start_at=${object["start_at"]}&duration=${object["duration"]}&teacher_id=5&class_room_id=${object["class_room_id"]}&subject_name=${object["subject_name"]}'));

    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteGroupSession(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('DELETE',
        Uri.parse('$baseurl/api/mobile/v1/sessions/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  createStudentClassRoom(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            '$baseurl/api/mobile/v1/class-room-students'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getActivityTypes(token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET',
        Uri.parse('$baseurl/api/mobile/v1/activity-types'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteProperty(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('DELETE',
        Uri.parse('$baseurl/api/mobile/v1/properties/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  createTime(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('$baseurl/api/mobile/v1/calendars'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editTime(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PUT',
        Uri.parse(
            '$baseurl/api/mobile/v1/calendars/${object["id"]}?class_room_id=${object["class_room_id"]}&day_name=${object["day_name"]}&subject_name=${object["subject_name"]}&start_at=${object["start_at"]}&end_at=${object["end_at"]}'));

    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteTime(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('DELETE',
        Uri.parse('$baseurl/api/mobile/v1/calendars/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  addClassRoomTeacher(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            '$baseurl/api/mobile/v1/class-room-teachers'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editClassRoomTeacher(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PUT',
        Uri.parse(
            '$baseurl/api/mobile/v1/class-room-teachers/${object["id"]}?class_room_id=${object["class_room_id"]}1&teacher_id=${object["teacher_id"]}&joined_at=${object["joined_at"]}&left_at'));

    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  addBranchAdmin(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('$baseurl/api/mobile/v1/branch/admins'));
    request.body = json.encode(object);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  addPropAdmin(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('$baseurl/api/mobile/v1/property/admins'));
    request.body = json.encode(object);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteClassroomTeachers(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            '$baseurl/api/mobile/v1/class-room-teachers/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteBranchAdmin(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            '$baseurl/api/mobile/v1/branch/admins/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deletePropAdmin(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            '$baseurl/api/mobile/v1/property/admins/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  addClassroomStudent(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            '$baseurl/api/mobile/v1/class-room-students'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editClassRoomStudent(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PUT',
        Uri.parse(
            '$baseurl/api/mobile/v1/class-room-students/${object["id"]}?class_room_id=${object["class_room_id"]}&student_id=${object["student_id"]}&joined_at=${object["joined_at"]}&left_at=${object["left_at"]}'));

    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  createClassRoomActivity(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var request = http.MultipartRequest('POST',
        Uri.parse('$baseurl/api/mobile/v1/activities'));

    Map<String, String> data = {};
    object.forEach((key, value) {
      data[key] = value.toString();
    });
    if (data["mainImage"] != 'null') {
      request.files.add(
          await http.MultipartFile.fromPath('image', '${data["mainImage"]}'));
    } else {
      data.remove("mainImage");
    }
    data.remove("user[mainImage]");
    data.remove("mainImage");
    request.fields.addAll(
        data.map((key, value) => MapEntry(key, value == "null" ? "" : value)));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editClassRoomActivity(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '$baseurl/api/mobile/v1/activities/${object["id"]}'));

    request.headers.addAll(headers);
    Map<String, String> data = {};
    object.forEach((key, value) {
      data[key] = value.toString();
    });

    if (data["mainImage"] != 'null') {
      request.files.add(
          await http.MultipartFile.fromPath('image', '${data["mainImage"]}'));
    } else {
      data.remove("mainImage");
    }
    data.remove("user[mainImage]");
    data.remove("mainImage");
    request.fields.addAll(
        data.map((key, value) => MapEntry(key, value == "null" ? "" : value)));

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteClassRoomActivity(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('DELETE',
        Uri.parse('$baseurl/api/mobile/v1/activities/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  createProprty(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('$baseurl/api/mobile/v1/properties'));
    Map<String, String> data = {};
    object.forEach((key, value) {
      data[key] = value.toString();
    });

    if (data["mainImage"] != 'null') {
      request.files.add(
          await http.MultipartFile.fromPath('image', '${data["mainImage"]}'));
    } else {
      data.remove("mainImage");
    }
    data.remove("user[mainImage]");
    data.remove("mainImage");
    request.fields.addAll(
        data.map((key, value) => MapEntry(key, value == "null" ? "" : value)));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editProprty(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '$baseurl/api/mobile/v1/properties/${object['id']}'));
    Map<String, String> data = {};
    object.forEach((key, value) {
      data[key] = value.toString();
    });

    if (data["mainImage"] != 'null') {
      request.files.add(
          await http.MultipartFile.fromPath('image', '${data["mainImage"]}'));
    } else {
      data.remove("mainImage");
    }
    data.remove("user[mainImage]");
    data.remove("mainImage");
    request.fields.addAll(
        data.map((key, value) => MapEntry(key, value == "null" ? "" : value)));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  static final url = '$baseurl/api/mobile/v1/';
  getStudentsWithoutClass(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseurl/api/mobile/v1/property-students-without-class-room/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    return statusCodeHandler(response);
  }

  getTeacherWithoutClass(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseurl/api/mobile/v1/property-teachers-without-class-room/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    return statusCodeHandler(response);
  }

  getPropertyStudents(id, token, page, {search}) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(search != null
            ? '$baseurl/api/mobile/v1/property-students/$id?searchWithUser=$search'
            : '$baseurl/api/mobile/v1/property-students/$id?page=$page'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    return statusCodeHandler(response);
  }

  getPropertyTeacher(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseurl/api/mobile/v1/property-teachers-and-admins/$id'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteClassRoomStudent(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            '$baseurl/api/mobile/v1/class-room-students/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  createActivityType(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('$baseurl/api/mobile/v1/activity-types'));

    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editActivityType(object, token) async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'POST',
        Uri.parse(
            '$baseurl/api/mobile/v1/activity-types/${object["id"]}?name=${object["name"]}&goal=${object["goal"]}&description=${object["description"]}'));

    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteActivityType(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            '$baseurl/api/mobile/v1/activity-types/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  login(userName, password) async {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('$baseurl/api/mobile/v1/login'));
    request.body = json.encode({"username": userName, "password": password});
    request.headers.addAll(headers);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    final String body = await response.stream.bytesToString();
    try {
      print('API RESPONSE => [POST] ' +
          request.url.toString() +
          ' (' +
          response.statusCode.toString() +
          ')');
      print(body);
    } catch (_) {}
    return json.decode(body);
  }

  getStudentStatics(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseurl/api/mobile/v1/student-statistics/$id'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getTeacherStatics(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseurl/api/mobile/v1/teachers-statistics/$id/'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getClassRoomStatics(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseurl/api/mobile/v1/class-room-statistics/$id'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getProprty(id, token) async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request('GET',
        Uri.parse('$baseurl/api/mobile/v1/properties/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getProprtyStatic(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseurl/api/mobile/v1/property-statistics/$id'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getAllStudents(token, page, {String? search}) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(search == null
            ? '$baseurl/api/mobile/v1/all-student?page=$page'
            : '$baseurl/api/mobile/v1/all-student?searchWithUser=$search'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getAllTeachers(token, page, {String? search}) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(search == null
            ? '$baseurl/api/mobile/v1/all-teachers?page=$page'
            : '$baseurl/api/mobile/v1/all-teachers?searchWithUser=$search'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getAllAdmins(token, {page, String? search}) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    String link =
        '$baseurl/api/mobile/v1/admins?page=$page&perpage=15';
    var request = http.Request('GET',
        Uri.parse(search == null ? link : '$link&searchWithUser=$search'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getUnassignedAdmins(token, {page}) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET',
        Uri.parse('$baseurl/api/app/v1/admins/unassigned'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getUserDetails(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET',
        Uri.parse('$baseurl/api/mobile/v1/users/$id'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  createProprtyTeacher(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('$baseurl/api/mobile/v1/teachers'));
    Map<String, String> data = {};
    object.forEach((key, value) {
      data[key] = value.toString();
    });
    if (data["user[mainImage]"] != 'null') {
      request.files.add(await http.MultipartFile.fromPath(
          'user[image]', '${data["user[mainImage]"]}'));
    } else {
      data.remove("user[mainImage]");
    }
    data.remove("user[mainImage]");
    data.remove("mainImage");
    request.fields.addAll(
        data.map((key, value) => MapEntry(key, value == "null" ? "" : value)));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  propertyTeachersAdmins(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseurl/api/mobile/v1/property-teachers-and-admins/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  createProprtyStudnet(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('$baseurl/api/mobile/v1/students'));
    Map<String, String> data = {};
    object.forEach((key, value) {
      data[key] = value.toString();
    });

    if (data["user[mainImage]"] != 'null') {
      request.files.add(await http.MultipartFile.fromPath(
          'user[image]', '${data["user[mainImage]"]}'));
    } else {
      data.remove("user[mainImage]");
    }
    data.remove("user[mainImage]");
    data.remove("mainImage");
    request.fields.addAll(
        data.map((key, value) => MapEntry(key, value == "null" ? "" : value)));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editProprtyStudent(object, object2, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '$baseurl/api/mobile/v1/students/${object["id"]}}'));
    Map<String, String> data = {};
    object2.forEach((key, value) {
      data[key] = value.toString();
    });
    request.headers.addAll(headers);
    if (data["user[password]"] == "" ||
        data["user[password]"] == "null" ||
        data["user[password]"] == null ||
        data["user[password]"] == " ") {
      data.remove("user[password]");
    }
    if (data["user[mainImage]"] != 'null') {
      request.files.add(await http.MultipartFile.fromPath(
          'user[image]', '${data["user[mainImage]"]}'));
    } else {
      data.remove("user[mainImage]");
    }
    data.remove("user[mainImage]");
    data.remove("mainImage");
    request.fields.addAll(
        data.map((key, value) => MapEntry(key, value == "null" ? "" : value)));
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editProprtyTeacher(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '$baseurl/api/mobile/v1/teachers/${object["id"]}}'));
    Map<String, String> data = {};
    object.forEach((key, value) {
      data[key] = value.toString();
    });
    request.headers.addAll(headers);
    if (data["user[password]"] == "" ||
        data["user[password]"] == "null" ||
        data["user[password]"] == null ||
        data["user[password]"] == " ") {
      data.remove("user[password]");
    }
    if (data["user[mainImage]"] != 'null') {
      request.files.add(await http.MultipartFile.fromPath(
          'user[image]', '${data["user[mainImage]"]}'));
    } else {
      data.remove("user[mainImage]");
    }
    data.remove("user[mainImage]");
    data.remove("mainImage");
    request.fields.addAll(
        data.map((key, value) => MapEntry(key, value == "null" ? "" : value)));

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getGradeStatics(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseurl/api/mobile/v1/grades-statistics/$id'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    return statusCodeHandler(response);
  }

  deleteStudent(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('DELETE',
        Uri.parse('$baseurl/api/mobile/v1/students/$id'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteTeacher(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('DELETE',
        Uri.parse('$baseurl/api/mobile/v1/teachers/$id'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getBooks(token, {property_type, page, String? search}) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    String link = property_type == null
        ? "$baseurl/api/mobile/v1/books?page=$page"
        : property_type == "جامع"
            ? "$baseurl/api/mobile/v1/mosque-books"
            : '$baseurl/api/mobile/v1/school-books';
    var request = http.Request(
        'GET', Uri.parse(search == null ? link : '$link&search=$search'));
    request.bodyFields = {};
    request.headers.addAll(headers);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getSubjects(token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET', Uri.parse('$baseurl/api/mobile/v1/subjects'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getClassRoomBooks(token, id) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseurl/api/mobile/v1/class-room-books/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  addABook(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('$baseurl/api/mobile/v1/books'));

    Map<String, String> data = {};
    object.forEach((key, value) {
      data[key] = value.toString();
    });

    if (data["mainImage"] != 'null') {
      request.files.add(
          await http.MultipartFile.fromPath('image', '${data["mainImage"]}'));
    } else {
      data.remove("mainImage");
    }
    data.remove("user[mainImage]");
    data.remove("mainImage");
    request.fields.addAll(
        data.map((key, value) => MapEntry(key, value == "null" ? "" : value)));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  addASubject(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('$baseurl/api/mobile/v1/subjects'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteABook(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('DELETE',
        Uri.parse('$baseurl/api/mobile/v1/books/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteABookFromClassRoom(token, {book_id, class_room_id}) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            '$baseurl/api/mobile/v1/class-room-books/$book_id/$class_room_id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  addABookToClassRoom(token, {book_id, class_room_id}) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            '$baseurl/api/mobile/v1/class-room-books/$book_id/$class_room_id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return statusCodeHandler(response);
  }

  editBook(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '$baseurl/api/mobile/v1/books/${object["id"]}'));

    Map<String, String> data = {};
    object.forEach((key, value) {
      data[key] = value.toString();
    });

    if (data["mainImage"] != 'null') {
      request.files.add(
          await http.MultipartFile.fromPath('image', '${data["mainImage"]}'));
    } else {
      data.remove("mainImage");
    }
    data.remove("user[mainImage]");
    data.remove("mainImage");
    request.headers.addAll(headers);
    request.fields.addAll(
        data.map((key, value) => MapEntry(key, value == "null" ? "" : value)));
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editSubject(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PUT',
        Uri.parse(
            '$baseurl/api/mobile/v1/subjects/${object["id"]}?name=${object["name"]}&description=${object["description"]}'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    request.body = json.encode(object);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteSubject(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('DELETE',
        Uri.parse('$baseurl/api/mobile/v1/subjects/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  addActivityPareicpants(activityId, studentIds, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            '$baseurl/api/mobile/v1/activity-participants'));
    request.body = json.encode(
        {"id": null, "activity_id": activityId, "student_id": studentIds});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  putActivityPareicpants(activityId, studentIds, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PUT',
        Uri.parse(
            '$baseurl/api/mobile/v1/activity-participants/$activityId?activity_id=$activityId'));
    request.body =
        json.encode({"activity_id": activityId, "student_id": studentIds});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  putSessionPareicpants(sessionId, studentIds, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PUT',
        Uri.parse(
            '$baseurl/api/mobile/v1/session-attendances/$sessionId?session_id=$sessionId'));
    request.body =
        json.encode({"session_id": sessionId, "student_id": studentIds});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteActivityPareicpants(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            '$baseurl/api/mobile/v1/activity-participants/$id'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return statusCodeHandler(response);
  }

  addSessionPer(activityId, studentIds, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            '$baseurl/api/mobile/v1/session-attendances'));
    request.body = json.encode(
        {"id": null, "session_id": activityId, "student_id": studentIds});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  pendingUsers(token, page) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseurl/api/mobile/v1/users/pending?page=$page'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  pendingClassRooms(token, page) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseurl/api/mobile/v1/class-room/pending?page=$page'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getStatics(token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseurl/api/mobile/v1/analytics/properties'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  studentStatus(token, status, id) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('$baseurl/api/mobile/v1/students/$id'));
    request.fields.addAll({'user[status]': status});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  acceptUser(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('PUT',
        Uri.parse('$baseurl/api/mobile/v1/users/$id'));
    request.body = json.encode({"is_approved": "1"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  createAdmin(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('$baseurl/api/mobile/v1/admins'));
    Map<String, String> data = {};
    object.forEach((key, value) {
      data[key] = value.toString();
    });

    if (data["user[mainImage]"] != 'null') {
      request.files.add(await http.MultipartFile.fromPath(
          'user[image]', '${data["user[mainImage]"]}'));
    } else {
      data.remove("user[mainImage]");
    }
    data.remove("user[mainImage]");
    data.remove("mainImage");
    request.fields.addAll(
        data.map((key, value) => MapEntry(key, value == "null" ? "" : value)));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editAdmin(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '$baseurl/api/mobile/v1/admins/${object["id"]}}'));
    Map<String, String> data = {};
    object.forEach((key, value) {
      data[key] = value.toString();
    });
    request.headers.addAll(headers);
    if (data["user[password]"] == "" ||
        data["user[password]"] == "null" ||
        data["user[password]"] == null ||
        data["user[password]"] == " ") {
      data.remove("user[password]");
    }
    if (data["user[mainImage]"] != 'null') {
      request.files.add(await http.MultipartFile.fromPath(
          'user[image]', '${data["user[mainImage]"]}'));
    } else {
      data.remove("user[mainImage]");
    }
    data.remove("user[mainImage]");
    data.remove("mainImage");
    request.fields.addAll(
        data.map((key, value) => MapEntry(key, value == "null" ? "" : value)));
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteAdmin(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('DELETE',
        Uri.parse('$baseurl/api/mobile/v1/admins/$id'));

    request.headers.addAll(headers);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  getAdminDetails(id, token) async {
    print(id);
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET',
        Uri.parse('$baseurl/api/mobile/v1/admins/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  transferTeacher(data, token) async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '$baseurl/api/mobile/v1/teachers/transfer/${data["teacher_id"]}'));
    request.fields.addAll({
      'new_property_id': data["new_property_id"],
      'new_class_id': data["new_class_id"].toString()
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  transferStudent(data, token) async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '$baseurl/api/mobile/v1/students/transfer/${data["studnet_id"]}'));
    request.fields.addAll({
      'new_property_id': data["new_property_id"].toString(),
      'new_class_id': data["new_class_id"].toString()
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return statusCodeHandler(response);
  }

  getPropretyGrade(token, id) async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseurl/api/mobile/v1/property-classes/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return statusCodeHandler(response);
  }

  uploadCertifications(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('$baseurl/api/mobile/v1/certifications'));
    Map<String, String> data = {};
    object.forEach((key, value) {
      data[key] = value.toString();
    });

    if (data["mainImage"] != 'null') {
      request.files.add(
          await http.MultipartFile.fromPath('image', '${data["mainImage"]}'));
    } else {
      data.remove("mainImage");
    }
    data.remove("mainImage");
    data.remove("mainImage");
    request.fields.addAll(
        data.map((key, value) => MapEntry(key, value == "null" ? "" : value)));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  createRates(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('$baseurl/api/mobile/v1/rates/'));
    print("object$object");
    request.body = json.encode(object);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  editRates(object, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PUT',
        Uri.parse(
            '$baseurl/api/mobile/v1/rates/${object["id"]}'));
    request.body = json.encode(object);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  deleteRates(id, token) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('DELETE',
        Uri.parse('$baseurl/api/mobile/v1/rates/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }

  checkVersion(token, version) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseurl/api/mobile/v1/check-version/$version'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return statusCodeHandler(response);
  }
}
