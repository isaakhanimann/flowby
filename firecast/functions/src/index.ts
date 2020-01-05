// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require("firebase-functions");

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

//erstelle cloud function

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

exports.createMessageUpdateChat = functions.firestore
  .document("/chats/{chatId}/messages/{messageId}")
  .onCreate((snap: any, context: any) => {
    //access wildcards
    const chatId = context.params.chatId;
    const messageId = context.params.messageId;
    console.log(`New message ${messageId} in chat ${chatId}`);
    // Get an object representing the document
    const newMessage = snap.data();

    // perform desired operations ...
    return snap.ref.parent.parent.update({
      lastMessageText: newMessage.text,
      lastMessageTimestamp: newMessage.timestamp
    });
  });

// const db = admin.firestore();

// //write data to database
// const quoteData = {
//   quote: "new quote2",
//   author: "new author2"
// };
// db.collection("sampleData")
//   .doc("inspiration")
//   .set(quoteData)
//   .then(() => {
//     console.log("New quote written to database");
//   });

// //read data from database
// db.collection("users")
//   .doc("isaak@gmail.com")
//   .get()
//   .then(doc => {
//     if (!doc.exists) {
//       console.log("No such document");
//     }
//     //do stuff with data
//     const obj = doc.data();
//     console.log(`The username is ${obj.username}`);
//   })
//   .catch(err => {
//     console.error("Error getting document", err);
//     process.exit();
//   });

//mache etwas wenn ein firebaseuser created wird
// exports.createAuthUserCreateUserinUsersCollection = functions.auth
//   .user()
//   .onCreate((user: any) => {
//     const newUser = {
//       uid: user.uid
//     };
//     db.collection("users")
//       .doc(newUser.uid)
//       .set(newUser)
//       .then(() => {
//         console.log("New user created in users collection");
//       });
//   });
