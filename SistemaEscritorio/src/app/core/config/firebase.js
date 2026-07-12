import { initializeApp } from "firebase/app";
import { 
  getAuth, 
  setPersistence, 
  browserLocalPersistence
} from "firebase/auth";
import { getFirestore, enableIndexedDbPersistence } from "firebase/firestore";
import { getStorage } from "firebase/storage";

const originalConsoleWarn = console.warn;
console.warn = (...args) => {
  if (args[0]?.includes?.('enableIndexedDbPersistence() will be deprecated')) {
    return; // Ignorar este warning específico
  }
  originalConsoleWarn(...args);
};

const firebaseConfig = {
  apiKey: "AIzaSyCMI_TFqdJekskhWyW0nTRlF2ZUAezADFU",
  authDomain: "nutricional-76dd0.firebaseapp.com",
  projectId: "nutricional-76dd0",
  storageBucket: "nutricional-76dd0.firebasestorage.app",
  messagingSenderId: "192679934948",
  appId: "1:192679934948:web:3e783ecf2d68be519c25f1"
};

// Inicializar Firebase
const app = initializeApp(firebaseConfig);

// Auth
const auth = getAuth(app);

// Configurar persistencia para Electron
(async () => {
  try {
    await setPersistence(auth, browserLocalPersistence);
    console.log('✅ Firebase persistence configured');
  } catch (error) {
    console.error('❌ Error setting persistence:', error);
  }
})();

// Firestore
const db = getFirestore(app);

// Habilitar persistencia offline
if (typeof window !== 'undefined') {
  enableIndexedDbPersistence(db)
    .then(() => console.log('✅ Firestore offline persistence enabled'))
    .catch((err) => {
      if (err.code === 'failed-precondition') {
        console.warn('⚠️ Multiple tabs open, persistence only enabled in one tab');
      } else if (err.code === 'unimplemented') {
        console.warn('⚠️ Browser doesn\'t support IndexedDB');
      }
    });
}

const storage = getStorage(app);

export { app, auth, db, storage };