/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const { initializeApp } = require("firebase-admin/app");
const { getMessaging } = require("firebase-admin/messaging");
const { onDocumentCreated, onDocumentUpdated } = require("firebase-functions/v2/firestore");

initializeApp();


exports.onNotificationCreated = onDocumentCreated("/Notifications/{docId}", async (change) => {
    const original = change.data.data();
    logger.log(original.topic)
    const message = {
        "topic": original.topic,
        "notification": {
            "title": original.title,
            "body": original.body
        },
        "data": {
            "story_id": "story_12345"
        },
        "android": {
            "notification": {
                "click_action": original.clickAction
            }
        },
        "apns": {
            "payload": {
                "aps": {
                    "category": "NEW_MESSAGE_CATEGORY",
                    "sound": original.sound
                }
            }
        }
    };
    await getMessaging().send(message);
    // Return a promise if performing asynchronous operations
    return null;
});

exports.onValueUpdate = onDocumentUpdated("/Live/count", async (change) => {
    // Get the current document
    const newValue = change.data.after.data();

    // Check if the updated value is less than zero
    if (newValue.value < 0) {
        // Update the value to zero
        await change.data.after.ref.set({ value: 0 }, { merge: true });
        logger.log(`Value was below zero. Updated to 0.`);
    } else {
        // Log the unchanged value
        logger.log(`Value is ${newValue.value} and was not changed.`);
    }

    // Return a promise if performing asynchronous operations
    return null;
});


// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
