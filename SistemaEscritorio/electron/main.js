const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const fs = require('fs');

let mainWindow = null;

if (process.env.NODE_ENV === 'development') {
  process.env.ELECTRON_DISABLE_SECURITY_WARNINGS = 'true';
}

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1280,
    height: 800,
    minWidth: 1024,
    minHeight: 600,
    titleBarStyle: 'hidden',
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      webSecurity: false,
      allowRunningInsecureContent: true,
      preload: path.join(__dirname, 'preload.js'),
    },
    icon: path.join(__dirname, '../resources/icons/icon.ico'),
    show: false,
    backgroundColor: '#3A5A40',
  });

  mainWindow.once('ready-to-show', () => {
    mainWindow.show();
  });

  mainWindow.setMenu(null);

  // Cargar desde servidor de desarrollo
  mainWindow.loadURL('http://localhost:5173');
  mainWindow.webContents.openDevTools();

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

// ============ IPC Handlers ============

// System Info - AGREGAR ESTO
ipcMain.handle('system:info', async () => {
  return {
    platform: process.platform,
    arch: process.arch,
    version: app.getVersion(),
    electronVersion: process.versions.electron,
    chromeVersion: process.versions.chrome,
    nodeVersion: process.versions.node,
    userDataPath: app.getPath('userData'),
    documentsPath: app.getPath('documents'),
    downloadsPath: app.getPath('downloads'),
    isPackaged: app.isPackaged,
  };
});

// App Version
ipcMain.handle('app:version', () => {
  return app.getVersion();
});

// App Path
ipcMain.handle('app:path', (event, pathType) => {
  return app.getPath(pathType);
});

// File Save
ipcMain.handle('file:save', async (event, { filename, content, type = 'json' }) => {
  try {
    const { dialog } = require('electron');
    const { filePath } = await dialog.showSaveDialog({
      title: 'Guardar Archivo',
      defaultPath: filename,
      filters: [
        { name: 'JSON', extensions: ['json'] },
        { name: 'CSV', extensions: ['csv'] }
      ]
    });

    if (!filePath) return { success: false, canceled: true };

    let fileContent = content;
    if (type === 'json') {
      fileContent = JSON.stringify(content, null, 2);
    }

    fs.writeFileSync(filePath, fileContent, 'utf8');
    return { success: true, path: filePath };
  } catch (error) {
    console.error('Error saving file:', error);
    return { success: false, error: error.message };
  }
});

// File Open
ipcMain.handle('file:open', async (event, { filters = [] }) => {
  try {
    const { dialog } = require('electron');
    const { filePaths } = await dialog.showOpenDialog({
      title: 'Abrir Archivo',
      filters: filters.length > 0 ? filters : [
        { name: 'JSON', extensions: ['json'] },
        { name: 'CSV', extensions: ['csv'] }
      ],
      properties: ['openFile']
    });

    if (filePaths.length === 0) return { success: false, canceled: true };

    const content = fs.readFileSync(filePaths[0], 'utf8');
    return { success: true, path: filePaths[0], content };
  } catch (error) {
    console.error('Error opening file:', error);
    return { success: false, error: error.message };
  }
});

// Window Controls
ipcMain.on('window:minimize', () => {
  if (mainWindow) mainWindow.minimize();
});

ipcMain.on('window:maximize', () => {
  if (mainWindow) {
    if (mainWindow.isMaximized()) {
      mainWindow.unmaximize();
    } else {
      mainWindow.maximize();
    }
  }
});

ipcMain.on('window:close', () => {
  if (mainWindow) mainWindow.close();
});

ipcMain.on('window:hide', () => {
  if (mainWindow) mainWindow.hide();
});

ipcMain.on('window:show', () => {
  if (mainWindow) {
    mainWindow.show();
    mainWindow.focus();
  }
});

// ============ App Lifecycle ============


app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});