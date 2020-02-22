import 'package:shared_preferences/shared_preferences.dart';

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
    Role role;
    switch (roleString) {
      case 'provider':
        role = Role.provider;
        break;
      case 'consumer':
        role = Role.consumer;
        break;
      default:
        role = Role.unassigned;
    }
    return role;
  }

  setRole({Role role}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (role) {
      case Role.provider:
        prefs.setString('role', 'provider');
        break;
      case Role.consumer:
        prefs.setString('role', 'consumer');
        break;
      default:
        prefs.setString('role', 'unassigned');
    }
  }
}

enum Role { provider, consumer, unassigned }
