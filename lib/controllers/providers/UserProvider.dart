import 'package:ecoward/model/user.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User user = User(
    id: 0,
    name: '',
    email: '',
    profilePhotoUrl: '',
    role: Role(id: 0, name: ''),
    company: Company(
      id: 0,
      name: '',
      email: '',
      logo: '',
      website: '',
    ),
    actions: [],
    friends: [],
  );

  void setUser(User user) {
    user = user;
    notifyListeners();
  }

  User get getUser {
    return user;
  }
}
