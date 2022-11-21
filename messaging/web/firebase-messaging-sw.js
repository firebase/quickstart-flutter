importScripts('https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js');

// Replace this with values from the firebase console for your web app.
const firebaseConfig = {
  apiKey: "",
  authDomain: "",
  databaseURL: "",
  projectId: "",
  storageBucket: "",
  messagingSenderId: "",
  appId: "",
  measurementId: ""
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
  const notificationTitle = "title";
  const notificationOptions = {
    body: 'Background Message body.',
    icon: 'icons/Icon-maskable-512.png'
  };
  self.registration.showNotification(notificationTitle,
    notificationOptions);
});