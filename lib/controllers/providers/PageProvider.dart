import 'package:flutter/material.dart';

class Pageprovider with ChangeNotifier {
  int index = 0;

  void setIndex(int newIndex) {
    index = newIndex;
    notifyListeners();
  }

  int getIndex() {
    return index;
  }
}
