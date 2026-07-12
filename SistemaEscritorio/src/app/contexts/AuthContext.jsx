import { createContext, useState, useEffect } from 'react';
import { authController } from '../controllers/AuthController';
import { User } from '../core/models/User';

export const AuthContext = createContext({});

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = authController.onAuthChange((firebaseUser) => {
      if (firebaseUser) {
        const userInstance = new User({
          id: firebaseUser.uid,
          email: firebaseUser.email,
        });
        setUser(userInstance);
      } else {
        setUser(null);
      }
      setLoading(false);
    });

    return unsubscribe;
  }, []);

  const signIn = async (email, password) => {
    const user = await authController.signIn(email, password);
    setUser(user);
    return user;
  };

  const signOut = async () => {
    await authController.signOut();
    setUser(null);
  };

  const value = { user, loading, signIn, signOut };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
};