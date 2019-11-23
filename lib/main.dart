import 'package:flutter/material.dart';
import 'package:float/screens/registration_screen.dart';
import 'route_generator.dart';

void main() => runApp(Float());

class Float extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RegistrationScreen.id,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
