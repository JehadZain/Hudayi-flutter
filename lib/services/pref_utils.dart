//ignore: unused_import
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _sharedPreferences;

  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  ///will clear all the data stored in preference
  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

  static String prefName = "com.hudai.app";
  static String areas = "${prefName}ttsAreas";
  static String branch = "${prefName}ttsBranchs";
  static String classRoom = "${prefName}ttsClassRoom";
  static String students = "${prefName}ttsStudents";
  static String student = "${prefName}ttsStudent";
  static String quran = "${prefName}ttsQuran";
  static String teachers = "${prefName}ttsTeachers";
  static String grades = "${prefName}ttsGrades";
  static String groups = "${prefName}ttsGroup";
  static String classes = "${prefName}ttsClasses";
  static String proprtyTeacher = "${prefName}ttsProprtyTeacher";
  static String proprtyStudent = "${prefName}ttsProprtyStudent";
  static String subjects = "${prefName}ttsSubjects";
  static String books = "${prefName}ttsBooks";
  static String session = "${prefName}ttsSession";
  static String area = "${prefName}ttsArea";
  static getArea() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(area) ?? "";
  }

  static setArea(String area1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(area, area1);
  }

  static getAreas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(areas) ?? "";
  }

  static setBranch(String area1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(branch, area1);
  }

  static getBranch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(branch) ?? "";
  }

  static setClassRoom(String area1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(classRoom, area1);
  }

  static getClassRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(classRoom) ?? "";
  }

  static setAreas(String areaGroup) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(areas, areaGroup);
  }

  static getStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(students) ?? "";
  }

  static setStudents(String studentGroup) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(students, studentGroup);
  }

  static getStudent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(student) ?? "";
  }

  static setStudent(String student1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(student, student1);
  }

  static getQuran() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(quran) ?? "";
  }

  static setQuran(String quran1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(quran, quran1);
  }

  static getTeachers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(teachers) ?? "";
  }

  static setTeachers(String teacher) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(teachers, teacher);
  }

  static getGrades() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(grades) ?? "";
  }

  static setGrades(String grade) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(grades, grade);
  }

  static getGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(groups) ?? "";
  }

  static setGroups(String group) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(groups, group);
  }

  static getClasses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(classes) ?? "";
  }

  static setClasses(String class1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(classes, class1);
  }

  static getProprtyTeachers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(proprtyTeacher) ?? "";
  }

  static setProprtyTeachers(String proprtyTeacher1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(proprtyTeacher, proprtyTeacher1);
  }

  static getProprtyStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(proprtyStudent) ?? "";
  }

  static setProprtyStudents(String proprtyStudent1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(proprtyStudent, proprtyStudent1);
  }

  static getSubjects() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(subjects) ?? "";
  }

  static setSubjects(String subjects1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(subjects, subjects1);
  }

  static getBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(books) ?? "";
  }

  static setBooks(String books1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(books, books1);
  }

  static getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(session) ?? "";
  }

  static setSession(String session1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(session, session1);
  }

  static remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(areas);
    prefs.remove(students);
    prefs.remove(student);
    prefs.remove(quran);
  }

  static removeQuran() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(quran);
  }

  static removeSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(session);
  }
}
