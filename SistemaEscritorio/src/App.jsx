import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { CssBaseline, ThemeProvider, createTheme } from '@mui/material';
import { AuthProvider } from './app/contexts/AuthContext';
import { ProtectedRoute } from './app/views/components/ProtectedRoute';
import { MainLayout } from './app/views/components/MainLayout';
import { LoginPage } from './app/views/pages/LoginPage';
import { DashboardPage } from './app/views/pages/DashboardPage';
import { ProductsPage } from './app/views/pages/ProductsPage';
import { RecipesPage } from './app/views/pages/RecipesPage';
import { CalendarPage } from './app/views/pages/CalendarPage';
import { themeConfig } from './app/core/config/theme';

const theme = createTheme(themeConfig);

function App() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <AuthProvider>
        <BrowserRouter
          future={{
            v7_startTransition: true,
            v7_relativeSplatPath: true,
          }}
        >
          <Routes>
            <Route path="/login" element={<LoginPage />} />
            <Route
              path="/"
              element={
                <ProtectedRoute>
                  <MainLayout />
                </ProtectedRoute>
              }
            >
              <Route index element={<DashboardPage />} />
              <Route path="products" element={<ProductsPage />} />
              <Route path="recipes" element={<RecipesPage />} />
              <Route path="calendar" element={<CalendarPage />} />
            </Route>
            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </BrowserRouter>
      </AuthProvider>
    </ThemeProvider>
  );
}

export default App;