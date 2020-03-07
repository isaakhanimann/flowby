import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/explanationscreens/explanation_screen.dart';
import 'package:Flowby/screens/view_profile_screen.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/widgets/centered_loading_indicator.dart';
import 'package:Flowby/widgets/no_results.dart';
import 'package:Flowby/widgets/tab_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/services/location_service.dart';
import 'package:Flowby/models/role.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  FocusNode _focusNode;

  TextEditingController _controller;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _focusNode = new FocusNode();
    _controller = TextEditingController()..addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<User>(context);
    final localRole = Provider.of<Role>(context);

    final role = loggedInUser?.role ?? localRole;

    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    return StreamBuilder<List<User>>(
      stream:
          cloudFirestoreService.getUsersStream(uidToExclude: loggedInUser?.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CenteredLoadingIndicator();
        }
        List<User> allUsers =
            List.from(snapshot.data); // to convert it editable list
        List<User> allNotHiddenUsers =
            allUsers.where((u) => !u.isHidden).toList();
        List<User> searchResultUsers;

        if (role == Role.consumer) {
          searchResultUsers = allNotHiddenUsers
              .where((u) =>
                  u.role == Role.provider &&
                  u.skillKeywords != '' &&
                  u.skillKeywords
                      .toString()
                      .toLowerCase()
                      .contains(_searchTerm.toLowerCase()))
              .toList();
        } else {
          searchResultUsers = allNotHiddenUsers
              .where((u) =>
                  u.role == Role.consumer &&
                  u.wishKeywords != '' &&
                  u.wishKeywords
                      .toString()
                      .toLowerCase()
                      .contains(_searchTerm.toLowerCase()))
              .toList();
        }

        return SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              TabHeader(
                rightIcon: Icon(Feather.info),
                rightAction: ExplanationScreen(
                  role: role,
                ),
              ),
              GestureDetector(
                onTap: setFocus,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: SearchBar(
                    focusNode: _focusNode,
                    isSkillSearch: role == Role.consumer,
                    controller: _controller,
                  ),
                ),
              ),
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    if (notification.scrollDelta.abs() > 10 &&
                        notification.dragDetails != null)
                      FocusScope.of(context).unfocus();
                  }
                  //debugPrint('$notification');
                  return true;
                },
                child: Expanded(
                  child: searchResultUsers.length == 0 && loggedInUser != null
                      ? NoResults(
                          isSkillSelected: role == Role.consumer,
                          uidOfLoggedInUser: loggedInUser.uid,
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            return ProfileItem(
                              user: searchResultUsers[index],
                              isSkillSearch: role == Role.consumer,
                            );
                          },
                          itemCount: searchResultUsers.length,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onTextChanged() {
    setState(() {
      _searchTerm = _controller.text;
    });
  }

  void setFocus() {
    FocusScope.of(context).requestFocus(_focusNode);
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
    var currentPosition = Provider.of<Position>(context);
    final locationService =
        Provider.of<LocationService>(context, listen: false);

    return Card(
      elevation: 0,
      color: kCardBackgroundColor,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Center(
        child: ListTile(
          onTap: () {
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
          leading: CachedNetworkImage(
            imageUrl:
                "https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${user.imageFileName}?alt=media&version=${user.imageVersionNumber}",
            imageBuilder: (context, imageProvider) {
              return Hero(
                transitionOnUserGestures: true,
                tag: heroTag,
                child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: imageProvider),
              );
            },
            placeholder: (context, url) => CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Text(
                  user.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: kUsernameTextStyle,
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: FutureBuilder(
                  future: locationService.distanceBetween(
                      startLatitude: currentPosition?.latitude,
                      startLongitude: currentPosition?.longitude,
                      endLatitude: user.location?.latitude,
                      endLongitude: user.location?.longitude),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done ||
                        snapshot.hasError) {
                      return Text('');
                    }

                    int distanceInKm = snapshot.data;
                    user.distanceInKm = distanceInKm;
                    if (distanceInKm == null) {
                      return Text('');
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      mainAxisAlignment: MainAxisAlignment.end,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Icon(
                            Feather.navigation,
                            size: 12,
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Text(
                            ' ' + distanceInKm.toString() + 'km',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kLocationTextStyle,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          subtitle: Text(
            isSkillSearch ? user.skillKeywords : user.wishKeywords,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: kCardSubtitleTextStyle,
          ),
          trailing: Icon(Feather.chevron_right),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    @required this.controller,
    @required this.isSkillSearch,
    @required this.focusNode,
  });

  final TextEditingController controller;
  final isSkillSearch;
  final focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: CupertinoTextField(
        decoration: BoxDecoration(
            color: kCardBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        focusNode: focusNode,
        placeholder: isSkillSearch ? 'Search Skills' : 'Search Wishes',
        placeholderStyle: kSearchPlaceHolderTextStyle,
        prefix: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(
            Feather.search,
            color: CupertinoColors.black,
          ),
        ),
        controller: controller,
        style: kSearchTextStyle,
        clearButtonMode: OverlayVisibilityMode.editing,
      ),
    );
  }
}
