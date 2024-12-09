import 'package:ecoward/model/user.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User user = User(
    id: 0,
    name: '',
    email: '',
    profile_photo_url: '',
    actions: [],
    steps: 0,
    points: 0,
  );

  void setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }

  void setSteps(int newSteps) {
    user.steps = newSteps;
    notifyListeners();
  }

  void setPoints(int newPoints) {
    user.points = newPoints;
    notifyListeners();
  }

  User get getUser {
    return user;
  }

  List<dynamic> get getActions {
    return user.actions;
  }
}
