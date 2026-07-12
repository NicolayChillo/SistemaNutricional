import { useState, useEffect } from 'react';

export const useEnvironment = () => {
  const [isElectron, setIsElectron] = useState(false);
  const [isDev, setIsDev] = useState(false);

  useEffect(() => {
    const isElectronEnv = typeof window !== 'undefined' && 
                          window.isElectron === true;
    setIsElectron(isElectronEnv);
    const isDevEnv = import.meta.env?.MODE === 'development' ||
                     window.isDev === true;
    setIsDev(isDevEnv);

    if (isElectronEnv && window.electronAPI) {
      window.electronAPI.getSystemInfo().then(info => {
        console.log('🖥️ Sistema:', info);
      }).catch(err => {
        console.warn('No se pudo obtener info del sistema:', err);
      });
    }
  }, []);

  return { isElectron, isDev, isWeb: !isElectron };
};