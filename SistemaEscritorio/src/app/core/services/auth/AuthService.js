import { 
  signInWithEmailAndPassword,
  signOut as firebaseSignOut,
  onAuthStateChanged
} from 'firebase/auth';
import { auth } from '../../../core/config/firebase';
import { User } from '../../models/User';
import { BaseRepository } from '../../repository/BaseRepository';

class AuthService {
  constructor() {
    this.userRepository = new BaseRepository('users');
  }

  /**
   * Iniciar sesión
   */
  async signIn(email, password) {
    try {
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      const firebaseUser = userCredential.user;
      
      // Obtener datos adicionales del usuario desde Firestore
      const userData = await this.userRepository.findById(firebaseUser.uid);
      const user = new User({
        id: firebaseUser.uid,
        email: firebaseUser.email,
        ...userData
      });
      
      return user;
    } catch (error) {
      console.error('Error signing in:', error);
      throw error;
    }
  }

  /**
   * Cerrar sesión
   */
  async signOut() {
    try {
      await firebaseSignOut(auth);
    } catch (error) {
      console.error('Error signing out:', error);
      throw error;
    }
  }

  /**
   * Obtener usuario actual
   */
  getCurrentUser() {
    return auth.currentUser;
  }

  /**
   * Escuchar cambios en la autenticación
   */
  onAuthChange(callback) {
    return onAuthStateChanged(auth, callback);
  }

  /**
   * Obtener información del usuario desde Firestore
   */
  async getUserInfo(userId) {
    try {
      const data = await this.userRepository.findById(userId);
      return data ? new User(data) : null;
    } catch (error) {
      console.error('Error getting user info:', error);
      throw error;
    }
  }
}

export const authService = new AuthService();
export default authService;