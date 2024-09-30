import 'package:ecoward/model/user.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User user = User(
    id: 0,
    name: '',
    email: '',
    profile_photo_url: '',
    // role: Role(id: 0, name: ''),
    // company: Company(
    //   id: 0,
    //   name: '',
    //   email: '',
    //   logo: '',
    //   website: '',
    // ),
    actions: [],
    friends: [],
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

  void setFriends(List<dynamic> newFriends) {
    user.friends = newFriends;
    notifyListeners();
  }

  User get getUser {
    return user;
  }
}
