const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('electronAPI', {
  // Versión
  getVersion: () => ipcRenderer.invoke('app:version'),
  
  // Sistema
  getSystemInfo: () => ipcRenderer.invoke('system:info'),
  getPath: (pathType) => ipcRenderer.invoke('app:path', pathType),
  
  // Archivos
  saveFile: (data) => ipcRenderer.invoke('file:save', data),
  openFile: (options) => ipcRenderer.invoke('file:open', options),
  
  // Controles de ventana
  minimizeWindow: () => ipcRenderer.send('window:minimize'),
  maximizeWindow: () => ipcRenderer.send('window:maximize'),
  closeWindow: () => ipcRenderer.send('window:close'),
  hideWindow: () => ipcRenderer.send('window:hide'),
  showWindow: () => ipcRenderer.send('window:show'),
  
  // Eventos de ventana
  onWindowEvent: (event, callback) => {
    ipcRenderer.on(`window:${event}`, callback);
  },
  removeWindowEvent: (event) => {
    ipcRenderer.removeAllListeners(`window:${event}`);
  },
  
  // Menú
  onMenuAction: (callback) => {
    const handler = (event, action) => {
      callback(action);
    };
    ipcRenderer.on('menu:export-data', handler);
    ipcRenderer.on('menu:import-data', handler);
    ipcRenderer.on('menu:sync-firebase', handler);
    ipcRenderer.on('menu:logout', handler);
    ipcRenderer.on('menu:clear-local-data', handler);
    ipcRenderer.on('auth:logout', handler);
    
    return () => {
      ipcRenderer.removeAllListeners('menu:export-data');
      ipcRenderer.removeAllListeners('menu:import-data');
      ipcRenderer.removeAllListeners('menu:sync-firebase');
      ipcRenderer.removeAllListeners('menu:logout');
      ipcRenderer.removeAllListeners('menu:clear-local-data');
      ipcRenderer.removeAllListeners('auth:logout');
    };
  },
  
  // Notificaciones
  showNotification: (title, body) => {
    new Notification(title, { body });
  }
});

// Detectar entorno
contextBridge.exposeInMainWorld('isElectron', true);
contextBridge.exposeInMainWorld('isDev', process.env.NODE_ENV === 'development');