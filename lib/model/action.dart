class Action {
  int id;
  String status;
  String location;
  String created_at;
  String updated_at;
  int quantity;
  int points;
  String trashname;

  Action({
    required this.id,
    required this.status,
    required this.location,
    required this.created_at,
    required this.updated_at,
    required this.quantity,
    required this.points,
    required this.trashname,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'location': location,
      'created_at': created_at,
      'updated_at': updated_at,
      'quantity': quantity,
      'points': points,
      'trashname': trashname,
    };
  }

  factory Action.fromJson(Map<String, dynamic> json) {
    return Action(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      location: json['location'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      quantity: json['quantity'] ?? 0,
      points: json['points'] ?? 0,
      trashname: json['trashname'] ?? '',
    );
  }
}