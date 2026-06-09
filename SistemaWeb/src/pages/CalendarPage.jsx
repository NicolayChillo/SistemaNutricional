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
  MenuItem,
  Avatar
} from '@mui/material';
import {
  Edit as EditIcon,
  Delete as DeleteIcon,
  Add as AddIcon,
} from '@mui/icons-material';
import {
  getCalendarEntries,
  createCalendarEntry,
  updateCalendarEntry,
  deleteCalendarEntry,
  getRecipes,
  getUsers
} from '../services/firestoreService';
import { format } from 'date-fns';

const MEAL_TYPES = [
  { value: 'breakfast', label: 'Desayuno' },
  { value: 'lunch', label: 'Almuerzo' },
  { value: 'dinner', label: 'Cena' },
  { value: 'snack', label: 'Merienda' }
];

export const CalendarPage = () => {
  const [entries, setEntries] = useState([]);
  const [recipes, setRecipes] = useState([]);
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [selectedEntry, setSelectedEntry] = useState(null);
  const [formData, setFormData] = useState({
    userId: '',
    recipeId: '',
    scheduledDate: '',
    mealType: 'lunch'
  });
  const [error, setError] = useState('');
  const [isEditing, setIsEditing] = useState(false);

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    try {
      const [entriesData, recipesData, usersData] = await Promise.all([
        getCalendarEntries(),
        getRecipes(),
        getUsers()
      ]);
      setEntries(entriesData);
      setRecipes(recipesData);
      setUsers(usersData);
    } catch (error) {
      console.error('Error loading data:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleOpenDialog = (entry = null) => {
    if (entry) {
      setIsEditing(true);
      setSelectedEntry(entry);
      setFormData({
        userId: entry.userId,
        recipeId: entry.recipeId,
        scheduledDate: format(entry.scheduledDate, 'yyyy-MM-dd\'T\'HH:mm'),
        mealType: entry.mealType
      });
    } else {
      setIsEditing(false);
      setSelectedEntry(null);
      setFormData({
        userId: '',
        recipeId: '',
        scheduledDate: '',
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
      const selectedRecipe = recipes.find(r => r.id === formData.recipeId);
      if (!selectedRecipe) {
        setError('Debes seleccionar una receta');
        return;
      }

      const entryData = {
        userId: formData.userId,
        recipeId: formData.recipeId,
        recipeTitle: selectedRecipe.title,
        recipeImageUrl: selectedRecipe.imageUrl,
        scheduledDate: formData.scheduledDate,
        mealType: formData.mealType
      };

      if (isEditing) {
        await updateCalendarEntry(selectedEntry.id, entryData);
      } else {
        await createCalendarEntry(entryData);
      }
      await loadData();
      handleCloseDialog();
    } catch (error) {
      console.error('Error saving calendar entry:', error);
      setError('Error al guardar la entrada del calendario');
    }
  };

  const handleDelete = async (entryId) => {
    if (window.confirm('¿Estás seguro de que quieres eliminar esta entrada?')) {
      try {
        await deleteCalendarEntry(entryId);
        await loadData();
      } catch (error) {
        console.error('Error deleting calendar entry:', error);
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
              <TableCell><strong>Notificación</strong></TableCell>
              <TableCell align="center"><strong>Acciones</strong></TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {entries.length === 0 ? (
              <TableRow>
                <TableCell colSpan={7} align="center">
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
                    {entry.scheduledDate ? format(entry.scheduledDate, 'dd/MM/yyyy HH:mm') : 'N/A'}
                  </TableCell>
                  <TableCell>
                    <Chip
                      label={getMealTypeLabel(entry.mealType)}
                      color={getMealTypeColor(entry.mealType)}
                      size="small"
                    />
                  </TableCell>
                  <TableCell>
                    <Chip
                      label={entry.notificationSent ? 'Enviada' : 'Pendiente'}
                      color={entry.notificationSent ? 'success' : 'default'}
                      size="small"
                    />
                  </TableCell>
                  <TableCell align="center">
                    <IconButton
                      data-cy="edit-calendar-button"
                      color="primary"
                      size="small"
                      onClick={() => handleOpenDialog(entry)}
                    >
                      <EditIcon />
                    </IconButton>
                    <IconButton
                      data-cy="delete-calendar-button"
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

      {/* Create/Edit Dialog */}
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
                  data-cy="calendar-user-select"
                  fullWidth
                  select
                  label="Usuario"
                  name="userId"
                  value={formData.userId}
                  onChange={handleChange}
                  required
                >
                  {users.map((user) => (
                    <MenuItem key={user.id} value={user.id}>
                      {user.username || user.email}
                    </MenuItem>
                  ))}
                </TextField>
              </Grid>
              <Grid item xs={12}>
                <TextField
                  data-cy="calendar-recipe-select"
                  fullWidth
                  select
                  label="Receta"
                  name="recipeId"
                  value={formData.recipeId}
                  onChange={handleChange}
                  required
                >
                  {recipes.map((recipe) => (
                    <MenuItem key={recipe.id} value={recipe.id}>
                      {recipe.title}
                    </MenuItem>
                  ))}
                </TextField>
              </Grid>
              <Grid item xs={12}>
                <TextField
                  data-cy="calendar-date-input"
                  fullWidth
                  label="Fecha y Hora"
                  name="scheduledDate"
                  type="datetime-local"
                  value={formData.scheduledDate}
                  onChange={handleChange}
                  InputLabelProps={{
                    shrink: true,
                  }}
                  required
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  data-cy="calendar-mealtype-select"
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
            <Button data-cy="save-calendar-button" type="submit" variant="contained">
              {isEditing ? 'Actualizar' : 'Crear'}
            </Button>
          </DialogActions>
        </form>
      </Dialog>
    </Box>
  );
};
