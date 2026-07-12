import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App.jsx';
import './app/views/styles/index.css';

const originalWarn = console.warn;
console.warn = (...args) => {
  if (
    args[0]?.includes?.('React Router Future Flag Warning') ||
    args[0]?.includes?.('validateDOMNesting')
  ) {
    return;
  }
  originalWarn(...args);
};

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);