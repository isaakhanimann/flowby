import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/helper_functions.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/settings_screen.dart';
import 'package:float/screens/view_profile_screen.dart';
import 'package:float/services/firebase_cloud_firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool isSkillSelected = true;
  void switchSearch(var newIsSelected) {
    setState(() {
      isSkillSelected = !isSkillSelected;
    });
  }

  TextEditingController _controller;
  FocusNode _focusNode;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_onTextChanged);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _searchTerm = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);
    var currentPosition = Provider.of<Position>(context);

    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    return StreamBuilder<List<User>>(
      stream: cloudFirestoreService.getUsersStreamWithDistance(
          position: currentPosition, uidToExclude: loggedInUser?.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        List<User> allUsers =
            List.from(snapshot.data); // to convert it editable list
        List<User> searchResultUsers;

        if (isSkillSelected) {
          searchResultUsers = allUsers
              .where((u) => u.hasSkills)
              .where((u) => u.skillHashtags
                  .toString()
                  .toLowerCase()
                  .contains(_searchTerm.toLowerCase()))
              .toList();
        } else {
          searchResultUsers = allUsers
              .where((u) => u.hasWishes)
              .where((u) => u.wishHashtags
                  .toString()
                  .toLowerCase()
                  .contains(_searchTerm.toLowerCase()))
              .toList();
        }
        searchResultUsers.sort((user1, user2) =>
            (user1.distanceInKm ?? 1000).compareTo(user2.distanceInKm ?? 1000));

        return CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              backgroundColor: CupertinoColors.white,
              border: null,
              middle: Image(image: AssetImage("assets/images/logo_flowby.png"), height: 40.0,),
              largeTitle: Text('Search', style: kTabsLargeTitleTextStyle,),
            ),
            SliverSafeArea(
              top: false,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: SearchBar(
                          isSkillSearch: isSkillSelected,
                          controller: _controller,
                          focusNode: _focusNode,
                        ),
                      );
                    } else if (index == 1) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: CupertinoSegmentedControl(
                          groupValue: isSkillSelected,
                          onValueChanged: switchSearch,
                          children: <bool, Widget>{
                            true:
                                Text('Skills', style: TextStyle(fontSize: 18)),
                            false:
                                Text('Wishes', style: TextStyle(fontSize: 18)),
                          },
                        ),
                      );
                    } else if (index < searchResultUsers.length + 2) {
                      return ProfileItem(
                        user: searchResultUsers[index - 2],
                        isSkillSearch: isSkillSelected,
                      );
                    }
                    return null;
                  },
                  childCount: searchResultUsers.length + 2,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProfileItem extends StatelessWidget {
  final isSkillSearch;
  final User user;

  ProfileItem({@required this.user, this.isSkillSearch = true});

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);
    final String heroTag = user.uid + 'home';

    return Card(
      elevation: 0,
      color: kLightGrey2,
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
          leading: Hero(
            tag: heroTag,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${user.imageFileName}?alt=media'),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                user.username ?? 'Default',
                style: kUsernameTextStyle,
              ),
              if (user.distanceInKm != null)
                Text(
                  user.distanceInKm.toString() + ' km',
                  style: kLocationTextStyle,
                )
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  HelperFunctions.getDotDotDotString(
                      maybeLongString: isSkillSearch
                          ? user.skillHashtags
                          : user.wishHashtags),
                  style: kSkillTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  (isSkillSearch ? user.skillRate : user.wishRate).toString() +
                      ' CHF/h',
                  style: kLocationTextStyle,
                ),
              ),
            ],
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
    @required this.focusNode,
    @required this.isSkillSearch,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final isSkillSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: CupertinoTextField(
        decoration: BoxDecoration(
            color: kLightGrey2,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.symmetric(vertical: 10),
        placeholder: isSkillSearch ? 'Search Skills' : 'Search Wishes',
        placeholderStyle: TextStyle(fontSize: 16, color: kPlaceHolderColor),
        prefix: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(
            Feather.search,
            color: CupertinoColors.black,
          ),
        ),
        controller: controller,
        focusNode: focusNode,
        style: kSearchText,
      ),
    );
  }
}
