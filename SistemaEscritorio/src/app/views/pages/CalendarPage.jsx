import { useEffect, useState } from 'react';
import {
  Box,
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography,
  CircularProgress,
  IconButton,
  Button,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  Grid,
  Alert,
  Chip,
  Avatar,
  MenuItem
} from '@mui/material';
import {
  Edit as EditIcon,
  Delete as DeleteIcon,
  Add as AddIcon,
} from '@mui/icons-material';
import { calendarController } from '../../controllers/CalendarController';
import { getUsers } from '../../core/services/firebase/FirebaseService';
import { format } from 'date-fns';
import { es } from 'date-fns/locale';

const MEAL_TYPES = [
  { value: 'breakfast', label: 'Desayuno' },
  { value: 'lunch', label: 'Almuerzo' },
  { value: 'dinner', label: 'Cena' },
  { value: 'snack', label: 'Merienda' }
];

export const CalendarPage = () => {
  const [entries, setEntries] = useState([]);
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [selectedEntry, setSelectedEntry] = useState(null);
  const [formData, setFormData] = useState({
    userId: '',
    recipeId: '',
    recipeTitle: '',
    recipeImageUrl: '',
    scheduledDate: '',
    mealType: 'lunch'
  });
  const [error, setError] = useState('');
  const [isEditing, setIsEditing] = useState(false);

  useEffect(() => {
    loadEntries();
    loadUsers();
  }, []);

  const loadEntries = async () => {
    try {
      const data = await calendarController.getAllEntries();
      setEntries(data);
    } catch (error) {
      console.error('Error loading entries:', error);
    } finally {
      setLoading(false);
    }
  };

  const loadUsers = async () => {
    try {
      const data = await getUsers();
      setUsers(data);
    } catch (error) {
      console.error('Error loading users:', error);
    }
  };

  // ✅ Función para formatear fecha de forma segura
  const formatDateSafe = (dateValue) => {
    if (!dateValue) return 'N/A';
    try {
      let date;
      if (typeof dateValue === 'object' && dateValue !== null) {
        if (typeof dateValue.toDate === 'function') {
          date = dateValue.toDate();
        } else if (dateValue.seconds !== undefined) {
          date = new Date(dateValue.seconds * 1000);
        } else {
          date = new Date(dateValue);
        }
      } else {
        date = new Date(dateValue);
      }
      if (isNaN(date.getTime())) {
        return 'Fecha inválida';
      }
      return format(date, 'dd/MM/yyyy HH:mm', { locale: es });
    } catch (e) {
      return 'Fecha inválida';
    }
  };

  // ✅ Función para obtener fecha válida
  const getValidDate = (dateValue) => {
    if (!dateValue) return new Date();
    try {
      let date;
      if (typeof dateValue === 'object' && dateValue !== null) {
        if (typeof dateValue.toDate === 'function') {
          date = dateValue.toDate();
        } else if (dateValue.seconds !== undefined) {
          date = new Date(dateValue.seconds * 1000);
        } else {
          date = new Date(dateValue);
        }
      } else {
        date = new Date(dateValue);
      }
      if (isNaN(date.getTime())) {
        return new Date();
      }
      return date;
    } catch (e) {
      return new Date();
    }
  };

  const handleOpenDialog = (entry = null) => {
    if (entry) {
      setIsEditing(true);
      setSelectedEntry(entry);
      const date = getValidDate(entry.scheduledDate);
      setFormData({
        userId: entry.userId || '',
        recipeId: entry.recipeId || '',
        recipeTitle: entry.recipeTitle || '',
        recipeImageUrl: entry.recipeImageUrl || '',
        scheduledDate: format(date, "yyyy-MM-dd'T'HH:mm"),
        mealType: entry.mealType || 'lunch'
      });
    } else {
      setIsEditing(false);
      setSelectedEntry(null);
      setFormData({
        userId: users.length > 0 ? users[0].id : '',
        recipeId: '',
        recipeTitle: '',
        recipeImageUrl: '',
        scheduledDate: format(new Date(), "yyyy-MM-dd'T'HH:mm"),
        mealType: 'lunch'
      });
    }
    setError('');
    setDialogOpen(true);
  };

  const handleCloseDialog = () => {
    setDialogOpen(false);
    setSelectedEntry(null);
    setError('');
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    try {
      const entryData = {
        userId: formData.userId,
        recipeId: formData.recipeId || 'receta1',
        recipeTitle: formData.recipeTitle || 'Receta de ejemplo',
        recipeImageUrl: formData.recipeImageUrl || '',
        scheduledDate: formData.scheduledDate,
        mealType: formData.mealType
      };

      if (isEditing) {
        await calendarController.updateEntry(selectedEntry.id, entryData);
      } else {
        await calendarController.createEntry(entryData);
      }
      await loadEntries();
      handleCloseDialog();
    } catch (error) {
      console.error('Error saving entry:', error);
      setError('Error al guardar la entrada');
    }
  };

  const handleDelete = async (entryId) => {
    if (window.confirm('¿Estás seguro de que quieres eliminar esta entrada?')) {
      try {
        await calendarController.deleteEntry(entryId);
        await loadEntries();
      } catch (error) {
        console.error('Error deleting entry:', error);
        alert('Error al eliminar la entrada');
      }
    }
  };

  const getMealTypeLabel = (mealType) => {
    const type = MEAL_TYPES.find(t => t.value === mealType);
    return type ? type.label : mealType;
  };

  const getMealTypeColor = (mealType) => {
    switch (mealType) {
      case 'breakfast': return 'warning';
      case 'lunch': return 'success';
      case 'dinner': return 'primary';
      case 'snack': return 'info';
      default: return 'default';
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
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Box>
          <Typography variant="h4">Calendario de Comidas</Typography>
          <Chip label={`${entries.length} entradas`} color="primary" size="small" sx={{ mt: 1 }} />
        </Box>
        <Button
          data-cy="new-calendar-button"
          variant="contained"
          startIcon={<AddIcon />}
          onClick={() => handleOpenDialog()}
        >
          Nueva Entrada
        </Button>
      </Box>

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell><strong>Imagen</strong></TableCell>
              <TableCell><strong>Receta</strong></TableCell>
              <TableCell><strong>Usuario</strong></TableCell>
              <TableCell><strong>Fecha y Hora</strong></TableCell>
              <TableCell><strong>Tipo de Comida</strong></TableCell>
              <TableCell align="center"><strong>Acciones</strong></TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {entries.length === 0 ? (
              <TableRow>
                <TableCell colSpan={6} align="center">
                  <Typography variant="body2" color="textSecondary">
                    No hay entradas en el calendario
                  </Typography>
                </TableCell>
              </TableRow>
            ) : (
              entries.map((entry) => (
                <TableRow key={entry.id} hover>
                  <TableCell>
                    <Avatar src={entry.recipeImageUrl} alt={entry.recipeTitle} variant="rounded" />
                  </TableCell>
                  <TableCell>{entry.recipeTitle}</TableCell>
                  <TableCell>
                    {users.find(u => u.id === entry.userId)?.username || entry.userId}
                  </TableCell>
                  <TableCell>
                    {formatDateSafe(entry.scheduledDate)}
                  </TableCell>
                  <TableCell>
                    <Chip
                      label={getMealTypeLabel(entry.mealType)}
                      color={getMealTypeColor(entry.mealType)}
                      size="small"
                    />
                  </TableCell>
                  <TableCell align="center">
                    <IconButton
                      color="primary"
                      size="small"
                      onClick={() => handleOpenDialog(entry)}
                    >
                      <EditIcon />
                    </IconButton>
                    <IconButton
                      color="error"
                      size="small"
                      onClick={() => handleDelete(entry.id)}
                    >
                      <DeleteIcon />
                    </IconButton>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </TableContainer>

      <Dialog open={dialogOpen} onClose={handleCloseDialog} maxWidth="sm" fullWidth>
        <form onSubmit={handleSubmit}>
          <DialogTitle>
            {isEditing ? 'Editar Entrada' : 'Nueva Entrada'}
          </DialogTitle>
          <DialogContent>
            {error && (
              <Alert severity="error" sx={{ mb: 2 }}>
                {error}
              </Alert>
            )}
            <Grid container spacing={2} sx={{ mt: 1 }}>
              <Grid item xs={12}>
                <TextField
                  fullWidth
                  label="ID del Usuario"
                  name="userId"
                  value={formData.userId}
                  onChange={handleChange}
                  required
                  helperText="Ingresa el ID del usuario (ej: 8OGdSEDEePOCJ2wCh1OjURkluVW2)"
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  fullWidth
                  label="Título de la Receta"
                  name="recipeTitle"
                  value={formData.recipeTitle}
                  onChange={handleChange}
                  required
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  fullWidth
                  label="URL de Imagen"
                  name="recipeImageUrl"
                  value={formData.recipeImageUrl}
                  onChange={handleChange}
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  fullWidth
                  label="Fecha y Hora"
                  name="scheduledDate"
                  type="datetime-local"
                  value={formData.scheduledDate}
                  onChange={handleChange}
                  InputLabelProps={{ shrink: true }}
                  required
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  fullWidth
                  select
                  label="Tipo de Comida"
                  name="mealType"
                  value={formData.mealType}
                  onChange={handleChange}
                  required
                >
                  {MEAL_TYPES.map((type) => (
                    <MenuItem key={type.value} value={type.value}>
                      {type.label}
                    </MenuItem>
                  ))}
                </TextField>
              </Grid>
            </Grid>
          </DialogContent>
          <DialogActions>
            <Button onClick={handleCloseDialog}>Cancelar</Button>
            <Button type="submit" variant="contained">
              {isEditing ? 'Actualizar' : 'Crear'}
            </Button>
          </DialogActions>
        </form>
      </Dialog>
    </Box>
  );
};