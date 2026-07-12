import { BaseRepository } from '../../repository/BaseRepository';
import { CalendarEntry } from '../../models/CalendarEntry';

class CalendarService {
  constructor() {
    this.repository = new BaseRepository('calendar');
  }

  async getAllEntries() {
    const data = await this.repository.findAll({
      orderByField: 'scheduledDate',
      orderDirection: 'desc'
    });
    return data.map(item => new CalendarEntry(item));
  }

  async getEntryById(id) {
    const data = await this.repository.findById(id);
    return data ? new CalendarEntry(data) : null;
  }

  async createEntry(entryData) {
    const entry = new CalendarEntry(entryData);
    const id = await this.repository.create(entry.toJSON());
    return id;
  }

  async updateEntry(id, entryData) {
    const entry = new CalendarEntry(entryData);
    await this.repository.update(id, entry.toJSON());
  }

  async deleteEntry(id) {
    await this.repository.delete(id);
  }
}

export const calendarService = new CalendarService();
export default calendarService;