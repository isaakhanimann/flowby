import 'package:Flowby/screens/navigation_screen.dart';
import 'package:Flowby/services/apple_sign_in_available.dart';
import 'package:Flowby/services/firebase_auth_service.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/services/firebase_cloud_messaging.dart';
import 'package:Flowby/services/firebase_storage_service.dart';
import 'package:Flowby/services/image_picker_service.dart';
import 'package:Flowby/services/location_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/apple_sign_in_available.dart';
import 'constants.dart';
import 'route_generator.dart';

void main() async {
  // This app is designed only to work vertically, so we limit
  // orientations to portrait up and down.
  WidgetsFlutterBinding.ensureInitialized();
  final isAppleSignInAvailable = await AppleSignInAvailable.check();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  return runApp(Provider<AppleSignInAvailable>.value(
    value: isAppleSignInAvailable,
    child: Flowby(),
  ));
}

class Flowby extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(),
        ),
        Provider<FirebaseCloudFirestoreService>(
          create: (_) => FirebaseCloudFirestoreService(),
        ),
        Provider<FirebaseStorageService>(
          create: (_) => FirebaseStorageService(),
        ),
        Provider<ImagePickerService>(
          create: (_) => ImagePickerService(),
        ),
        Provider<LocationService>(
          create: (_) => LocationService(),
        ),
        Provider<FirebaseCloudMessaging>(
          create: (_) => FirebaseCloudMessaging(),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: CupertinoApp(
          theme: CupertinoThemeData(
              brightness: Brightness.light,
              primaryColor: kLoginBackgroundColor),
          debugShowCheckedModeBanner: false,
          initialRoute: NavigationScreen.id,
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}
