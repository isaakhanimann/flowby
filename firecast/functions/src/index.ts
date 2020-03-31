// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
import functions = require("firebase-functions");

// The Firebase Admin SDK to access the Firebase Realtime Database.
import admin = require("firebase-admin");
import { EventContext } from "firebase-functions";
const path = require("path");
const algoliasearch = require("algoliasearch");

const APP_ID = functions.config().algolia.app;
const ADMIN_KEY = functions.config().algolia.key;

const client = algoliasearch(APP_ID, ADMIN_KEY);
const index = client.initIndex("users");

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

// erstelle cloud function

//add user to algolia users index when a user is added to firestore
exports.addToIndex = functions.firestore
  .document("users/{userId}")
  .onCreate(snapshot => {
    const data = snapshot.data();
    //every algolia object needs an objectID (written exactly like this), we choose objectID == uid so we have an easy 1-1 mapping
    const objectID = snapshot.id;
    return index.addObject({ ...data, objectID });
  });

//update user in algolia users index when a user is updated in firestore
exports.updateIndex = functions.firestore
  .document("users/{userId}")
  .onUpdate(change => {
    const newData = change.after.data();
    const objectID = change.after.id;
    return index.saveObject({ ...newData, objectID });
  });

//delete user in algolia users index when a user is deleted in firestore
exports.deleteFromIndex = functions.firestore
  .document("users/{userId}")
  .onDelete(snapshot => index.deleteObject(snapshot.id));

// when a message is added update the lastMessageText field of the respective chat
exports.createMessageUpdateChat = functions.firestore
  .document("/chats/{chatId}/messages/{messageId}")
  .onCreate((snap: any, context: any) => {
    //access wildcards
    const chatId = context.params.chatId;
    const messageId = context.params.messageId;
    console.log(`New message ${messageId} in chat ${chatId}`);
    // Get an object representing the document
    const newMessage = snap.data();

    // to add to or update a document use update(), set() replaces the whole document
    return snap.ref.parent.parent.update({
      lastMessageText: newMessage.text,
      lastMessageTimestamp: newMessage.timestamp
    });
  });

// when the username or imageUrl of a user is changed update all the chats that contain that user (find them with uid)
exports.updateUserUpdateChat = functions.firestore
  .document("/users/{userId}")
  .onUpdate(async (change: any, context: any) => {
    // Get an object representing the document
    const newUser = change.after.data();
    // ...or the previous value before this update
    const previousUser = change.before.data();
    // if the username changed change all the chats
    if (
      previousUser.username !== newUser.username ||
      previousUser.imageUrl !== newUser.imageUrl
    ) {
      try {
        // First update all the chats where the user is user1
        const querySnapshot = await db
          .collection("chats")
          .where("user1.uid", "==", newUser.uid)
          .get();
        querySnapshot.forEach((documentSnapshot: any) => {
          if (documentSnapshot.exists) {
            db.collection("chats")
              .doc(documentSnapshot.ref.id)
              .update({
                "user1.username": newUser.username,
                "user1.imageUrl": newUser.imageUrl
              })
              .catch((error: any) => {
                console.log("Error updating chat1:", error);
              });
          }
        });
      } catch (error) {
        console.log("Error getting chats1:", error);
      }
      try {
        // Then update all the chats where the user is user2
        const querySnapshot = await db
          .collection("chats")
          .where("user2.uid", "==", newUser.uid)
          .get();
        querySnapshot.forEach((documentSnapshot: any) => {
          if (documentSnapshot.exists) {
            db.collection("chats")
              .doc(documentSnapshot.ref.id)
              .update({
                "user2.username": newUser.username,
                "user2.imageUrl": newUser.imageUrl
              })
              .catch((error: any) => {
                console.log("Error updating chat2:", error);
              });
          }
        });
      } catch (error) {
        console.log("Error getting chats2:", error);
      }
    }
  });

// when the firebase user is deleted the user in the users collection, his chats and image should also be deleted
exports.deleteUserEveryhere = functions.auth
  .user()
  .onDelete(async (user: any) => {
    // delete the user in the users collection
    db.collection("users")
      .doc(user.uid)
      .delete()
      .catch(function(error: any) {
        console.log(
          `Error deleting user out of users collection, uid =  ${user.uid}`
        );
      });

    // delete the image with his uid as the file name
    const bucket = admin.storage().bucket();
    bucket
      .file(`images/${user.uid}`)
      .delete()
      .then(function() {
        // File deleted successfully
        console.log(`Deleted image ${user.uid} successfully`);
      })
      .catch(function(error: any) {
        console.log(`Could not delete the image ${user.uid}`);
      });

    // delete all the chats he was part of
    // First delete all the chats where the user is user1
    db.collection("chats")
      .where("uid1", "==", user.uid)
      .get()
      .then((querySnapshot: any) => {
        querySnapshot.forEach((documentSnapshot: any) => {
          if (documentSnapshot.exists) {
            db.collection("chats")
              .doc(documentSnapshot.ref.id)
              .delete()
              .then(() => {
                console.log(
                  `Chat ${documentSnapshot.ref.id} deleted successfully`
                );
              })
              .catch(function(error: any) {
                console.log(`Error deleting chat ${documentSnapshot.ref.id}`);
              });
          }
        });
      })
      .catch((error: any) => {
        console.log("Error getting chat:", error);
      });
    // Then delete all the chats where the user is user2
    db.collection("chats")
      .where("uid2", "==", user.uid)
      .get()
      .then((querySnapshot: any) => {
        querySnapshot.forEach((documentSnapshot: any) => {
          if (documentSnapshot.exists) {
            db.collection("chats")
              .doc(documentSnapshot.ref.id)
              .delete()
              .then(() => {
                console.log(
                  `Chat ${documentSnapshot.ref.id} deleted successfully`
                );
              })
              .catch((error: any) => {
                console.log("Error deleting chat:", error);
              });
          }
        });
      })
      .catch((error: any) => {
        console.log("Error getting chat:", error);
      });

    // delete all announcements this user made
    db.collection("announcements")
      .where("user.uid", "==", user.uid)
      .get()
      .then((querySnapshot: any) => {
        querySnapshot.forEach((documentSnapshot: any) => {
          if (documentSnapshot.exists) {
            db.collection("announcements")
              .doc(documentSnapshot.ref.id)
              .delete()
              .then(() => {
                console.log(
                  `Announcement ${documentSnapshot.ref.id} deleted successfully`
                );
              })
              .catch((error: any) => {
                console.log("Error deleting announcement:", error);
              });
          }
        });
      })
      .catch((error: any) => {
        console.log("Error getting announcement:", error);
      });
  });

exports.sendNotification = functions.firestore
  .document("chats/{chatId}/messages/{messageId}")
  .onCreate(
    async (snap: FirebaseFirestore.DocumentSnapshot, context: EventContext) => {
      const message: FirebaseFirestore.DocumentData = snap.data()!;

      const senderUid: string = message.senderUid;
      const contentMessage: string = message.text;

      const chatId = context.params.chatId;
      const chatSnap: FirebaseFirestore.DocumentSnapshot = await db
        .collection("chats")
        .doc(chatId)
        .get();
      const chat: FirebaseFirestore.DocumentData = chatSnap.data()!;

      let receiverUid: string = "";
      let senderUsername: string = "";

      if (senderUid === chat.uid1) {
        //the sender is user1 of the chat
        receiverUid = chat.uid2;
        senderUsername = chat.username1;
      } else {
        receiverUid = chat.uid1;
        senderUsername = chat.username2;
      }
      // Get the sender's imageFileName
      const senderDoc = await db
        .collection("users")
        .doc(senderUid)
        .get();

      const sender = senderDoc.data();

      // Get the receiver's token
      const receiverDoc = await db
        .collection("users")
        .doc(receiverUid)
        .get();

      const receiver = receiverDoc.data();

      if (receiver?.pushToken) {
        const payload = {
          notification: {
            title: senderUsername,
            body: contentMessage,
            badge: "1",
            sound: "default"
          },
          data: {
            click_action: "FLUTTER_NOTIFICATION_CLICK",
            sound: "default",
            status: "done",
            screen: "ChatScreen",
            loggedInUid: receiverUid,
            otherUid: senderUid,
            otherUsername: senderUsername,
            otherImageFileName: sender?.imageFileName,
            otherImageVersionNumber: sender?.imageVersionNumber
              ? (sender?.imageVersionNumber).toString()
              : "1",
            chatPath: "chats/" + chatId
          }
        };
        // send the push notification to the receivers device
        return fcm
          .sendToDevice(receiver.pushToken, payload)
          .then((response: any) => {
            console.log("Successfully sent message:", response);
            console.log("payload:", payload);
          })
          .catch((error: any) => {
            console.log("Error sending message:", error);
          });
      } else {
        console.log("Can not find pushToken target user");
        return null;
      }
    }
  );

// when the username of a user is changed update all the chats that contain that username (find them with uid)
exports.oldUpdateUsernameUpdateChat = functions.firestore
  .document("/users/{userId}")
  .onUpdate(async (change: any, context: any) => {
    // Get an object representing the document
    const newUser = change.after.data();
    // ...or the previous value before this update
    const previousUser = change.before.data();
    // if the username changed change all the chats
    if (previousUser.username !== newUser.username) {
      try {
        // First update all the chats where the user is user1
        const querySnapshot = await db
          .collection("chats")
          .where("uid1", "==", newUser.uid)
          .get();
        querySnapshot.forEach((documentSnapshot: any) => {
          if (documentSnapshot.exists) {
            db.collection("chats")
              .doc(documentSnapshot.ref.id)
              .update({ username1: newUser.username })
              .catch((error: any) => {
                console.log("Error updating chat1:", error);
              });
          }
        });
      } catch (error) {
        console.log("Error getting chats1:", error);
      }
      try {
        // Then update all the chats where the user is user2
        const querySnapshot = await db
          .collection("chats")
          .where("uid2", "==", newUser.uid)
          .get();
        querySnapshot.forEach((documentSnapshot: any) => {
          if (documentSnapshot.exists) {
            db.collection("chats")
              .doc(documentSnapshot.ref.id)
              .update({ username1: newUser.username })
              .catch((error: any) => {
                console.log("Error updating chat2:", error);
              });
          }
        });
      } catch (error) {
        console.log("Error getting chats2:", error);
      }
    }
  });

// when an image is added to storage update its users imageFileName and also all the chats the user is in
// a user can only upload an image with the same filename as his uid
// if the imageFileName of the user (in users collection) is already his uid no update has to be made
exports.oldUpdateImageUpdateUserAndChats = functions.storage
  .object()
  .onFinalize(async (object: any) => {
    const filePath = object.name; // File path in the bucket.
    // Get the file name, this should be the uid of the user
    const uid = path.basename(filePath);
    const userDoc = await db
      .collection("users")
      .doc(uid)
      .get();

    const imageVersionNumber = userDoc?.data()?.imageVersionNumber;
    let newImageVersionNumber = 1;
    if (imageVersionNumber !== null) {
      newImageVersionNumber = imageVersionNumber + 1;
    }

    // Update the user in the users collection
    db.collection("users")
      .doc(uid)
      .update({ imageFileName: uid, imageVersionNumber: newImageVersionNumber })
      .then(() => {
        console.log(`Users imageFileName updated to ${uid}`);
      })
      .catch((error: any) => {
        console.log("Error updating imageFileName:", error);
      });
    // Update all the chats of this user to have the same imageFileName
    // First update all the chats where the user is user1
    db.collection("chats")
      .where("uid1", "==", uid)
      .get()
      .then((querySnapshot: any) => {
        querySnapshot.forEach((documentSnapshot: any) => {
          if (documentSnapshot.exists) {
            db.collection("chats")
              .doc(documentSnapshot.ref.id)
              .update({
                user1ImageFileName: uid,
                user1ImageVersionNumber: newImageVersionNumber
              })
              .then(() => {
                console.log(`Users user1ImageFileName updated to ${uid}`);
              })
              .catch((error: any) => {
                console.log("Error updating chat:", error);
              });
          }
        });
      })
      .catch((error: any) => console.log(error));
    // Then update all the chats where the user is user2
    db.collection("chats")
      .where("uid2", "==", uid)
      .get()
      .then((querySnapshot: any) => {
        querySnapshot.forEach((documentSnapshot: any) => {
          if (documentSnapshot.exists) {
            db.collection("chats")
              .doc(documentSnapshot.ref.id)
              .update({
                user2ImageFileName: uid,
                user2ImageVersionNumber: newImageVersionNumber
              })
              .then(() => {
                console.log(`Users user2ImageFileName updated to ${uid}`);
              })
              .catch((error: any) => {
                console.log("Error updating chat:", error);
              });
          }
        });
      })
      .catch((error: any) => {
        console.log("Error getting chat:", error);
      });
  });

  // update the number of unread messages of a chat from an user perspective
exports.updateUnreadMessagesInChat = functions.firestore
.document("chats/{chatId}/messages/{messageId}")
.onCreate(
  async (snap: FirebaseFirestore.DocumentSnapshot, context: EventContext) => {

    const message: FirebaseFirestore.DocumentData = snap.data()!;

    const senderUid: string = message.senderUid;
    let receiverUid: string = "";
      
    const chatId = context.params.chatId;
    const chatSnap: FirebaseFirestore.DocumentSnapshot = await db
      .collection("chats")
      .doc(chatId)
      .get();
    
    const chat: FirebaseFirestore.DocumentData = chatSnap.data()!;
  
    let unreadMessages1: number = 0;
    let unreadMessages2: number = 0;

    if (senderUid === chat.uid1) {
      //
      // the receiver is user2 of the chat
      //
      receiverUid = chat.uid2;
      if(chat?.unreadMessages2){
        unreadMessages2 = chat.unreadMessages2;
        unreadMessages2 += 1;
      } else {
        unreadMessages2 = 1;
      }

      db.collection("chats")
      .doc(chatId)
      .update({
        unreadMessages2: unreadMessages2
      })
      .then(() => {
        console.log(`Successful update: User2 has ${unreadMessages2} unread messages`);
      })
      .catch((error: any) => {
        console.log(`Error updating the number of unread messages of user1:`, error);
      });
    } else {
      //
      // the receiver is user1 of the chat
      //
      receiverUid = chat.uid1;
      if(chat?.unreadMessages1){
        unreadMessages1 = chat.unreadMessages1;
        unreadMessages1 += 1;
      } else {
        unreadMessages1 = 1;
      }

      db.collection("chats")
      .doc(chatId)
      .update({
        unreadMessages1: unreadMessages1
      })
      .then(() => {
        console.log(`Successful update: User1 has ${unreadMessages1} unread messages`);
      })
      .catch((error: any) => {
        console.log(`Error updating the number of unread messages of user2:`, error);
      });
    }

    //TODO: create a new document if the user doesn't have an unreadMessagesDoc yet

    const unreadMessagesSnap: FirebaseFirestore.DocumentSnapshot = await db
      .collection("users")
      .doc(receiverUid)
      .get();

    const unreadMessages: FirebaseFirestore.DocumentData = unreadMessagesSnap.data()!;
    let total: number = unreadMessages.total + 1;

    return db.collection("users")
      .doc(receiverUid)
      .update({
        totalUnreadMessages: total
      })
      .then(() => {
        console.log(`Successful update: User ${receiverUid} has a total of ${total} unread messages`);
      })
      .catch((error: any) => {
        console.log(`Error updating the total number of unread messages of user ${receiverUid}:`, error);
      });
});
