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
  Divider
} from '@mui/material';
import {
  Edit as EditIcon,
  Delete as DeleteIcon,
  Add as AddIcon,
  Visibility as VisibilityIcon,
  Remove as RemoveIcon
} from '@mui/icons-material';
import { recipesController } from '../../controllers/RecipesController';

export const RecipesPage = () => {
  const [recipes, setRecipes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [viewDialogOpen, setViewDialogOpen] = useState(false);
  const [selectedRecipe, setSelectedRecipe] = useState(null);
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    imageUrl: '',
    category: '',
    preparationTime: 0,
    servings: 1,
    ingredients: [''],
    steps: ['']
  });
  const [error, setError] = useState('');
  const [isEditing, setIsEditing] = useState(false);

  useEffect(() => {
    loadRecipes();
  }, []);

  const loadRecipes = async () => {
    try {
      const data = await recipesController.getAllRecipes();
      setRecipes(data);
    } catch (error) {
      console.error('Error loading recipes:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleOpenDialog = (recipe = null) => {
    if (recipe) {
      setIsEditing(true);
      setSelectedRecipe(recipe);
      setFormData({
        title: recipe.title,
        description: recipe.description,
        imageUrl: recipe.imageUrl,
        category: recipe.category,
        preparationTime: recipe.preparationTime,
        servings: recipe.servings,
        ingredients: recipe.ingredients?.length > 0 ? recipe.ingredients : [''],
        steps: recipe.steps?.length > 0 ? recipe.steps : ['']
      });
    } else {
      setIsEditing(false);
      setSelectedRecipe(null);
      setFormData({
        title: '',
        description: '',
        imageUrl: '',
        category: '',
        preparationTime: 0,
        servings: 1,
        ingredients: [''],
        steps: ['']
      });
    }
    setError('');
    setDialogOpen(true);
  };

  const handleCloseDialog = () => {
    setDialogOpen(false);
    setSelectedRecipe(null);
    setError('');
  };

  const handleViewRecipe = (recipe) => {
    setSelectedRecipe(recipe);
    setViewDialogOpen(true);
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleArrayChange = (index, value, arrayName) => {
    const newArray = [...formData[arrayName]];
    newArray[index] = value;
    setFormData({ ...formData, [arrayName]: newArray });
  };

  const handleAddArrayItem = (arrayName) => {
    setFormData({
      ...formData,
      [arrayName]: [...formData[arrayName], '']
    });
  };

  const handleRemoveArrayItem = (index, arrayName) => {
    const newArray = formData[arrayName].filter((_, i) => i !== index);
    setFormData({ ...formData, [arrayName]: newArray });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    const ingredients = formData.ingredients.filter(i => i.trim() !== '');
    const steps = formData.steps.filter(s => s.trim() !== '');

    if (ingredients.length === 0 || steps.length === 0) {
      setError('Debes agregar al menos un ingrediente y un paso');
      return;
    }

    try {
      const recipeData = {
        ...formData,
        ingredients,
        steps,
        preparationTime: parseInt(formData.preparationTime) || 0,
        servings: parseInt(formData.servings) || 1,
        userId: 'admin'
      };

      if (isEditing) {
        await recipesController.updateRecipe(selectedRecipe.id, recipeData);
      } else {
        await recipesController.createRecipe(recipeData);
      }
      await loadRecipes();
      handleCloseDialog();
    } catch (error) {
      console.error('Error saving recipe:', error);
      setError('Error al guardar la receta');
    }
  };

  const handleDelete = async (recipeId) => {
    if (window.confirm('¿Estás seguro de que quieres eliminar esta receta?')) {
      try {
        await recipesController.deleteRecipe(recipeId);
        await loadRecipes();
      } catch (error) {
        console.error('Error deleting recipe:', error);
        alert('Error al eliminar la receta');
      }
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
          <Typography variant="h4">Recetas</Typography>
          <Chip label={`${recipes.length} recetas`} color="primary" size="small" sx={{ mt: 1 }} />
        </Box>
        <Button
          data-cy="new-recipe-button"
          variant="contained"
          startIcon={<AddIcon />}
          onClick={() => handleOpenDialog()}
        >
          Nueva Receta
        </Button>
      </Box>

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell><strong>Imagen</strong></TableCell>
              <TableCell><strong>Título</strong></TableCell>
              <TableCell><strong>Categoría</strong></TableCell>
              <TableCell><strong>Tiempo</strong></TableCell>
              <TableCell><strong>Porciones</strong></TableCell>
              <TableCell align="center"><strong>Acciones</strong></TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {recipes.length === 0 ? (
              <TableRow>
                <TableCell colSpan={6} align="center">
                  <Typography variant="body2" color="textSecondary">
                    No hay recetas registradas
                  </Typography>
                </TableCell>
              </TableRow>
            ) : (
              recipes.map((recipe) => (
                <TableRow key={recipe.id} hover>
                  <TableCell>
                    <Avatar src={recipe.imageUrl} alt={recipe.title} variant="rounded" />
                  </TableCell>
                  <TableCell>{recipe.title}</TableCell>
                  <TableCell>{recipe.category}</TableCell>
                  <TableCell>{recipe.preparationTime} min</TableCell>
                  <TableCell>{recipe.servings} personas</TableCell>
                  <TableCell align="center">
                    <IconButton
                      color="info"
                      size="small"
                      onClick={() => handleViewRecipe(recipe)}
                    >
                      <VisibilityIcon />
                    </IconButton>
                    <IconButton
                      color="primary"
                      size="small"
                      onClick={() => handleOpenDialog(recipe)}
                    >
                      <EditIcon />
                    </IconButton>
                    <IconButton
                      color="error"
                      size="small"
                      onClick={() => handleDelete(recipe.id)}
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

      {/* Dialog para crear/editar */}
      <Dialog open={dialogOpen} onClose={handleCloseDialog} maxWidth="md" fullWidth>
        <form onSubmit={handleSubmit}>
          <DialogTitle>
            {isEditing ? 'Editar Receta' : 'Nueva Receta'}
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
                  label="Título"
                  name="title"
                  value={formData.title}
                  onChange={handleChange}
                  required
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  fullWidth
                  label="Descripción"
                  name="description"
                  value={formData.description}
                  onChange={handleChange}
                  multiline
                  rows={3}
                  required
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField
                  fullWidth
                  label="Categoría"
                  name="category"
                  value={formData.category}
                  onChange={handleChange}
                  required
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField
                  fullWidth
                  label="URL de Imagen"
                  name="imageUrl"
                  value={formData.imageUrl}
                  onChange={handleChange}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField
                  fullWidth
                  label="Tiempo de Preparación (min)"
                  name="preparationTime"
                  type="number"
                  value={formData.preparationTime}
                  onChange={handleChange}
                  required
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField
                  fullWidth
                  label="Porciones"
                  name="servings"
                  type="number"
                  value={formData.servings}
                  onChange={handleChange}
                  required
                />
              </Grid>

              <Grid item xs={12}>
                <Typography variant="h6" sx={{ mt: 2 }}>
                  Ingredientes
                  <Button
                    size="small"
                    startIcon={<AddIcon />}
                    onClick={() => handleAddArrayItem('ingredients')}
                    sx={{ ml: 2 }}
                  >
                    Agregar
                  </Button>
                </Typography>
                {formData.ingredients.map((ingredient, index) => (
                  <Box key={index} display="flex" alignItems="center" mt={1}>
                    <TextField
                      fullWidth
                      size="small"
                      label={`Ingrediente ${index + 1}`}
                      value={ingredient}
                      onChange={(e) => handleArrayChange(index, e.target.value, 'ingredients')}
                    />
                    {formData.ingredients.length > 1 && (
                      <IconButton
                        color="error"
                        onClick={() => handleRemoveArrayItem(index, 'ingredients')}
                      >
                        <RemoveIcon />
                      </IconButton>
                    )}
                  </Box>
                ))}
              </Grid>

              <Grid item xs={12}>
                <Typography variant="h6" sx={{ mt: 2 }}>
                  Pasos de Preparación
                  <Button
                    size="small"
                    startIcon={<AddIcon />}
                    onClick={() => handleAddArrayItem('steps')}
                    sx={{ ml: 2 }}
                  >
                    Agregar
                  </Button>
                </Typography>
                {formData.steps.map((step, index) => (
                  <Box key={index} display="flex" alignItems="center" mt={1}>
                    <TextField
                      fullWidth
                      size="small"
                      label={`Paso ${index + 1}`}
                      value={step}
                      onChange={(e) => handleArrayChange(index, e.target.value, 'steps')}
                      multiline
                      rows={2}
                    />
                    {formData.steps.length > 1 && (
                      <IconButton
                        color="error"
                        onClick={() => handleRemoveArrayItem(index, 'steps')}
                      >
                        <RemoveIcon />
                      </IconButton>
                    )}
                  </Box>
                ))}
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

      {/* Dialog para ver detalles */}
      <Dialog open={viewDialogOpen} onClose={() => setViewDialogOpen(false)} maxWidth="md" fullWidth>
        <DialogTitle>Detalles de la Receta</DialogTitle>
        <DialogContent>
          {selectedRecipe && (
            <Box>
              <Box textAlign="center" mb={2}>
                <Avatar
                  src={selectedRecipe.imageUrl}
                  alt={selectedRecipe.title}
                  variant="rounded"
                  sx={{ width: 200, height: 200, margin: '0 auto' }}
                />
              </Box>
              <Typography variant="h5" gutterBottom>{selectedRecipe.title}</Typography>
              <Typography color="textSecondary" paragraph>
                {selectedRecipe.description}
              </Typography>
              
              <Box display="flex" gap={2} mb={2}>
                <Chip label={`Categoría: ${selectedRecipe.category}`} />
                <Chip label={`${selectedRecipe.preparationTime} minutos`} color="primary" />
                <Chip label={`${selectedRecipe.servings} porciones`} color="secondary" />
              </Box>

              <Divider sx={{ my: 2 }} />

              <Typography variant="h6" gutterBottom>Ingredientes</Typography>
              {selectedRecipe.ingredients?.map((ingredient, index) => (
                <Typography key={index} variant="body2">• {ingredient}</Typography>
              ))}

              <Divider sx={{ my: 2 }} />

              <Typography variant="h6" gutterBottom>Pasos de Preparación</Typography>
              {selectedRecipe.steps?.map((step, index) => (
                <Typography key={index} variant="body2" sx={{ mb: 1 }}>
                  {index + 1}. {step}
                </Typography>
              ))}
            </Box>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setViewDialogOpen(false)}>Cerrar</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};