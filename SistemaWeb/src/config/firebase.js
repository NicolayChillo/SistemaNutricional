// Firebase configuration
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
import { getStorage } from "firebase/storage";

const firebaseConfig = {
  apiKey: "AIzaSyCMI_TFqdJekskhWyW0nTRlF2ZUAezADFU",
  authDomain: "nutricional-76dd0.firebaseapp.com",
  projectId: "nutricional-76dd0",
  storageBucket: "nutricional-76dd0.firebasestorage.app",
  messagingSenderId: "192679934948",
  appId: "1:192679934948:web:3e783ecf2d68be519c25f1"
};



// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize services
export const auth = getAuth(app);
export const db = getFirestore(app);
export const storage = getStorage(app);

export default app;
