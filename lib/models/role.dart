import 'package:flutter/cupertino.dart';

enum Role { provider, consumer, unassigned }

Role convertStringToRole({@required String roleString}) {
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

String convertRoleToString({@required Role role}) {
  String roleString;
  switch (role) {
    case Role.provider:
      roleString = 'provider';
      break;
    case Role.consumer:
      roleString = 'consumer';
      break;
    default:
      roleString = 'unassigned';
  }
  return roleString;
}
