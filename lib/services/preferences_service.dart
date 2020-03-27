import 'package:shared_preferences/shared_preferences.dart';
import 'package:Flowby/models/role.dart';

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

  Future<Role> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String roleString = prefs.getString('role') ?? 'unassigned';
    Role role = convertStringToRole(roleString: roleString);
    return role;
  }

  setRole({Role role}) async {
    String roleString = convertRoleToString(role: role);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('role', roleString);
  }
}
