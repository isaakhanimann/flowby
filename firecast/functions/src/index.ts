// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
constfunctions = require("firebase-functions");

// The Firebase Admin SDK to access the Firebase Realtime Database.
constadmin = require("firebase-admin");
constpath = require("path");

admin.initializeApp();

const db = admin.firestore();

// erstelle cloud function
// when a message is added scan it for the string "pizza" and replace it with the emoji
exports.createMessageWithPizza = functions.firestore
  .document("/chats/{chatId}/messages/{messageId}")
  .onCreate((snap: any, context: any) => {
    //access wildcards
    const chatId = context.params.chatId;
    const messageId = context.params.messageId;
    console.log(`New message ${messageId} in chat ${chatId}`);
    // Get an object representing the document
    const newMessage = snap.data();

    // access a particular field as you would any JS property
    const text = addPizzas(newMessage.text);

    // perform desired operations ...
    return snap.ref.update({ text: text });
  });

function addPizzas(text: string) {
  return text.replace(/\bpizza\b/g, "🍕");
}

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

// when the username of a user is changed update all the chats that contain that username (find them with uid)
exports.updateUsernameUpdateChat = functions.firestore
  .document("/users/{userId}")
  .onUpdate((change: any, context: any) => {
    // Get an object representing the document
    const newUser = change.after.data();
    // ...or the previous value before this update
    const previousUser = change.before.data();
    // if the username changed change all the chats
    if (previousUser.username != newUser.username) {
      // First update all the chats where the user is user1
      db.collection("chats")
        .where("uid1", "==", newUser.uid)
        .get()
        .then((querySnapshot: any) => {
          querySnapshot.forEach((documentSnapshot: any) => {
            if (documentSnapshot.exists) {
              db.collection("chats")
                .doc(documentSnapshot.ref.id)
                .update({ username1: newUser.username })
                .then(() => {
                  console.log(`Users username1 updated to ${newUser.username}`);
                });
            }
          });
        });
      // Then update all the chats where the user is user2
      db.collection("chats")
        .where("uid2", "==", newUser.uid)
        .get()
        .then((querySnapshot: any) => {
          querySnapshot.forEach((documentSnapshot: any) => {
            if (documentSnapshot.exists) {
              db.collection("chats")
                .doc(documentSnapshot.ref.id)
                .update({ username2: newUser.username })
                .then(() => {
                  console.log(`Users username2 updated to ${newUser.username}`);
                });
            }
          });
        });
    }
  });

// when an image is added to storage update its users imageFileName and also all the chats the user is in
// a user can only upload an image with the same filename as his uid
// if the imageFileName of the user (in users collection) is already his uid no update has to be made
exports.updateImageUpdateUserAndChats = functions.storage
  .object()
  .onFinalize(async (object: any) => {
    const filePath = object.name; // File path in the bucket.
    // Get the file name, this should be the uid of the user
    const uid = path.basename(filePath);
    // Exit if the user already had a unique imageFileName
    const doc = await db
      .collection("users")
      .doc(uid)
      .get();
    if (doc.exists) {
      if (doc.data().imageFileName == uid) {
        console.log(
          "ImageFileName is already uid so it does not need to be changed anywhere"
        );
        return;
      }
    }
    // Update the user in the users collection
    db.collection("users")
      .doc(uid)
      .update({ imageFileName: uid })
      .then(() => {
        console.log(`Users imageFileName updated to ${uid}`);
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
              .update({ user1ImageFileName: uid })
              .then(() => {
                console.log(`Users user1ImageFileName updated to ${uid}`);
              });
          }
        });
      });
    // Then update all the chats where the user is user2
    db.collection("chats")
      .where("uid2", "==", uid)
      .get()
      .then((querySnapshot: any) => {
        querySnapshot.forEach((documentSnapshot: any) => {
          if (documentSnapshot.exists) {
            db.collection("chats")
              .doc(documentSnapshot.ref.id)
              .update({ user2ImageFileName: uid })
              .then(() => {
                console.log(`Users user2ImageFileName updated to ${uid}`);
              });
          }
        });
      });
  });

// when the firebase user is deleted the user in the users collection, his chats and image should also be deleted
exports.deleteUserEveryhere = functions.auth
  .user()
  .onDelete(async (user: any) => {
    // delete the user in the users collection
    db.collection("users")
      .doc(user.uid)
      .delete();

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
        // Uh-oh, an error occurred!
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
              });
          }
        });
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
              });
          }
        });
      });
  });

exports.sendNotification = functions.firestore
  .document('chats/{chatId}/messages/{messageId}')
  .onCreate((snap, context) => {
    console.log('----------------start function--------------------');

    const doc = snap.data();
    console.log(doc);

    const senderUid = doc.senderUid;
    const receiverUid = doc.receiverUid;
    const contentMessage = doc.text;

    // Get push token user to (receive)
    admin
      .firestore()
      .collection('users')
      .where('uid', '==', receiverUid)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(receiver => {
          console.log(`Found user to: ${receiver.data().username}`);
          if (receiver.data().pushToken) {
            // Get info user from (sent)
            admin
              .firestore()
              .collection('users')
              .where('uid', '==', senderUid)
              .get()
              .then(querySnapshot2 => {
                querySnapshot2.forEach(sender => {
                  console.log(`Found user from: ${sender.data().username}`);
                  const payload = {
                    notification: {
                      title: `${sender.data().username}`,
                      body: contentMessage,
                      badge: '1',
                      sound: 'default'
                    }
                  }
                  // Let push to the target device
                  admin
                    .messaging()
                    .sendToDevice(receiver.data().pushToken, payload)
                    .then(response => {
                      console.log('Successfully sent message:', response);
                    });
                    .catch(error => {
                      console.log('Error sending message:', error)
                    });
                });
              });
          } else {
            console.log('Can not find pushToken target user');
          }
        });
      });
    return null;
  });

