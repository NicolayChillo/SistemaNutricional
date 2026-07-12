import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  base: './',  // ← IMPORTANTE: usar rutas relativas
  build: {
    outDir: 'dist',
    emptyOutDir: true,
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom', 'react-router-dom'],
          mui: ['@mui/material', '@mui/icons-material'],
          firebase: ['firebase/app', 'firebase/auth', 'firebase/firestore']
        }
      }
    }
  },
  server: {
    port: 5173
  },
  resolve: {
    alias: {
      '@': '/src',
      '@app': '/src/app',
      '@core': '/src/app/core',
      '@views': '/src/app/views',
      '@controllers': '/src/app/controllers',
      '@services': '/src/app/core/services',
      '@models': '/src/app/core/models',
      '@hooks': '/src/app/hooks',
      '@contexts': '/src/app/contexts'
    }
  }
});