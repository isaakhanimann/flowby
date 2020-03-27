import 'package:Flowby/screens/navigation_screen.dart';
import 'package:Flowby/services/algolia_service.dart';
import 'package:Flowby/services/apple_sign_in_available.dart';
import 'package:Flowby/services/firebase_auth_service.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/services/firebase_cloud_messaging.dart';
import 'package:Flowby/services/firebase_storage_service.dart';
import 'package:Flowby/services/image_picker_service.dart';
import 'package:Flowby/services/location_service.dart';
import 'package:Flowby/services/preferences_service.dart';
import 'package:Flowby/widgets/app_pushes.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/notifications_service.dart';
import 'services/apple_sign_in_available.dart';
import 'constants.dart';
import 'route_generator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';

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
        Provider<PreferencesService>(
          create: (_) => PreferencesService(),
        ),
        Provider<AlgoliaService>(
          create: (_) => AlgoliaService(),
        ),
        Provider<NotificationsService>(
          create: (_) => NotificationsService(),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: AppPushes(
          child: BotToastInit(
            // widget that pops up toasts (used to notify users when they copy a message)
            child: CupertinoApp(
              supportedLocales: [
                const Locale('en'),
                const Locale('de'),
                const Locale('fr'),
              ],
              localizationsDelegates: [
                AppLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                if (locale == null) {
                  locale = Locale('en');
                }
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              navigatorObservers: [BotToastNavigatorObserver()],
              theme: CupertinoThemeData(
                brightness: Brightness.light,
                primaryColor: kLoginBackgroundColor,
                primaryContrastingColor: CupertinoColors.white,
                barBackgroundColor: CupertinoColors.white,
                scaffoldBackgroundColor: CupertinoColors.white,
                textTheme: CupertinoTextThemeData(
                    textStyle: kDefaultTextStyle,
                    navTitleTextStyle: kMiddleNavigationBarTextStyle,
                    navLargeTitleTextStyle: kLargeNavigationBarTextStyle,
                    navActionTextStyle: kActionNavigationBarTextStyle),
              ),
              debugShowCheckedModeBanner: false,
              initialRoute: NavigationScreen.id,
              onGenerateRoute: RouteGenerator.generateRoute,
            ),
          ),
        ),
      ),
    );
  }
}

