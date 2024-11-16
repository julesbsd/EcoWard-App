class User {
  int id;
  String name;
  String email;
  String profile_photo_url;
  List<dynamic> actions;
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
      'actions': actions,
      'steps': steps,
      'points': points,
    };
  }

  // Fonction pour créer un User à partir d'un JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profile_photo_url: json['profile_photo_url'] ?? '',
      actions: List<dynamic>.from(json['actions'] ?? []),
      steps: json['steps'] ?? 0,
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
