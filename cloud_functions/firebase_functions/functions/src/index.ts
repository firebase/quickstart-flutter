import * as functions from "firebase-functions";
import { HttpsError, onCall } from "firebase-functions/v2/https";
// Uncomment to enforce appcheck
// import {appCheck} from "firebase-admin";

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

export const callablevtwo = onCall((request) => {
    const data = request.data;
    // Uncomment to enforce app check
    // const appCheckData = request.app;
    // if (!appCheckData) {
    //     return new HttpsError("unauthenticated", "Attestation Missing");
    // }
    // Uncomment to enforce authorizations
    // const auth = request.auth;
    // if(!auth?.uid) {
    //     return new HttpsError("unauthenticated", "User is not authenticated");
    // }
    if (!data.word) {
        return new HttpsError("invalid-argument", "Missing 'word' parameter");
    }
    return `You sent me : ${data.word}`;
});

export const callablevone = functions
    .runWith({
        allowInvalidAppCheckToken: true  // Opt-out: Requests with invalid App
        // Check tokens continue to your code.
    })
    .https.onCall((data, context) => {
        if (!data.word) {
            return new HttpsError("invalid-argument", "Missing 'word' parameter");
        }
        return `You sent me : ${data.word}`;
    });
