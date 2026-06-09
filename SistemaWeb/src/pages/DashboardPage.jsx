import { useEffect, useState } from 'react';
import {
  Box,
  Grid,
  Paper,
  Typography,
  Card,
  CardContent,
  CircularProgress
} from '@mui/material';
import {
  People as PeopleIcon,
  LocalDining as RecipeIcon,
  Inventory as ProductIcon,
  CalendarMonth as CalendarIcon,
} from '@mui/icons-material';
import { getStatistics } from '../services/firestoreService';
import { AppColors } from '../theme/theme';

const StatCard = ({ title, value, icon, color }) => (
  <Card>
    <CardContent>
      <Box display="flex" alignItems="center" justifyContent="space-between">
        <Box>
          <Typography color="textSecondary" gutterBottom variant="body2">
            {title}
          </Typography>
          <Typography variant="h4">{value}</Typography>
        </Box>
        <Box
          sx={{
            backgroundColor: color,
            borderRadius: '50%',
            width: 60,
            height: 60,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            color: 'white',
          }}
        >
          {icon}
        </Box>
      </Box>
    </CardContent>
  </Card>
);

export const DashboardPage = () => {
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadStatistics();
  }, []);

  const loadStatistics = async () => {
    try {
      const data = await getStatistics();
      setStats(data);
    } catch (error) {
      console.error('Error loading statistics:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" minHeight="400px">
        <CircularProgress />
      </Box>
    );
  }

  return (
    <Box>
      <Typography variant="h4" gutterBottom>
        Dashboard
      </Typography>
      <Typography variant="body1" color="textSecondary" paragraph>
        Resumen general del sistema
      </Typography>

      <Grid container spacing={3}>
        
        <Grid item xs={12} sm={6} md={3}>
          <StatCard
            title="Total Productos"
            value={stats?.totalProducts || 0}
            icon={<ProductIcon />}
            color={AppColors.fern}
          />
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <StatCard
            title="Total Recetas"
            value={stats?.totalRecipes || 0}
            icon={<RecipeIcon />}
            color={AppColors.drySage}
          />
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <StatCard
            title="Entradas de Calendario"
            value={stats?.totalCalendarEntries || 0}
            icon={<CalendarIcon />}
            color={AppColors.pineTeal}
          />
        </Grid>
      </Grid>

      <Paper sx={{ mt: 4, p: 3 }}>
        <Typography variant="h6" gutterBottom>
          Bienvenido al Panel de Administración
        </Typography>
        <Typography variant="body1" color="textSecondary">
          Desde aquí puedes gestionar todos los aspectos de la aplicación Nutricional:
        </Typography>
        <Box component="ul" sx={{ mt: 2 }}>
          <li>
            <Typography variant="body2">
              <strong>Usuarios:</strong> Visualiza los usuarios registrados y su historial de acceso
            </Typography>
          </li>
          <li>
            <Typography variant="body2">
              <strong>Productos:</strong> Gestiona el catálogo de productos con información nutricional
            </Typography>
          </li>
          <li>
            <Typography variant="body2">
              <strong>Recetas:</strong> Administra recetas con ingredientes, pasos y tiempos de preparación
            </Typography>
          </li>
          <li>
            <Typography variant="body2">
              <strong>Calendario:</strong> Gestiona las planificaciones de comidas de los usuarios
            </Typography>
          </li>
        </Box>
      </Paper>
    </Box>
  );
};
