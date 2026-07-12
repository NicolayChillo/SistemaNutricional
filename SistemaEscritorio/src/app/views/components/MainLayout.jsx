import { useState, useEffect } from 'react';
import { Outlet, useNavigate, useLocation } from 'react-router-dom';
import {
  Box,
  Drawer,
  AppBar,
  Toolbar,
  List,
  Typography,
  Divider,
  IconButton,
  ListItem,
  ListItemButton,
  ListItemIcon,
  ListItemText,
  Avatar,
  Menu,
  MenuItem
} from '@mui/material';
import {
  Menu as MenuIcon,
  Dashboard as DashboardIcon,
  LocalDining as RecipeIcon,
  Inventory as ProductIcon,
  CalendarMonth as CalendarIcon,
  Logout as LogoutIcon,
  Restaurant as RestaurantIcon,
  Settings as SettingsIcon,
  Info as InfoIcon,
  Minimize as MinimizeIcon,
  CropSquare as CropSquareIcon,
  Close as CloseIcon
} from '@mui/icons-material';
import { useAuth } from '../../hooks/useAuth';
import { useEnvironment } from '../../hooks/useEnvironment';
import { AppColors } from '../../core/config/theme';

const drawerWidth = 240;

const menuItems = [
  { text: 'Dashboard', icon: <DashboardIcon />, path: '/', dataCy: 'menu-dashboard' },
  { text: 'Productos', icon: <ProductIcon />, path: '/products', dataCy: 'menu-products' },
  { text: 'Recetas', icon: <RecipeIcon />, path: '/recipes', dataCy: 'menu-recipes' },
  { text: 'Calendario', icon: <CalendarIcon />, path: '/calendar', dataCy: 'menu-calendar' },
];

export const MainLayout = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const { signOut, user } = useAuth();
  const { isElectron } = useEnvironment();
  const [mobileOpen, setMobileOpen] = useState(false);
  const [anchorEl, setAnchorEl] = useState(null);

  useEffect(() => {
    if (isElectron && window.electronAPI) {
      const cleanup = window.electronAPI.onMenuAction((action) => {
        if (action === 'logout') {
          handleLogout();
        }
      });
      return cleanup;
    }
  }, [isElectron]);

  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen);
  };

  const handleLogout = async () => {
    try {
      await signOut();
      navigate('/login');
    } catch (error) {
      console.error('Error logging out:', error);
    }
  };

  const handleMenuOpen = (event) => {
    setAnchorEl(event.currentTarget);
  };

  const handleMenuClose = () => {
    setAnchorEl(null);
  };

  const drawer = (
    <div>
      <Toolbar sx={{ display: 'flex', alignItems: 'center', gap: 1, py: 2 }}>
        <Box
          sx={{
            backgroundColor: AppColors.hunterGreen,
            borderRadius: '50%',
            width: 40,
            height: 40,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
          }}
        >
          <RestaurantIcon sx={{ color: 'white', fontSize: 24 }} />
        </Box>
        <Typography variant="h6" noWrap component="div" sx={{ color: AppColors.pineTeal, fontWeight: 600 }}>
          Nutricional
        </Typography>
      </Toolbar>
      <Divider/>
      <List>
        {menuItems.map((item) => (
          <ListItem key={item.text} disablePadding>
            <ListItemButton
              data-cy={item.dataCy}
              selected={location.pathname === item.path}
              onClick={() => {
                navigate(item.path);
                setMobileOpen(false);
              }}
            >
              <ListItemIcon>{item.icon}</ListItemIcon>
              <ListItemText primary={item.text} />
            </ListItemButton>
          </ListItem>
        ))}
      </List>
      <Divider />
      <List>
        <ListItem disablePadding>
          <ListItemButton data-cy="logout-button" onClick={handleLogout}>
            <ListItemIcon><LogoutIcon /></ListItemIcon>
            <ListItemText primary="Cerrar Sesión" />
          </ListItemButton>
        </ListItem>
      </List>
    </div>
  );

  return (
    <Box sx={{ display: 'flex' }}>
      {/* AppBar - Barra superior completa con arrastre */}
      <AppBar
        position="fixed"
        sx={{
          width: { sm: `calc(100% - ${drawerWidth}px)` },
          ml: { sm: `${drawerWidth}px` },
          zIndex: (theme) => theme.zIndex.drawer + 1,
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
          {/* Menú hamburguesa (solo móvil) - NO ARRASTRA */}
          <IconButton
            color="inherit"
            edge="start"
            onClick={handleDrawerToggle}
            sx={{ 
              mr: 2, 
              display: { sm: 'none' },
              WebkitAppRegion: 'no-drag',
            }}
          >
            <MenuIcon />
          </IconButton>
          
          {/* Título - IZQUIERDA (permite arrastrar) */}
          <Box sx={{ 
            display: 'flex', 
            alignItems: 'center', 
            gap: 1, 
            flexGrow: 1,
            WebkitAppRegion: 'drag',  // ← Permite arrastrar
          }}>
            <RestaurantIcon sx={{ color: 'white', fontSize: 28 }} />
            <Typography variant="h6" noWrap component="div" sx={{ color: 'white', fontWeight: 500 }}>
              Sistema Nutricional - Panel Administrativo
            </Typography>
            {isElectron && (
              <Typography 
                variant="caption" 
                sx={{ 
                  color: 'rgba(255,255,255,0.6)', 
                  fontSize: 10,
                  backgroundColor: 'rgba(255,255,255,0.15)',
                  padding: '0 8px',
                  borderRadius: 3,
                }}
              >
              </Typography>
            )}
          </Box>
          
          {/* Avatar con email - NO ARRASTRA */}
          <Box sx={{ 
            display: 'flex', 
            alignItems: 'center', 
            gap: 2, 
            mr: 1,
            WebkitAppRegion: 'no-drag',
          }}>
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
              <Avatar 
                sx={{ width: 32, height: 32, bgcolor: AppColors.fern, fontSize: 14, cursor: 'pointer' }}
                onClick={handleMenuOpen}
              >
                {user?.email?.[0]?.toUpperCase() || 'A'}
              </Avatar>
              <Typography variant="body2" sx={{ display: { xs: 'none', sm: 'block' }, color: 'white' }}>
                admin@gmail.com
              </Typography>
            </Box>
          </Box>

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

          {/* Menú desplegable con SOLO Cerrar Sesión */}
          <Menu
            anchorEl={anchorEl}
            open={Boolean(anchorEl)}
            onClose={handleMenuClose}
            anchorOrigin={{
              vertical: 'bottom',
              horizontal: 'right',
            }}
            transformOrigin={{
              vertical: 'top',
              horizontal: 'right',
            }}
          >
            <MenuItem onClick={() => {
              handleMenuClose();
              handleLogout();
            }}>
              <ListItemIcon><LogoutIcon fontSize="small" /></ListItemIcon>
              <ListItemText>Cerrar Sesión</ListItemText>
            </MenuItem>
          </Menu>
        </Toolbar>
      </AppBar>
      
      {/* Drawer - Barra lateral izquierda */}
      <Box component="nav" sx={{ width: { sm: drawerWidth }, flexShrink: { sm: 0 } }}>
        <Drawer
          variant="temporary"
          open={mobileOpen}
          onClose={handleDrawerToggle}
          ModalProps={{ keepMounted: true }}
          sx={{
            display: { xs: 'block', sm: 'none' },
            '& .MuiDrawer-paper': { boxSizing: 'border-box', width: drawerWidth },
          }}
        >
          {drawer}
        </Drawer>
        <Drawer
          variant="permanent"
          sx={{
            display: { xs: 'none', sm: 'block' },
            '& .MuiDrawer-paper': { boxSizing: 'border-box', width: drawerWidth },
          }}
          open
        >
          {drawer}
        </Drawer>
      </Box>
      
      {/* Contenido principal */}
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          p: 3,
          width: { sm: `calc(100% - ${drawerWidth}px)` },
        }}
      >
        <Toolbar />
        <Outlet />
      </Box>
    </Box>
  );
};