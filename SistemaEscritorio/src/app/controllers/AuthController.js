import authService from '../core/services/auth/AuthService';

/**
 * Controlador de autenticación
 * Maneja la lógica de negocio relacionada con autenticación
 */
export class AuthController {
  constructor() {
    this.authService = authService;
  }

  /**
   * Iniciar sesión
   */
  async signIn(email, password) {
    try {
      if (!email || !password) {
        throw new Error('Email y contraseña son requeridos');
      }
      
      const user = await this.authService.signIn(email, password);
      return user;
    } catch (error) {
      console.error('AuthController.signIn error:', error);
      throw error;
    }
  }

  /**
   * Cerrar sesión
   */
  async signOut() {
    try {
      await this.authService.signOut();
    } catch (error) {
      console.error('AuthController.signOut error:', error);
      throw error;
    }
  }

  /**
   * Obtener usuario actual
   */
  getCurrentUser() {
    return this.authService.getCurrentUser();
  }

  /**
   * Escuchar cambios en autenticación
   */
  onAuthChange(callback) {
    return this.authService.onAuthChange(callback);
  }

  /**
   * Obtener información del usuario
   */
  async getUserInfo(userId) {
    try {
      return await this.authService.getUserInfo(userId);
    } catch (error) {
      console.error('AuthController.getUserInfo error:', error);
      throw error;
    }
  }
}

export const authController = new AuthController();
export default authController;