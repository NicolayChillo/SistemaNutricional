import { db } from '../core/config/firebase';
import { collection, getDocs } from 'firebase/firestore';

export class StatisticsController {
  
  async getStatistics() {
    try {
      const [productsSnap, recipesSnap, calendarSnap] = await Promise.all([
        getDocs(collection(db, 'products')),
        getDocs(collection(db, 'recipes')),
        getDocs(collection(db, 'calendar'))
      ]);

      return {
        totalProducts: productsSnap.size || 0,
        totalRecipes: recipesSnap.size || 0,
        totalCalendarEntries: calendarSnap.size || 0
      };
    } catch (error) {
      console.error('Error getting statistics:', error);
      return {
        totalProducts: 0,
        totalRecipes: 0,
        totalCalendarEntries: 0
      };
    }
  }
}

export const statisticsController = new StatisticsController();