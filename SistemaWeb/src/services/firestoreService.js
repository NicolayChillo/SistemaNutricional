import {
  collection,
  query,
  where,
  getDocs,
  getDoc,
  doc,
  addDoc,
  updateDoc,
  deleteDoc,
  orderBy,
  Timestamp,
  limit
} from 'firebase/firestore';
import { db } from '../config/firebase';

// ============ USERS ============
export const getUsers = async () => {
  try {
    const usersRef = collection(db, 'users');
    const snapshot = await getDocs(usersRef);
    return snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }));
  } catch (error) {
    console.error('Error getting users:', error);
    throw error;
  }
};

export const getUserById = async (userId) => {
  try {
    const userRef = doc(db, 'users', userId);
    const userSnap = await getDoc(userRef);
    if (userSnap.exists()) {
      return { id: userSnap.id, ...userSnap.data() };
    }
    return null;
  } catch (error) {
    console.error('Error getting user:', error);
    throw error;
  }
};

// Get user login history
export const getUserLoginHistory = async (userId) => {
  try {
    const loginsRef = collection(db, 'user_logins');
    const q = query(
      loginsRef,
      where('userId', '==', userId),
      orderBy('timestamp', 'desc'),
      limit(50)
    );
    const snapshot = await getDocs(q);
    return snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
      timestamp: doc.data().timestamp?.toDate()
    }));
  } catch (error) {
    console.error('Error getting login history:', error);
    return [];
  }
};

// ============ PRODUCTS ============
export const getProducts = async () => {
  try {
    const productsRef = collection(db, 'products');
    const q = query(productsRef, orderBy('createdAt', 'desc'));
    const snapshot = await getDocs(q);
    return snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
      createdAt: doc.data().createdAt?.toDate()
    }));
  } catch (error) {
    console.error('Error getting products:', error);
    throw error;
  }
};

export const getProductById = async (productId) => {
  try {
    const productRef = doc(db, 'products', productId);
    const productSnap = await getDoc(productRef);
    if (productSnap.exists()) {
      return {
        id: productSnap.id,
        ...productSnap.data(),
        createdAt: productSnap.data().createdAt?.toDate()
      };
    }
    return null;
  } catch (error) {
    console.error('Error getting product:', error);
    throw error;
  }
};

export const createProduct = async (productData) => {
  try {
    const productsRef = collection(db, 'products');
    const docRef = await addDoc(productsRef, {
      ...productData,
      createdAt: Timestamp.now()
    });
    return docRef.id;
  } catch (error) {
    console.error('Error creating product:', error);
    throw error;
  }
};

export const updateProduct = async (productId, productData) => {
  try {
    const productRef = doc(db, 'products', productId);
    await updateDoc(productRef, productData);
  } catch (error) {
    console.error('Error updating product:', error);
    throw error;
  }
};

export const deleteProduct = async (productId) => {
  try {
    const productRef = doc(db, 'products', productId);
    await deleteDoc(productRef);
  } catch (error) {
    console.error('Error deleting product:', error);
    throw error;
  }
};

// ============ RECIPES ============
export const getRecipes = async () => {
  try {
    const recipesRef = collection(db, 'recipes');
    const q = query(recipesRef, orderBy('createdAt', 'desc'));
    const snapshot = await getDocs(q);
    return snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
      createdAt: doc.data().createdAt?.toDate()
    }));
  } catch (error) {
    console.error('Error getting recipes:', error);
    throw error;
  }
};

export const getRecipeById = async (recipeId) => {
  try {
    const recipeRef = doc(db, 'recipes', recipeId);
    const recipeSnap = await getDoc(recipeRef);
    if (recipeSnap.exists()) {
      return {
        id: recipeSnap.id,
        ...recipeSnap.data(),
        createdAt: recipeSnap.data().createdAt?.toDate()
      };
    }
    return null;
  } catch (error) {
    console.error('Error getting recipe:', error);
    throw error;
  }
};

export const createRecipe = async (recipeData) => {
  try {
    const recipesRef = collection(db, 'recipes');
    const docRef = await addDoc(recipesRef, {
      ...recipeData,
      createdAt: Timestamp.now()
    });
    return docRef.id;
  } catch (error) {
    console.error('Error creating recipe:', error);
    throw error;
  }
};

export const updateRecipe = async (recipeId, recipeData) => {
  try {
    const recipeRef = doc(db, 'recipes', recipeId);
    await updateDoc(recipeRef, recipeData);
  } catch (error) {
    console.error('Error updating recipe:', error);
    throw error;
  }
};

export const deleteRecipe = async (recipeId) => {
  try {
    const recipeRef = doc(db, 'recipes', recipeId);
    await deleteDoc(recipeRef);
  } catch (error) {
    console.error('Error deleting recipe:', error);
    throw error;
  }
};

// ============ CALENDAR ENTRIES ============
export const getCalendarEntries = async () => {
  try {
    const entriesRef = collection(db, 'calendar');
    const q = query(entriesRef, orderBy('scheduledDate', 'desc'));
    const snapshot = await getDocs(q);
    return snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
      scheduledDate: doc.data().scheduledDate?.toDate(),
      createdAt: doc.data().createdAt?.toDate()
    }));
  } catch (error) {
    console.error('Error getting calendar entries:', error);
    throw error;
  }
};

export const getCalendarEntryById = async (entryId) => {
  try {
    const entryRef = doc(db, 'calendar', entryId);
    const entrySnap = await getDoc(entryRef);
    if (entrySnap.exists()) {
      return {
        id: entrySnap.id,
        ...entrySnap.data(),
        scheduledDate: entrySnap.data().scheduledDate?.toDate(),
        createdAt: entrySnap.data().createdAt?.toDate()
      };
    }
    return null;
  } catch (error) {
    console.error('Error getting calendar entry:', error);
    throw error;
  }
};

export const createCalendarEntry = async (entryData) => {
  try {
    const entriesRef = collection(db, 'calendar');
    const docRef = await addDoc(entriesRef, {
      ...entryData,
      scheduledDate: Timestamp.fromDate(new Date(entryData.scheduledDate)),
      createdAt: Timestamp.now(),
      notificationSent: false
    });
    return docRef.id;
  } catch (error) {
    console.error('Error creating calendar entry:', error);
    throw error;
  }
};

export const updateCalendarEntry = async (entryId, entryData) => {
  try {
    const entryRef = doc(db, 'calendar', entryId);
    const updateData = { ...entryData };
    if (entryData.scheduledDate) {
      updateData.scheduledDate = Timestamp.fromDate(new Date(entryData.scheduledDate));
    }
    await updateDoc(entryRef, updateData);
  } catch (error) {
    console.error('Error updating calendar entry:', error);
    throw error;
  }
};

export const deleteCalendarEntry = async (entryId) => {
  try {
    const entryRef = doc(db, 'calendar', entryId);
    await deleteDoc(entryRef);
  } catch (error) {
    console.error('Error deleting calendar entry:', error);
    throw error;
  }
};

// ============ STATISTICS ============
export const getStatistics = async () => {
  try {
    const [users, products, recipes, entries] = await Promise.all([
      getDocs(collection(db, 'users')),
      getDocs(collection(db, 'products')),
      getDocs(collection(db, 'recipes')),
      getDocs(collection(db, 'calendar'))
    ]);

    return {
      totalUsers: users.size,
      totalProducts: products.size,
      totalRecipes: recipes.size,
      totalCalendarEntries: entries.size
    };
  } catch (error) {
    console.error('Error getting statistics:', error);
    throw error;
  }
};
