import 'dart:async';
import 'package:Flowby/constants.dart';
import 'package:Flowby/screens/tabs/chats_tab.dart';
import 'package:Flowby/screens/explanationscreens/explanation_screen.dart';
import 'package:Flowby/screens/tabs/search_tab.dart';
import 'package:Flowby/screens/tabs/profile_tab.dart';
import 'package:Flowby/services/firebase_auth_service.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/services/firebase_cloud_messaging.dart';
import 'package:Flowby/services/location_service.dart';
import 'package:Flowby/widgets/badge_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:Flowby/screens/choose_signin_screen.dart';
import 'package:Flowby/screens/choose_role_screen.dart';
import 'package:Flowby/services/preferences_service.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/models/role.dart';
import 'tabs/home_tab.dart';

class NavigationScreen extends StatefulWidget {
  static const String id = 'navigation_screen';

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  Stream<Position> positionStream;
  StreamSubscription<Position> positionStreamSubscription;
  Stream<int> unreadMessagesStream;
  Stream<Map<String, List<String>>> listOfMessagesStream;
  Role _role;
  bool _shouldExplanationBeLoaded = false;
  FirebaseUser loggedInUser;

  @override
  void initState() {
    super.initState();
    _setExplanation();
    _initializeEverything(context);
  }

  @override
  void dispose() {
    super.dispose();
    if (positionStreamSubscription != null) {
      positionStreamSubscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    if (_role == Role.unassigned) {
      return StreamProvider<User>.value(
        value: cloudFirestoreService.getUserStream(uid: loggedInUser?.uid),
        catchError: (context, object) {
          return null;
        },
        child: ChooseRoleScreen(),
      );
    }

    if (_shouldExplanationBeLoaded) {
      return ExplanationScreen(role: _role);
    }

    if (loggedInUser == null) {
      return MultiProvider(
        providers: [
          StreamProvider<Position>.value(
            value: positionStream,
          ),
          StreamProvider<User>.value(
            value: cloudFirestoreService.getUserStream(uid: loggedInUser?.uid),
            catchError: (context, object) {
              return null;
            },
          ),
          Provider<Role>.value(value: _role),
        ],
        child: HomeScreenWithSignin(),
      );
    }

    return MultiProvider(
      providers: [
        StreamProvider<Position>.value(
          value: positionStream,
        ),
        StreamProvider<User>.value(
          value: cloudFirestoreService.getUserStream(uid: loggedInUser.uid),
          catchError: (context, object) {
            return null;
          },
        ),
        Provider<Role>.value(value: _role),
        StreamProvider<int>.value(
          initialData: 0,
          value: unreadMessagesStream,
        ),
        StreamProvider<Map<String, List<String>>>.value(
          initialData: {
            "": [""]
          },
          value: listOfMessagesStream,
        ),
      ],
      child: ScreenWithAllTabs(),
    );
  }

  _initializeEverything(BuildContext context) async {
    Future<Role> preferenceRole = _getPreferenceRole();

    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);

    FirebaseUser firebaseUser = await authService.getCurrentUser();

    setState(() {
      this.loggedInUser = firebaseUser;
    });

    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    User currentUser =
        await cloudFirestoreService.getUser(uid: firebaseUser?.uid);

    Role profileRole = currentUser?.role;
    _uploadLocationAndPushToken(loggedInUser: firebaseUser);

    Role finalRole = profileRole ?? await preferenceRole;
    setState(() {
      _role = finalRole;
    });
  }

  Future<Role> _getPreferenceRole() async {
    final preferencesService =
        Provider.of<PreferencesService>(context, listen: false);

    Role preferenceRole = await preferencesService.getRole();
    return preferenceRole;
  }

  _uploadLocationAndPushToken({@required FirebaseUser loggedInUser}) async {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    final firebaseMessaging =
        Provider.of<FirebaseCloudMessaging>(context, listen: false);
    unreadMessagesStream = firebaseMessaging.getUnreadMessagesStream();
    listOfMessagesStream = firebaseMessaging.getListOfMessagesStream();

    final locationService =
        Provider.of<LocationService>(context, listen: false);
    //asBroadcast because the streamprovider for the homescreen also listens to it
    positionStream = locationService.getPositionStream().asBroadcastStream();

    if (loggedInUser != null) {
      positionStreamSubscription = positionStream.listen((Position position) {
        cloudFirestoreService.uploadUsersLocation(
            uid: loggedInUser.uid, position: position);
      });
      firebaseMessaging.firebaseCloudMessagingListeners(context);
      firebaseMessaging.getToken().then((token) {
        cloudFirestoreService.uploadUsersPushToken(
            uid: loggedInUser.uid, pushToken: token);
      });
    }
  }

  _setExplanation() async {
    final preferencesService =
        Provider.of<PreferencesService>(context, listen: false);

    bool shouldExplain = await preferencesService.getExplanationBool();

    if (shouldExplain) {
      setState(() {
        _shouldExplanationBeLoaded = true;
      });
      await preferencesService.setExplanationBoolToFalse();
    }
  }
}

class ScreenWithAllTabs extends StatelessWidget {
  const ScreenWithAllTabs({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int unreadMessages = Provider.of<int>(context);
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        activeColor: kDefaultProfilePicColor,
        inactiveColor: kSmallTitlesTextColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Feather.home,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Feather.search,
            ),
          ),
          BottomNavigationBarItem(
            icon: BadgeIcon(
              icon: Icon(
                Feather.mail,
              ),
              badgeCount: unreadMessages,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Feather.user,
            ),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        // since every tabview is created new on every call maybe this code can be shorter without side effects
        CupertinoTabView returnValue;
        switch (index) {
          case 0:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: HomeTab(),
              );
            });
            break;
          case 1:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: SearchTab(),
              );
            });
            break;
          case 2:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: ChatsTab(),
              );
            });
            break;
          case 3:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: ProfileTab(),
              );
            });
            break;
        }
        return returnValue;
      },
    );
  }
}

class HomeScreenWithSignin extends StatelessWidget {
  const HomeScreenWithSignin({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          SearchTab(),
          Positioned(
            bottom: 50,
            child: RoundedButton(
              text: 'Sign In',
              color: kDefaultProfilePicColor,
              textColor: kBlueButtonColor,
              onPressed: () async {
                Navigator.of(context).push(
                  CupertinoPageRoute<void>(
                    builder: (context) {
                      return ChooseSigninScreen(
                        canGoBack: true,
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
