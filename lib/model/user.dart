class User {
  int id;
  String name;
  String email;
  Role role;
  String profilePhotoUrl;
  Company company;
  List<dynamic> actions; // Vous pouvez ajuster le type selon la nature des actions
  List<dynamic> friends; // Vous pouvez ajuster le type selon la nature des amis

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.profilePhotoUrl,
    required this.company,
    this.actions = const [],
    this.friends = const [],
  });

  // Fonction pour convertir un User en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toJson(),
      'profile_photo_url': profilePhotoUrl,
      'company': company.toJson(),
      'actions': actions,
      'friends': friends,
    };
  }

  // Fonction pour créer un User à partir d'un JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: Role.fromJson(json['role']),
      profilePhotoUrl: json['profile_photo_url'],
      company: Company.fromJson(json['company']),
      actions: List<dynamic>.from(json['actions'] ?? []),
      friends: List<dynamic>.from(json['friends'] ?? []),
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
      id: json['id'],
      name: json['name'],
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


// import 'dart:convert';

// User userFromJson(String str) =>
//     User.fromJson(json.decode(str));

// String userToJson(User data) => json.encode(data.toJson());

// class User {
//   List<Datum> data;

//   User({
//     required this.data,
//   });

//   factory User.fromJson(Map<String, dynamic> json) => User(
//         data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }

// class Datum {
//   int id;
//   String name;
//   String email;
//   Role role;
//   dynamic profilePhotoPath;
//   Company company;
//   List<Action> actions;

//   Datum({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.role,
//     required this.profilePhotoPath,
//     required this.company,
//     required this.actions,
//   });

//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["id"],
//         name: json["name"],
//         email: json["email"],
//         role: Role.fromJson(json["role"]),
//         profilePhotoPath: json["profile_photo_path"],
//         company: Company.fromJson(json["company"]),
//         actions:
//             List<Action>.from(json["actions"].map((x) => Action.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "role": role.toJson(),
//         "profile_photo_path": profilePhotoPath,
//         "company": company.toJson(),
//         "actions": List<dynamic>.from(actions.map((x) => x.toJson())),
//       };
// }

// class Action {
//   int id;
//   int userId;
//   String description;
//   String image;
//   String location;
//   String status;
//   DateTime createdAt;
//   DateTime updatedAt;
//   Role typeAction;
//   Trash trash;

//   Action({
//     required this.id,
//     required this.userId,
//     required this.description,
//     required this.image,
//     required this.location,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.typeAction,
//     required this.trash,
//   });

//   factory Action.fromJson(Map<String, dynamic> json) => Action(
//         id: json["id"],
//         userId: json["user_id"],
//         description: json["description"],
//         image: json["image"],
//         location: json["location"],
//         status: json["status"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         typeAction: Role.fromJson(json["type_action"]),
//         trash: Trash.fromJson(json["trash"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "user_id": userId,
//         "description": description,
//         "image": image,
//         "location": location,
//         "status": status,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "type_action": typeAction.toJson(),
//         "trash": trash.toJson(),
//       };
// }

// class Trash {
//   int id;
//   String trashname;
//   dynamic description;
//   int points;

//   Trash({
//     required this.id,
//     required this.trashname,
//     required this.description,
//     required this.points,
//   });

//   factory Trash.fromJson(Map<String, dynamic> json) => Trash(
//         id: json["id"],
//         trashname: json["trashname"],
//         description: json["description"],
//         points: json["points"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "trashname": trashname,
//         "description": description,
//         "points": points,
//       };
// }

// class Role {
//   int id;
//   RoleName name;

//   Role({
//     required this.id,
//     required this.name,
//   });

//   factory Role.fromJson(Map<String, dynamic> json) => Role(
//         id: json["id"],
//         name: roleNameValues.map[json["name"]]!,
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": roleNameValues.reverse[name],
//       };
// }

// enum RoleName { ADMIN, DCHET, ORGANISATEUR, USER }

// final roleNameValues = EnumValues({
//   "admin": RoleName.ADMIN,
//   "déchet": RoleName.DCHET,
//   "organisateur": RoleName.ORGANISATEUR,
//   "user": RoleName.USER
// });

// class Company {
//   int id;
//   CompanyName name;
//   Email email;
//   Logo logo;
//   Website website;

//   Company({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.logo,
//     required this.website,
//   });

//   factory Company.fromJson(Map<String, dynamic> json) => Company(
//         id: json["id"],
//         name: companyNameValues.map[json["name"]]!,
//         email: emailValues.map[json["email"]]!,
//         logo: logoValues.map[json["logo"]]!,
//         website: websiteValues.map[json["website"]]!,
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": companyNameValues.reverse[name],
//         "email": emailValues.reverse[email],
//         "logo": logoValues.reverse[logo],
//         "website": websiteValues.reverse[website],
//       };
// }

// enum Email { CONTACT2_COMPANY_FR, CONTACT_COMPANY_FR }

// final emailValues = EnumValues({
//   "contact2@company.fr": Email.CONTACT2_COMPANY_FR,
//   "contact@company.fr": Email.CONTACT_COMPANY_FR
// });

// enum Logo { LOGO1, LOGO2 }

// final logoValues = EnumValues({"logo1": Logo.LOGO1, "logo2": Logo.LOGO2});

// enum CompanyName { COMPANY_1, COMPANY_2 }

// final companyNameValues = EnumValues(
//     {"company 1": CompanyName.COMPANY_1, "company 2": CompanyName.COMPANY_2});

// enum Website { WWW_GOOGLE_COM }

// final websiteValues = EnumValues({"www.google.com": Website.WWW_GOOGLE_COM});

// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
