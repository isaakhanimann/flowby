import 'package:Flowby/constants.dart';
import 'package:Flowby/models/helper_functions.dart';
import 'package:Flowby/screens/view_profile_screen.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/widgets/centered_loading_indicator.dart';
import 'package:Flowby/widgets/custom_dialog.dart';
import 'package:Flowby/widgets/distance_text.dart';
import 'package:Flowby/widgets/profile_picture.dart';
import 'package:Flowby/widgets/tab_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/models/announcement.dart';
import 'package:Flowby/screens/explanationscreens/explanation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Flowby/models/role.dart';
import 'package:Flowby/widgets/custom_card.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Future<List<Announcement>> announcementsFuture;
  bool isFetchingAnnouncements = true;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    scrollController.addListener(() {
      if (scrollController.position.pixels < -250 && !isFetchingAnnouncements) {
        isFetchingAnnouncements = true;
        setState(() {
          announcementsFuture = cloudFirestoreService.getAnnouncements();
        });
      }
    });
    announcementsFuture = cloudFirestoreService.getAnnouncements();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<User>(context);
    final localRole = Provider.of<Role>(context);

    final role = loggedInUser?.role ?? localRole;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TabHeader(
            leftIcon: Icon(Feather.info),
            screenToNavigateToLeft: ExplanationScreen(
              role: role,
            ),
            rightIcon: Icon(Feather.plus),
            onPressedRight: _addAnnouncement,
          ),
          Expanded(
              child: FutureBuilder(
                  future: announcementsFuture,
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
                    List<Announcement> announcements = List.from(
                        snapshot.data); // to convert it to editable list
                    isFetchingAnnouncements = false;
                    return ListView.builder(
                        controller: scrollController,
                        itemCount: announcements.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                              child: Text(
                                'Announcements',
                                style: kTabTitleTextStyle,
                                textAlign: TextAlign.start,
                              ),
                            );
                          }
                          Announcement announcement = announcements[index - 1];
                          return AnnouncementItem(
                            announcement: announcement,
                            heroTag: announcement.user.uid +
                                announcement.timestamp.toString() +
                                'announcements',
                          );
                        });
                  }))
        ],
      ),
    );
  }

  _addAnnouncement() async {
    final loggedInUser = Provider.of<User>(context, listen: false);

    if (loggedInUser.isHidden) {
      HelperFunctions.showCustomDialog(
        context: context,
        dialog: YourProfileIsHiddenDialog(),
      );
    } else {
      HelperFunctions.showCustomDialog(
        context: context,
        dialog: AddAnnouncementDialog(
          loggedInUser: loggedInUser,
        ),
      );
    }
  }
}

class YourProfileIsHiddenDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Your profile is hidden',
              style: kDialogTitleTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'You cannot add announcements because your profile is hidden',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'MuliRegular',
                color: kTextFieldTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            CupertinoButton(
              child: Text(
                'Ok',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'MuliBold',
                  color: kDefaultProfilePicColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddAnnouncementDialog extends StatefulWidget {
  final User loggedInUser;

  AddAnnouncementDialog({this.loggedInUser});

  @override
  _AddAnnouncementDialogState createState() => _AddAnnouncementDialogState();
}

class _AddAnnouncementDialogState extends State<AddAnnouncementDialog> {
  String announcementText = '';

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'What do you want to announce?',
              style: kDialogTitleTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15,
            ),
            CupertinoTextField(
              autofocus: true,
              showCursor: true,
              expands: true,
              minLines: null,
              maxLines: null,
              decoration: BoxDecoration(color: kCardBackgroundColor),
              onChanged: (newText) {
                announcementText = newText;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CupertinoButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'MuliRegular',
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                CupertinoButton(
                  child: Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'MuliBold',
                      color: kDefaultProfilePicColor,
                    ),
                  ),
                  onPressed: () async {
                    final cloudFirestoreService =
                        Provider.of<FirebaseCloudFirestoreService>(context,
                            listen: false);

                    Announcement announcement = Announcement(
                      user: widget.loggedInUser,
                      timestamp: FieldValue.serverTimestamp(),
                      text: announcementText,
                    );
                    await cloudFirestoreService.uploadAnnouncement(
                        announcement: announcement);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AnnouncementItem extends StatelessWidget {
  final Announcement announcement;
  final String heroTag;

  AnnouncementItem({@required this.announcement, @required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final User loggedInUser = Provider.of<User>(context);

    print('currentPosition: ${loggedInUser.location}');
    print('announcementPosition: ${announcement.user?.location}');
    return CustomCard(
      paddingInsideVertical: 15,
      leading: ProfilePicture(
        imageFileName: announcement.user.imageFileName,
        imageVersionNumber: announcement.user.imageVersionNumber,
        radius: 30,
        heroTag: heroTag,
      ),
      middle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                announcement.user.username,
                overflow: TextOverflow.ellipsis,
                style: kUsernameTextStyle,
              ),
              DistanceText(
                latitude1: loggedInUser.location?.latitude,
                longitude1: loggedInUser.location?.longitude,
                latitude2: announcement.user?.location?.latitude,
                longitude2: announcement.user?.location?.longitude,
                fontSize: 10,
              ),
              Text(
                HelperFunctions.getTimestampAsString(
                    timestamp: announcement.timestamp),
                overflow: TextOverflow.ellipsis,
                style: kChatTabTimestampTextStyle,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            announcement.text,
            textAlign: TextAlign.start,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: kChatLastMessageTextStyle,
          ),
        ],
      ),
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  _onPressed(BuildContext context) {
    final loggedInUser = Provider.of<User>(context, listen: false);
    User announcementUser = announcement.user;
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute<void>(
        builder: (context) {
          return ViewProfileScreen(
              user: announcementUser,
              heroTag: heroTag,
              loggedInUser: loggedInUser);
        },
      ),
    );
  }
}
