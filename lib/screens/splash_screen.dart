import 'package:float/services/firebase_auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    authService.tryToGetCurrentUserAndNavigate(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: Colors.white,
        child: Image.asset('images/logo.png'),
      ),
    );
  }
}
