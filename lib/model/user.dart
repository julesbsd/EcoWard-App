import 'dart:developer';

import 'package:ecoward/model/action.dart';

class User {
  int id;
  String name;
  String email;
  String profile_photo_url;
  List<Action> actions;
  int steps;
  int points;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profile_photo_url,
    this.actions = const [],
    this.steps = 0,
    this.points = 0,
  });

  // Fonction pour convertir un User en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': '',
      'profile_photo_url': profile_photo_url,
      'company': '',
      'actions': actions.map((action) => action.toJson()).toList(),
      'steps': steps,
      'points': points,
    };
  }

  // Fonction pour créer un User à partir d'un JSON
  factory User.fromJson(Map<String, dynamic> json) {
    inspect(json);
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profile_photo_url: json['profile_photo_url'] ?? '',
      actions: (json['actions'] as List<dynamic>?)
              ?.map((actionJson) => Action.fromJson(actionJson))
              .toList() ??
          [],      steps: json['steps'] ?? 0,
      points: json['points'] ?? 0,
    );
  }
}

class Role {
  int id;
  String name;

  Role({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class Company {
  int id;
  String name;
  String email;
  String logo;
  String website;

  Company({
    required this.id,
    required this.name,
    required this.email,
    required this.logo,
    required this.website,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'logo': logo,
      'website': website,
    };
  }

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      logo: json['logo'],
      website: json['website'],
    );
  }
}
