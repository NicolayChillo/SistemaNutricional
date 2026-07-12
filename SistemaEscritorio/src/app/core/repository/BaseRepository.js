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
import { db } from '../../core/config/firebase';

/**
 * Repositorio base para operaciones CRUD en Firestore
 * Implementa el patrón Repository
 */
export class BaseRepository {
  constructor(collectionName) {
    this.collectionName = collectionName;
    this.collectionRef = collection(db, collectionName);
  }

  /**
   * Obtiene todos los documentos de la colección
   * @param {Object} options - Opciones de consulta
   * @param {string} options.orderByField - Campo para ordenar
   * @param {string} options.orderDirection - 'asc' o 'desc'
   * @param {number} options.limit - Límite de resultados
   * @param {Array} options.filters - Filtros [field, operator, value]
   */
  async findAll(options = {}) {
    try {
      let q = this.collectionRef;

      // Aplicar filtros
      if (options.filters && options.filters.length > 0) {
        options.filters.forEach(filter => {
          q = query(q, where(filter[0], filter[1], filter[2]));
        });
      }

      // Aplicar orden
      if (options.orderByField) {
        q = query(q, orderBy(
          options.orderByField,
          options.orderDirection || 'desc'
        ));
      }

      // Aplicar límite
      if (options.limit) {
        q = query(q, limit(options.limit));
      }

      const snapshot = await getDocs(q);
      return this._mapDocs(snapshot);
    } catch (error) {
      console.error(`Error getting ${this.collectionName}:`, error);
      throw error;
    }
  }

  /**
   * Obtiene un documento por su ID
   */
  async findById(id) {
    try {
      const docRef = doc(db, this.collectionName, id);
      const docSnap = await getDoc(docRef);
      
      if (docSnap.exists()) {
        return this._mapDoc(docSnap);
      }
      return null;
    } catch (error) {
      console.error(`Error getting ${this.collectionName} by id:`, error);
      throw error;
    }
  }

  /**
   * Crea un nuevo documento
   */
  async create(data) {
    try {
      const docRef = await addDoc(this.collectionRef, {
        ...data,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now()
      });
      return docRef.id;
    } catch (error) {
      console.error(`Error creating ${this.collectionName}:`, error);
      throw error;
    }
  }

  /**
   * Actualiza un documento existente
   */
  async update(id, data) {
    try {
      const docRef = doc(db, this.collectionName, id);
      await updateDoc(docRef, {
        ...data,
        updatedAt: Timestamp.now()
      });
    } catch (error) {
      console.error(`Error updating ${this.collectionName}:`, error);
      throw error;
    }
  }

  /**
   * Elimina un documento
   */
  async delete(id) {
    try {
      const docRef = doc(db, this.collectionName, id);
      await deleteDoc(docRef);
    } catch (error) {
      console.error(`Error deleting ${this.collectionName}:`, error);
      throw error;
    }
  }

  /**
   * Mapea un documento de Firestore
   */
  _mapDoc(docSnap) {
    const data = docSnap.data();
    return {
      id: docSnap.id,
      ...data,
      createdAt: data.createdAt?.toDate?.() || data.createdAt,
      updatedAt: data.updatedAt?.toDate?.() || data.updatedAt,
    };
  }

  /**
   * Mapea múltiples documentos
   */
  _mapDocs(snapshot) {
    return snapshot.docs.map(doc => this._mapDoc(doc));
  }
}