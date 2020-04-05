import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<bool> getIsFirstTimeThatAppIsLoaded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTimeThatAppIsLoaded =
        prefs.getBool('isFirstTimeThatAppIsLoaded') ?? true;
    prefs.setBool('isFirstTimeThatAppIsLoaded', false);
    return isFirstTimeThatAppIsLoaded;
  }
}
