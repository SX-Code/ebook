import 'package:flutter/material.dart';

class BottomNavProvider with ChangeNotifier {
  int _currentIndex = 0;
  Map<int, Function()?> refreshFuncs = {};
  
  int get currentIndex => _currentIndex;

  set currentIndex(int currentIndex) {
    _currentIndex = currentIndex;
    notifyListeners();
  }

  void refresh(int index) {
    refreshFuncs[index]?.call();
  }

  void setIndex(int index) {
    currentIndex = index;
  }
}