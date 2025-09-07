import 'package:flutter/material.dart';

// User class
class Userclass {
  final String userObject;
  Userclass(this.userObject);
  String toUser() => userObject;
}

// AuthService has all authentication logic, notifies listeners
class AuthService with ChangeNotifier {
  Userclass _user = Userclass("null");
  Userclass get user => _user;

  Future<void> _authenticate(String userObject) async {
    // This is where we authenticate or register the user, and update the state
    _user = Userclass(userObject);
    return Future<void>(() {});
  }

  Future<void> register(String userObject) async {
    return _authenticate(userObject);
  }

  Future<void> login(String userObject) async {
    return _authenticate(userObject);
  }

  Future<void> logout() async {
    _user = Userclass("null");
    notifyListeners();
    return Future<void>(() {});
  }
}
