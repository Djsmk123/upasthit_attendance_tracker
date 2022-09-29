importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
 apiKey: "AIzaSyA6MsaFR2_HMpK3vwWRygnRJOXQFfiaCls",

  authDomain: "attendacetracker-98c35.firebaseapp.com",

  projectId: "attendacetracker-98c35",

  storageBucket: "attendacetracker-98c35.appspot.com",

  messagingSenderId: "174701045341",

  appId: "1:174701045341:web:63edb0cc23c1f5d32acfb4",

  measurementId: "G-SXBZ6DHKNW"

});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});