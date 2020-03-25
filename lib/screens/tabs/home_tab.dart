import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/constants.dart';
import 'package:Flowby/models/helper_functions.dart';
import 'package:Flowby/screens/view_profile_screen.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/widgets/basic_dialog.dart';
import 'package:Flowby/widgets/centered_loading_indicator.dart';
import 'package:Flowby/widgets/custom_dialog.dart';
import 'package:Flowby/widgets/distance_text.dart';
import 'package:Flowby/widgets/profile_picture.dart';
import 'package:Flowby/widgets/tab_header.dart';
import 'package:Flowby/widgets/two_options_dialog.dart';
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

  @override
  void initState() {
    super.initState();
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    announcementsFuture = cloudFirestoreService.getAnnouncements();
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
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
            child: Text(
              AppLocalizations.of(context).translate('announcements'),
              style: kTabTitleTextStyle,
              textAlign: TextAlign.start,
            ),
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
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('something_went_wrong'),
                          ),
                        ),
                      );
                    }
                    List<Announcement> announcements = List.from(
                        snapshot.data); // to convert it to editable list
                    isFetchingAnnouncements = false;
                    return ListOfAnnouncements(
                      announcements: announcements,
                      isFetchingAnnouncements: isFetchingAnnouncements,
                      fetchNewAnnouncements: _fetchAnnouncements,
                    );
                  }))
        ],
      ),
    );
  }

  _fetchAnnouncements() async {
    isFetchingAnnouncements = true;
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    setState(() {
      announcementsFuture = cloudFirestoreService.getAnnouncements();
    });
  }

  _addAnnouncement() async {
    final loggedInUser = Provider.of<User>(context, listen: false);
    bool areSkillsEmpty =
        loggedInUser.skills == null || loggedInUser.skills.isEmpty;

    bool areWishesEmpty =
        loggedInUser.wishes == null || loggedInUser.wishes.isEmpty;

    bool isProvider = loggedInUser.role == Role.provider;
    bool isConsumer = loggedInUser.role == Role.consumer;
    if (loggedInUser.isHidden ||
        (isProvider && areSkillsEmpty) ||
        (isConsumer && areWishesEmpty)) {
      HelperFunctions.showCustomDialog(
        context: context,
        dialog: BasicDialog(
          title:
              AppLocalizations.of(context).translate('your_profile_is_hidden'),
          text: AppLocalizations.of(context)
              .translate('you_cannot_add_announcements'),
        ),
      );
    } else {
      HelperFunctions.showCustomDialog(
        context: context,
        dialog: AddAnnouncementDialog(
          loggedInUser: loggedInUser,
          reloadAnnouncements: _fetchAnnouncements,
        ),
      );
    }
  }
}

class ListOfAnnouncements extends StatefulWidget {
  final List<Announcement> announcements;
  final bool isFetchingAnnouncements;
  final Function fetchNewAnnouncements;

  ListOfAnnouncements(
      {@required this.announcements,
      @required this.isFetchingAnnouncements,
      @required this.fetchNewAnnouncements});

  @override
  _ListOfAnnouncementsState createState() => _ListOfAnnouncementsState();
}

class _ListOfAnnouncementsState extends State<ListOfAnnouncements> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels < -150 &&
          !widget.isFetchingAnnouncements) {
        widget.fetchNewAnnouncements();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: scrollController,
        itemCount: widget.announcements.length,
        itemBuilder: (context, index) {
          Announcement announcement = widget.announcements[index];

          return AnnouncementItem(
            announcement: announcement,
            heroTag: announcement.user.uid +
                announcement.timestamp.toString() +
                'announcements',
            onLongPress: _deleteAnnouncement,
          );
        });
  }

  _deleteAnnouncement({BuildContext context, Announcement announcement}) async {
    final loggedInUser = Provider.of<User>(context, listen: false);
    if (announcement.user.uid == loggedInUser.uid) {
      HelperFunctions.showCustomDialog(
        context: context,
        dialog: DeleteAnnouncementDialog(
          announcement: announcement,
          reloadAnnouncements: widget.fetchNewAnnouncements,
        ),
      );
    } else {
      HelperFunctions.showCustomDialog(
        context: context,
        dialog: BasicDialog(
          title: AppLocalizations.of(context).translate('cannot_delete'),
          text: AppLocalizations.of(context).translate('can_only_delete_own'),
        ),
      );
    }
  }
}

class DeleteAnnouncementDialog extends StatelessWidget {
  final Announcement announcement;
  final Function reloadAnnouncements;

  DeleteAnnouncementDialog(
      {@required this.announcement, @required this.reloadAnnouncements});

  @override
  Widget build(BuildContext context) {
    return TwoOptionsDialog(
      title: AppLocalizations.of(context).translate('delete_announcement'),
      text: AppLocalizations.of(context)
          .translate('really_want_to_delete_announcement'),
      rightActionText: AppLocalizations.of(context).translate('delete'),
      rightAction: () async {
        final cloudFirestoreService =
            Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
        await cloudFirestoreService.deleteAnnouncement(
            announcement: announcement);
        reloadAnnouncements();
        Navigator.of(context).pop();
      },
      rightActionColor: Colors.red,
    );
  }
}

class AddAnnouncementDialog extends StatefulWidget {
  final User loggedInUser;
  final Function reloadAnnouncements;

  AddAnnouncementDialog(
      {@required this.loggedInUser, @required this.reloadAnnouncements});

  @override
  _AddAnnouncementDialogState createState() => _AddAnnouncementDialogState();
}

class _AddAnnouncementDialogState extends State<AddAnnouncementDialog> {
  String announcementText = '';

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).translate('what_to_announce'),
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
                  padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Text(
                    AppLocalizations.of(context).translate('cancel'),
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'MuliRegular',
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                CupertinoButton(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text(
                    AppLocalizations.of(context).translate('add'),
                    style: TextStyle(
                      fontSize: 16,
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
                    widget.reloadAnnouncements();
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
  final Function onLongPress;

  AnnouncementItem(
      {@required this.announcement,
      @required this.heroTag,
      @required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final User loggedInUser = Provider.of<User>(context);
    return CustomCard(
      onPress: () {
        _onPressed(context: context);
      },
      onLongPress: () {
        onLongPress(context: context, announcement: announcement);
      },
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
                    context: context, timestamp: announcement.timestamp),
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
    );
  }

  _onPressed({BuildContext context}) {
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
