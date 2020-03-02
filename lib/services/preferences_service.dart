import 'package:shared_preferences/shared_preferences.dart';
import 'package:Flowby/models/role.dart';

class PreferencesService {
  Future<bool> getExplanationBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool shouldExplanationBeLoaded =
        prefs.getBool('shouldExplanationBeLoaded') ?? true;
    return shouldExplanationBeLoaded;
  }

  setExplanationBoolToFalse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('shouldExplanationBeLoaded', false);
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
