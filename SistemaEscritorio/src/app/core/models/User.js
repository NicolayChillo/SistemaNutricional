export class User {
  constructor(data = {}) {
    this.id = data.id || null;
    this.username = data.username || '';
    this.email = data.email || '';
    this.role = data.role || 'user';
    this.createdAt = data.createdAt || null;
    this.updatedAt = data.updatedAt || null;
    this.isActive = data.isActive !== undefined ? data.isActive : true;
  }

  get displayName() {
    return this.username || this.email?.split('@')[0] || 'Usuario';
  }

  get isAdmin() {
    return this.role === 'admin';
  }

  toJSON() {
    return {
      id: this.id,
      username: this.username,
      email: this.email,
      role: this.role,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      isActive: this.isActive
    };
  }
}