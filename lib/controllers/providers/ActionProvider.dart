import 'package:flutter/material.dart';

class ActionProvider with ChangeNotifier {
  int trash = 0;
  int challenge = 0;
  // image base64
  List<String> images = [];
  // location
  double latitude = 0.0;
  double longitude = 0.0;
  String description = '';

  void setTrash(int newTrash) {
    trash = newTrash;
    notifyListeners();
  }

  void setChallenge(int newChallenge) {
    challenge = newChallenge;
    notifyListeners();
  }

  void setImages(List<String> newImages) {
    images = newImages;
    notifyListeners();
  }

  void setLocation(double newLatitude, double newLongitude) {
    latitude = newLatitude;
    longitude = newLongitude;
    notifyListeners();
  }

  void setDescription(String newDescription) {
    description = newDescription;
    notifyListeners();
  }

  int get getTrash {
    return trash;
  }
  
  int get getChallenge {
    return challenge;
  }

  List<String> get getImages {
    return images;
  }

  double get getLatitude {
    return latitude;
  }

  double get getLongitude {
    return longitude;
  }

  String get getDescription {
    return description;
  }

  void clear() {
    trash = 0;
    challenge = 0;
    images = [];
    latitude = 0.0;
    longitude = 0.0;
    description = '';
    notifyListeners();
  }
}
