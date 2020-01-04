import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/screens/splash_screen.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'route_generator.dart';

void main() => runApp(Float());

class Float extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseConnection.getAuthenticationStream())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
