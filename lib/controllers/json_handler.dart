import 'package:flutter/material.dart';
import 'dart:convert';

class JSONHandler {
  static final JSONHandler _jsonHandler = JSONHandler._internal();
  factory JSONHandler() {
    return _jsonHandler;
  }
  JSONHandler._internal();

  Future<String> login(String email, String password) async {
    Map<String, String> parameters = {
      "email": email,
      "password": password,
    };
    return jsonEncode(parameters);
  }

  Future<String> register(
      String name, String email, String password, String? profileImage) async {
    Map<String, String> parameters = {
      "name": name,
      "email": email,
      "password": password,
    };
    return jsonEncode(parameters);
  }

  Future<String> logout(String token) async {
    Map<String, String> parameters = {
      "token": token,
    };
    return jsonEncode(parameters);
  }

  // Token et data sont au même endroit ?
  Future<String> saveSteps(int steps) async {
    Map<String, dynamic> parameters = {
      "steps": steps,
    };
    return jsonEncode(parameters);
  }

}
