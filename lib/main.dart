import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/splash_screen.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'route_generator.dart';

void main() => runApp(Float());

class Float extends StatefulWidget {
  @override
  _FloatState createState() => _FloatState();
}

class _FloatState extends State<Float> {
  StreamSubscription<FirebaseUser> authenticationStreamSubscription;
  Stream<User> loggedInUserStream;

  StreamSubscription<FirebaseUser> setLoggedInUserStream() {
    authenticationStreamSubscription =
        FirebaseConnection.getAuthenticationStream().listen((firebaseUser) {
      loggedInUserStream =
          FirebaseConnection.getUserStream(uid: firebaseUser?.email);
    });
    return authenticationStreamSubscription;
  }

  @override
  void initState() {
    super.initState();
    authenticationStreamSubscription = setLoggedInUserStream();
  }

  @override
  void dispose() {
    super.dispose();
    authenticationStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: loggedInUserStream,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
