import { initializeApp, getApps, getApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
import firebaseConfig from "./config";

if (!getApps().length) {
  initializeApp(firebaseConfig);
}

export const db = getFirestore();
