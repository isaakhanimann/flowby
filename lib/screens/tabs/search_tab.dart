import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/explanationscreens/explanation_screen.dart';
import 'package:Flowby/screens/view_profile_screen.dart';
import 'package:Flowby/services/algolia_service.dart';
import 'package:Flowby/widgets/centered_loading_indicator.dart';
import 'package:Flowby/widgets/custom_card.dart';
import 'package:Flowby/widgets/no_results.dart';
import 'package:Flowby/widgets/profile_picture.dart';
import 'package:Flowby/widgets/tab_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Flowby/services/location_service.dart';
import 'package:Flowby/models/search_mode.dart';
import 'package:Flowby/widgets/mark_inappropriate_dialog.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/models/helper_functions.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  Future<List<User>> usersFuture;

  @override
  void initState() {
    super.initState();
    final algoliaService = Provider.of<AlgoliaService>(context, listen: false);
    usersFuture = algoliaService.getUsers(searchTerm: '');
  }

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<User>(context);
    final searchMode = Provider.of<SearchMode>(context);

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TabHeader(
            leftIcon: Icon(Feather.info),
            screenToNavigateToLeft: ExplanationScreen(
              popScreen: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SearchBar(
                onSearchSubmitted: _onSearchSubmitted,
                onSearchChanged: _onSearchChanged),
          ),
          CupertinoSegmentedControl(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            groupValue: searchMode.mode,
            onValueChanged: searchMode.setMode,
            children: <Mode, Widget>{
              Mode.searchSkills: Text(
                  AppLocalizations.of(context).translate('skills'),
                  style: kHomeSwitchTextStyle),
              Mode.searchWishes: Text(
                  AppLocalizations.of(context).translate('wishes'),
                  style: kHomeSwitchTextStyle),
            },
          ),
          Expanded(
            child: FutureBuilder(
                future: usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return CenteredLoadingIndicator();
                  }
                  if (snapshot.hasError) {
                    print(
                        'getting users from algolia got an error = ${snapshot.error.toString()}');
                    return Center(
                      child: Container(
                        color: Colors.red,
                        child: Text(AppLocalizations.of(context)
                            .translate('something_went_wrong')),
                      ),
                    );
                  }

                  List<User> allMatchedUsers =
                      List.from(snapshot.data); // to convert it editable list

                  List<User> usersToShow;
                  if (searchMode.mode == Mode.searchSkills) {
                    //show only the users that have skills
                    usersToShow = allMatchedUsers
                        .where((u) =>
                            !u.isHidden &&
                            u.skills.length > 0 &&
                            !(u.uid == loggedInUser?.uid))
                        .toList();
                  } else {
                    //show only the users that have wishes
                    usersToShow = allMatchedUsers
                        .where((u) =>
                            !u.isHidden &&
                            u.wishes.length > 0 &&
                            !(u.uid == loggedInUser?.uid))
                        .toList();
                  }

                  if (usersToShow.length == 0 && loggedInUser != null) {
                    return NoResults(
                      uidOfLoggedInUser: loggedInUser.uid,
                    );
                  }
                  return ListOfSortedUsers(unsortedUsers: usersToShow);
                }),
          ),
        ],
      ),
    );
  }

  _onSearchSubmitted(String submittedSearchTerm) {
    final algoliaService = Provider.of<AlgoliaService>(context, listen: false);
    setState(() {
      usersFuture = algoliaService.getUsers(searchTerm: submittedSearchTerm);
    });
  }

  _onSearchChanged(String newSearchTerm) {
    if (newSearchTerm == '') {
      final algoliaService =
          Provider.of<AlgoliaService>(context, listen: false);
      setState(() {
        usersFuture = algoliaService.getUsers(searchTerm: newSearchTerm);
      });
    }
  }
}

class ListOfSortedUsers extends StatelessWidget {
  final List<User> unsortedUsers;

  ListOfSortedUsers({@required this.unsortedUsers});

  @override
  Widget build(BuildContext context) {
    final searchMode = Provider.of<SearchMode>(context, listen: false);
    return FutureBuilder(
      future: _sortUsersByDistanceAndGetCity(
          context: context, users: unsortedUsers),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CenteredLoadingIndicator();
        }
        if (snapshot.hasError) {
          print(
              'error occured while waiting and sorting the users by distance. error = ${snapshot.error.toString()}');
          return Container(
            color: Colors.red,
            child: Text(
              AppLocalizations.of(context).translate('something_went_wrong'),
            ),
          );
        }
        List<User> sortedUsers = snapshot.data;

        return ListView.builder(
          itemBuilder: (context, index) {
            return ProfileItem(
              user: sortedUsers[index],
              isSkillSearch: searchMode.mode == Mode.searchSkills,
            );
          },
          itemCount: sortedUsers.length,
        );
      },
    );
  }

  Future<List<User>> _sortUsersByDistanceAndGetCity(
      {@required BuildContext context, @required List<User> users}) async {
    final loggedInUser = Provider.of<User>(context);
    final locationService =
        Provider.of<LocationService>(context, listen: false);
    final position = Provider.of<Position>(context);

    Position currentUsersLocation;
    if (loggedInUser == null) {
      currentUsersLocation = position;
    } else {
      currentUsersLocation = Position(
          latitude: loggedInUser.location?.latitude,
          longitude: loggedInUser.location?.longitude);
    }
    List<Future<int>> distanceFutures = [];
    List<Future<String>> cityFutures = [];

    for (User user in users) {
      distanceFutures.add(locationService.distanceBetween(
          startLatitude: currentUsersLocation?.latitude,
          startLongitude: currentUsersLocation?.longitude,
          endLatitude: user?.location?.latitude,
          endLongitude: user?.location?.longitude));
      cityFutures.add(locationService.getCity(
          latitude: user?.location?.latitude,
          longitude: user?.location?.longitude));
    }

    List<int> distances = await Future.wait(distanceFutures);
    List<String> cities = await Future.wait(cityFutures);

    List<User> usersWithDistanceAndCity = [];
    for (int i = 0; i < users.length; i++) {
      User userWithDistanceAndCity = users[i];
      userWithDistanceAndCity.distanceInKm = distances[i];
      userWithDistanceAndCity.currentCity = cities[i];
      usersWithDistanceAndCity.add(userWithDistanceAndCity);
    }
    usersWithDistanceAndCity
        .sort((user1, user2) => user1.distanceInKm - user2.distanceInKm);
    return usersWithDistanceAndCity;
  }
}

class ProfileItem extends StatelessWidget {
  final isSkillSearch;
  final User user;

  ProfileItem({@required this.user, this.isSkillSearch = true});

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<User>(context);
    final String heroTag = user.uid + 'home';

    return CustomCard(
      leading:
          ProfilePicture(imageUrl: user.imageUrl, radius: 30, heroTag: heroTag),
      middle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                user.username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: kUsernameTextStyle,
              ),
              if (user.distanceInKm != kAlmostInfiniteDistanceInKm &&
                  user.currentCity != null &&
                  user.currentCity != '')
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Icon(
                          Feather.navigation,
                          size: 10,
                          color: kBlueButtonColor,
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Text(
                          ' ' +
                              user.currentCity +
                              ', ' +
                              user.distanceInKm.toString() +
                              'km',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: kBlueButtonColor,
                              fontSize: 10,
                              fontFamily: 'MuliRegular'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            isSkillSearch ? user.skillKeywords : user.wishKeywords,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: kCardSubtitleTextStyle,
          ),
        ],
      ),
      onPress: () {
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute<void>(
            builder: (context) {
              return ViewProfileScreen(
                  user: user,
                  heroTag: heroTag,
                  loggedInUser: loggedInUser,
                  showSkills: isSkillSearch);
            },
          ),
        );
      },
      onLongPress: () {
        _showMarkInappropriateDialog(context: context, user: user);
      },
    );
  }

  _showMarkInappropriateDialog({BuildContext context, User user}) async {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    final navigator = Navigator.of(context, rootNavigator: true);
    HelperFunctions.showCustomDialog(
      context: context,
      dialog: MarkInappropriateDialog(onWantsToMark: () {
        cloudFirestoreService.incrementUserFlagged(uid: user.uid);
        navigator.pop();
      }),
    );
  }
}

class SearchBar extends StatelessWidget {
  SearchBar({@required this.onSearchChanged, @required this.onSearchSubmitted});

  final Function onSearchChanged;
  final Function onSearchSubmitted;

  @override
  Widget build(BuildContext context) {
    SearchMode searchMode = Provider.of<SearchMode>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: CupertinoTextField(
        decoration: BoxDecoration(
            color: kCardBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        placeholder: (searchMode.mode == Mode.searchSkills)
            ? AppLocalizations.of(context).translate('search_skills')
            : AppLocalizations.of(context).translate('search_wishes'),
        placeholderStyle: kSearchPlaceHolderTextStyle,
        prefix: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(
            Feather.search,
            color: CupertinoColors.black,
          ),
        ),
        onChanged: onSearchChanged,
        onSubmitted: onSearchSubmitted,
        style: kSearchTextStyle,
        clearButtonMode: OverlayVisibilityMode.editing,
      ),
    );
  }
}
