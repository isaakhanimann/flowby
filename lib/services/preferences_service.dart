import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<bool> getShouldExplanationBeLoaded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int numberOfTimesLoaded = prefs.getInt('numberOfTimesLoaded') ?? 0;
    prefs.setInt('numberOfTimesLoaded', numberOfTimesLoaded + 1);
    if (numberOfTimesLoaded == 0 || numberOfTimesLoaded == 1) {
      return true;
    } else {
      return false;
    }
  }
}
