const firebaseConfig = {
  apiKey: process.env.FIREBASE_API_KEY || "AIzaSyA1nRqcqds5CeQsA7ElMlbfRNhUvzYuw-I",
  authDomain: process.env.FIREBASE_AUTH_DOMAIN || "smart-chef-ef910.firebaseapp.com",
  projectId: process.env.FIREBASE_PROJECT_ID || "smart-chef-ef910",
  storageBucket: process.env.FIREBASE_STORAGE_BUCKET || "smart-chef-ef910.firebasestorage.app",
  messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID || "654346857124",
  appId: process.env.FIREBASE_APP_ID || "1:654346857124:android:9edeaa183007d1bdea5431",
};

export default firebaseConfig;
