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
import 'package:Flowby/models/role.dart';
import 'package:Flowby/widgets/distance_text.dart';

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
    final localRole = Provider.of<Role>(context);

    final role = loggedInUser?.role ?? localRole;

    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          TabHeader(
            leftIcon: Icon(Feather.info),
            screenToNavigateToLeft: ExplanationScreen(
              role: role,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: SearchBar(
                isSkillSearch: role == Role.consumer,
                onSearchSubmitted: _onSearchSubmitted,
                onSearchChanged: _onSearchChanged),
          ),
          Expanded(
            child: FutureBuilder(
                future: usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return CenteredLoadingIndicator();
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Container(
                        color: Colors.red,
                        child: const Text('Something went wrong'),
                      ),
                    );
                  }

                  List<User> allMatchedUsers =
                      List.from(snapshot.data); // to convert it editable list
                  List<User> allVisibleUsers = allMatchedUsers
                      .where(
                          (u) => !u.isHidden && !(u.uid == loggedInUser?.uid))
                      .toList();
                  List<User> searchResultUsers;

                  if (role == Role.consumer) {
                    searchResultUsers = allVisibleUsers
                        .where((u) => u.role == Role.provider)
                        .toList();
                  } else {
                    searchResultUsers = allVisibleUsers
                        .where((u) => u.role == Role.consumer)
                        .toList();
                  }

                  if (searchResultUsers.length == 0 && loggedInUser != null) {
                    return NoResults(
                      isSkillSelected: role == Role.consumer,
                      uidOfLoggedInUser: loggedInUser.uid,
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return ProfileItem(
                        user: searchResultUsers[index],
                        isSkillSearch: role == Role.consumer,
                      );
                    },
                    itemCount: searchResultUsers.length,
                  );
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

class ProfileItem extends StatelessWidget {
  final isSkillSearch;
  final User user;

  ProfileItem({@required this.user, this.isSkillSearch = true});

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<User>(context);
    final String heroTag = user.uid + 'home';

    return CustomCard(
      leading: ProfilePicture(
          imageFileName: user.imageFileName,
          imageVersionNumber: user.imageVersionNumber,
          radius: 30,
          heroTag: heroTag),
      middle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
              DistanceText(
                latitude1: loggedInUser.location?.latitude,
                longitude1: loggedInUser.location?.longitude,
                latitude2: user.location?.latitude,
                longitude2: user.location?.latitude,
                fontSize: 10,
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
      onPressed: () {
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
    );
  }
}

class SearchBar extends StatelessWidget {
  SearchBar(
      {@required this.isSkillSearch,
      @required this.onSearchChanged,
      @required this.onSearchSubmitted});

  final isSkillSearch;
  final Function onSearchChanged;
  final Function onSearchSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: CupertinoTextField(
        decoration: BoxDecoration(
            color: kCardBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        placeholder: 'Search Skills',
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
