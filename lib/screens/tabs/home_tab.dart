import 'package:Flowby/constants.dart';
import 'package:Flowby/models/helper_functions.dart';
import 'package:Flowby/screens/view_profile_screen.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/widgets/centered_loading_indicator.dart';
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
    showCupertinoDialog(
      context: context,
      builder: (_) => Dialog(
        loggedInUser: loggedInUser,
      ),
    );
  }
}

class Dialog extends StatefulWidget {
  final User loggedInUser;

  Dialog({this.loggedInUser});

  @override
  _DialogState createState() => _DialogState();
}

class _DialogState extends State<Dialog> {
  String announcementText = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('What do you want to announce?'),
      content: CupertinoTextField(
        onChanged: (newText) {
          announcementText = newText;
        },
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        CupertinoDialogAction(
          child: Text('Add'),
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
          isDefaultAction: true,
        ),
      ],
    );
  }
}

class AnnouncementItem extends StatelessWidget {
  final Announcement announcement;
  final String heroTag;

  AnnouncementItem({@required this.announcement, @required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
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
              Flexible(
                flex: 2,
                child: Text(
                  announcement.user.username,
                  overflow: TextOverflow.ellipsis,
                  style: kUsernameTextStyle,
                ),
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
      onPressed: _onPressed,
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
