import {
  Box,
  Container,
  Paper,
  Typography,
  Grid,
  Chip,
} from '@mui/material';
import { AppColors } from '../theme/theme';

const ColorSwatch = ({ name, hex, description }) => (
  <Paper elevation={2} sx={{ p: 2, height: '100%' }}>
    <Box
      sx={{
        width: '100%',
        height: 100,
        backgroundColor: hex,
        borderRadius: 2,
        mb: 2,
        border: `1px solid ${AppColors.dustGrey}`,
      }}
    />
    <Typography variant="h6" gutterBottom>
      {name}
    </Typography>
    <Chip label={hex} size="small" sx={{ mb: 1, fontFamily: 'monospace' }} />
    <Typography variant="body2" color="text.secondary">
      {description}
    </Typography>
  </Paper>
);

export const ColorsReferencePage = () => {
  const mainColors = [
    {
      name: 'Hunter Green',
      hex: AppColors.hunterGreen,
      description: 'Color primario, botones principales, AppBar',
    },
    {
      name: 'Fern',
      hex: AppColors.fern,
      description: 'Color secundario, íconos, tarjetas',
    },
    {
      name: 'Dry Sage',
      hex: AppColors.drySage,
      description: 'Acentos, texto claro, highlights',
    },
    {
      name: 'Pine Teal',
      hex: AppColors.pineTeal,
      description: 'Texto principal, elementos oscuros',
    },
    {
      name: 'Dust Grey',
      hex: AppColors.dustGrey,
      description: 'Fondos, bordes, separadores',
    },
  ];

  const stateColors = [
    {
      name: 'Success',
      hex: AppColors.success,
      description: 'Estados exitosos, confirmaciones',
    },
    {
      name: 'Error',
      hex: AppColors.error,
      description: 'Errores, alertas críticas',
    },
    {
      name: 'Warning',
      hex: AppColors.warning,
      description: 'Advertencias, precauciones',
    },
    {
      name: 'Info',
      hex: AppColors.info,
      description: 'Información general',
    },
  ];

  return (
    <Container maxWidth="lg" sx={{ py: 4 }}>
      <Box mb={4}>
        <Typography variant="h4" gutterBottom color={AppColors.pineTeal}>
          🎨 Referencia de Colores
        </Typography>
        <Typography variant="body1" color="text.secondary" paragraph>
          Paleta de colores oficial del panel de administración Nutricional, 
          sincronizada con la aplicación móvil Flutter.
        </Typography>
      </Box>

      {/* Main Colors */}
      <Box mb={4}>
        <Typography variant="h5" gutterBottom sx={{ color: AppColors.hunterGreen }}>
          Colores Principales
        </Typography>
        <Grid container spacing={3}>
          {mainColors.map((color) => (
            <Grid item xs={12} sm={6} md={4} key={color.name}>
              <ColorSwatch {...color} />
            </Grid>
          ))}
        </Grid>
      </Box>

      {/* State Colors */}
      <Box mb={4}>
        <Typography variant="h5" gutterBottom sx={{ color: AppColors.hunterGreen }}>
          Colores de Estado
        </Typography>
        <Grid container spacing={3}>
          {stateColors.map((color) => (
            <Grid item xs={12} sm={6} md={3} key={color.name}>
              <ColorSwatch {...color} />
            </Grid>
          ))}
        </Grid>
      </Box>

      {/* Examples */}
      <Paper elevation={2} sx={{ p: 3, mb: 4 }}>
        <Typography variant="h6" gutterBottom sx={{ color: AppColors.pineTeal }}>
          Ejemplos de Uso
        </Typography>
        
        <Box mb={3}>
          <Typography variant="subtitle2" gutterBottom>
            Botones:
          </Typography>
          <Box display="flex" gap={2} flexWrap="wrap">
            <Chip label="Primary" color="primary" />
            <Chip label="Secondary" color="secondary" />
            <Chip label="Success" color="success" />
            <Chip label="Error" color="error" />
            <Chip label="Warning" color="warning" />
            <Chip label="Info" color="info" />
          </Box>
        </Box>

        <Box mb={3}>
          <Typography variant="subtitle2" gutterBottom>
            Chips de Calendario:
          </Typography>
          <Box display="flex" gap={2} flexWrap="wrap">
            <Chip label="Desayuno" color="warning" size="small" />
            <Chip label="Almuerzo" color="success" size="small" />
            <Chip label="Cena" color="primary" size="small" />
            <Chip label="Merienda" color="info" size="small" />
          </Box>
        </Box>

        <Box>
          <Typography variant="subtitle2" gutterBottom>
            Gradiente de tonos verdes:
          </Typography>
          <Box display="flex" height={40} borderRadius={2} overflow="hidden">
            <Box flex={1} sx={{ bgcolor: AppColors.dustGrey }} />
            <Box flex={1} sx={{ bgcolor: AppColors.drySage }} />
            <Box flex={1} sx={{ bgcolor: AppColors.fern }} />
            <Box flex={1} sx={{ bgcolor: AppColors.hunterGreen }} />
            <Box flex={1} sx={{ bgcolor: AppColors.pineTeal }} />
          </Box>
        </Box>
      </Paper>

      {/* Info Box */}
      <Paper 
        elevation={2} 
        sx={{ 
          p: 3, 
          bgcolor: AppColors.dustGrey,
          border: `2px solid ${AppColors.drySage}`,
        }}
      >
        <Typography variant="h6" gutterBottom sx={{ color: AppColors.pineTeal }}>
          📚 Documentación
        </Typography>
        <Typography variant="body2" paragraph>
          Para más información sobre el uso de colores, consulta:
        </Typography>
        <Box component="ul" sx={{ pl: 2 }}>
          <li>
            <Typography variant="body2">
              <strong>PALETA_COLORES.md</strong> - Guía completa de colores
            </Typography>
          </li>
          <li>
            <Typography variant="body2">
              <strong>src/theme/theme.js</strong> - Configuración del tema
            </Typography>
          </li>
          <li>
            <Typography variant="body2">
              <strong>lib/presentation/theme/app_colors.dart</strong> - Colores de la app móvil
            </Typography>
          </li>
        </Box>
      </Paper>
    </Container>
  );
};
