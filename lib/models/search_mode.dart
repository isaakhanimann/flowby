import 'package:flutter/cupertino.dart';

class SearchMode with ChangeNotifier {
  Mode mode;

  SearchMode({this.mode});

  setMode(Mode newMode) {
    mode = newMode;
    notifyListeners();
  }
}

enum Mode { searchSkills, searchWishes }
