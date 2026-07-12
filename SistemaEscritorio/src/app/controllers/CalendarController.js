import calendarService from '../core/services/calendar/CalendarService';

export class CalendarController {
  constructor() {
    this.calendarService = calendarService;
  }

  async getAllEntries() {
    try {
      return await this.calendarService.getAllEntries();
    } catch (error) {
      console.error('CalendarController.getAllEntries error:', error);
      throw error;
    }
  }

  async getEntryById(id) {
    try {
      if (!id) throw new Error('ID de entrada requerido');
      return await this.calendarService.getEntryById(id);
    } catch (error) {
      console.error('CalendarController.getEntryById error:', error);
      throw error;
    }
  }

  async createEntry(entryData) {
    try {
      if (!entryData.userId || !entryData.recipeId) {
        throw new Error('Usuario y receta son requeridos');
      }
      return await this.calendarService.createEntry(entryData);
    } catch (error) {
      console.error('CalendarController.createEntry error:', error);
      throw error;
    }
  }

  async updateEntry(id, entryData) {
    try {
      if (!id) throw new Error('ID de entrada requerido');
      await this.calendarService.updateEntry(id, entryData);
    } catch (error) {
      console.error('CalendarController.updateEntry error:', error);
      throw error;
    }
  }

  async deleteEntry(id) {
    try {
      if (!id) throw new Error('ID de entrada requerido');
      await this.calendarService.deleteEntry(id);
    } catch (error) {
      console.error('CalendarController.deleteEntry error:', error);
      throw error;
    }
  }
}

export const calendarController = new CalendarController();
export default calendarController;