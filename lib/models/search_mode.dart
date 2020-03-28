import 'package:flutter/cupertino.dart';

class SearchMode with ChangeNotifier {
  Mode mode;

  SearchMode({this.mode});

  switchMode() {
    if (mode == Mode.searchSkills) {
      mode = Mode.searchWishes;
    } else {
      mode = Mode.searchSkills;
    }
    notifyListeners();
  }
}

enum Mode { searchSkills, searchWishes }
