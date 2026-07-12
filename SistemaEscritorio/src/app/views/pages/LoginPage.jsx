import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Container,
  Paper,
  Box,
  TextField,
  Button,
  Typography,
  Alert,
  CircularProgress,
  AppBar,
  Toolbar,
  IconButton
} from '@mui/material';
import { 
  Restaurant, 
  Minimize as MinimizeIcon,
  CropSquare as CropSquareIcon,
  Close as CloseIcon
} from '@mui/icons-material';
import { useAuth } from '../../hooks/useAuth';
import { useEnvironment } from '../../hooks/useEnvironment';
import { AppColors } from '../../core/config/theme';

export const LoginPage = () => {
  const navigate = useNavigate();
  const { signIn } = useAuth();
  const { isElectron } = useEnvironment();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      await signIn(email, password);
      navigate('/');
    } catch (error) {
      console.error('Login error:', error);
      setError('Error al iniciar sesión. Verifica tus credenciales.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box sx={{ display: 'flex', flexDirection: 'column', height: '100vh' }}>
      {/* AppBar - Barra superior con arrastre y botones */}
      <AppBar
        position="fixed"
        sx={{
          top: 0,
          left: 0,
          right: 0,
          zIndex: 9999,
          backgroundColor: '#3A5A40',
          boxShadow: 'none',
          height: 64,
          WebkitAppRegion: 'drag',  // ← PERMITE ARRASTRAR TODA LA BARRA
        }}
      >
        <Toolbar sx={{ 
          minHeight: 64, 
          height: 64,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          paddingRight: '0px !important',
          paddingLeft: '16px',
        }}>
          {/* Título - IZQUIERDA (permite arrastrar) */}
          <Box sx={{ 
            display: 'flex', 
            alignItems: 'center', 
            gap: 1,
            WebkitAppRegion: 'drag',  // ← Permite arrastrar
          }}>
            <Restaurant sx={{ color: 'white', fontSize: 28 }} />
            <Typography variant="h6" noWrap component="div" sx={{ color: 'white', fontWeight: 500 }}>
              Nutricional - Panel de Administración
            </Typography>
          </Box>
          
          {/* Espacio flexible */}
          <Box sx={{ flexGrow: 1 }} />

          {/* BOTONES DE CONTROL - NO ARRASTRAN */}
          {isElectron && (
            <Box sx={{ 
              display: 'flex', 
              alignItems: 'center', 
              height: '100%',
              WebkitAppRegion: 'no-drag',
            }}>
              <IconButton
                size="small"
                onClick={() => window.electronAPI?.minimizeWindow?.()}
                sx={{
                  color: 'white',
                  '&:hover': { backgroundColor: 'rgba(255,255,255,0.15)' },
                  borderRadius: 0,
                  padding: '8px 12px',
                  height: 64,
                  width: 46,
                }}
              >
                <MinimizeIcon sx={{ fontSize: 18 }} />
              </IconButton>
              
              <IconButton
                size="small"
                onClick={() => window.electronAPI?.maximizeWindow?.()}
                sx={{
                  color: 'white',
                  '&:hover': { backgroundColor: 'rgba(255,255,255,0.15)' },
                  borderRadius: 0,
                  padding: '8px 12px',
                  height: 64,
                  width: 46,
                }}
              >
                <CropSquareIcon sx={{ fontSize: 18 }} />
              </IconButton>
              
              <IconButton
                size="small"
                onClick={() => window.electronAPI?.closeWindow?.()}
                sx={{
                  color: 'white',
                  '&:hover': { backgroundColor: '#D32F2F' },
                  borderRadius: 0,
                  padding: '8px 12px',
                  height: 64,
                  width: 46,
                }}
              >
                <CloseIcon sx={{ fontSize: 18 }} />
              </IconButton>
            </Box>
          )}
        </Toolbar>
      </AppBar>

      {/* Contenido del Login */}
      <Box
        sx={{
          flexGrow: 1,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          mt: 8,  // Espacio para la AppBar
          p: 2,
        }}
      >
        <Container maxWidth="sm">
          <Paper elevation={3} sx={{ p: 4, width: '100%', borderRadius: 3 }}>
            <Box display="flex" justifyContent="center" mb={2}>
              <Box
                sx={{
                  backgroundColor: AppColors.hunterGreen,
                  borderRadius: '50%',
                  width: 80,
                  height: 80,
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  mb: 2
                }}
              >
                <Restaurant sx={{ fontSize: 48, color: 'white' }} />
              </Box>
            </Box>
            <Typography variant="h4" component="h1" gutterBottom align="center" color={AppColors.pineTeal}>
              Panel de Administración
            </Typography>
            <Typography variant="h6" gutterBottom align="center" sx={{ color: AppColors.drySage, fontWeight: 400 }}>
              Nutricional
            </Typography>

            {error && (
              <Alert severity="error" sx={{ mt: 2, mb: 2 }}>
                {error}
              </Alert>
            )}

            <form onSubmit={handleSubmit}>
              <TextField
                data-cy="email-input"
                fullWidth
                label="Email"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                margin="normal"
                required
                autoFocus
              />
              <TextField
                data-cy="password-input"
                fullWidth
                label="Contraseña"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                margin="normal"
                required
              />
              <Button
                data-cy="login-button"  
                type="submit"
                fullWidth
                variant="contained"
                size="large"
                sx={{ mt: 3 }}
                disabled={loading}
              >
                {loading ? <CircularProgress size={24} /> : 'Iniciar Sesión'}
              </Button>
            </form>
          </Paper>
        </Container>
      </Box>
    </Box>
  );
};