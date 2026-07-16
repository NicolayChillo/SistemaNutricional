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
    Avatar
  } from '@mui/material';
  import {
    Edit as EditIcon,
    Delete as DeleteIcon,
    Add as AddIcon,
    Visibility as VisibilityIcon
  } from '@mui/icons-material';
  import {
    getProducts,
    createProduct,
    updateProduct,
    deleteProduct
  } from '../services/firestoreService';
  import { format } from 'date-fns';
  import { roundToDecimals, hasExcessiveDecimals } from '../utils/helpers';


  export const ProductsPage = () => {
    const [products, setProducts] = useState([]);
    const [loading, setLoading] = useState(true);
    const [dialogOpen, setDialogOpen] = useState(false);
    const [viewDialogOpen, setViewDialogOpen] = useState(false);
    const [selectedProduct, setSelectedProduct] = useState(null);
    const [formData, setFormData] = useState({
      barcode: '',
      name: '',
      brand: '',
      category: '',
      imageUrl: '',
      nutritionalInfo: {
        calories: 0,
        protein: 0,
        carbohydrates: 0,
        fat: 0,
        fiber: 0,
        sugar: 0,
        sodium: 0,
        servingSize: '100g'
      }
    });
    const [decimalError, setDecimalError] = useState('');

    // Función de cambio con validación
    const handleNutritionalChange = (e) => {
      const { name, value } = e.target;
      const field = name.split('.')[1];
      const numericValue = parseFloat(value) || 0;
      
      // Validar número de decimales
      if (hasExcessiveDecimals(value, 2)) {
        setDecimalError('Máximo 2 decimales permitidos');
        // Opcional: redondear automáticamente
        const rounded = roundToDecimals(numericValue, 2);
        setFormData({
          ...formData,
          nutritionalInfo: {
            ...formData.nutritionalInfo,
            [field]: rounded
          }
        });
        return;
      }
      setDecimalError('');
      setFormData({
        ...formData,
        nutritionalInfo: {
          ...formData.nutritionalInfo,
          [field]: numericValue
        }
      });
    };

    const [error, setError] = useState('');
    const [isEditing, setIsEditing] = useState(false);

    useEffect(() => {
      loadProducts();
    }, []);

    const loadProducts = async () => {
      try {
        const data = await getProducts();
        setProducts(data);
      } catch (error) {
        console.error('Error loading products:', error);
      } finally {
        setLoading(false);
      }
    };

    const handleOpenDialog = (product = null) => {
      if (product) {
        setIsEditing(true);
        setSelectedProduct(product);
        setFormData({
          barcode: product.barcode,
          name: product.name,
          brand: product.brand,
          category: product.category,
          imageUrl: product.imageUrl,
          nutritionalInfo: product.nutritionalInfo
        });
      } else {
        setIsEditing(false);
        setSelectedProduct(null);
        setFormData({
          barcode: '',
          name: '',
          brand: '',
          category: '',
          imageUrl: '',
          nutritionalInfo: {
            calories: 0,
            protein: 0,
            carbohydrates: 0,
            fat: 0,
            fiber: 0,
            sugar: 0,
            sodium: 0,
            servingSize: '100g'
          }
        });
      }
      setError('');
      setDialogOpen(true);
    };

    const handleCloseDialog = () => {
      setDialogOpen(false);
      setSelectedProduct(null);
      setError('');
    };

    const handleViewProduct = (product) => {
      setSelectedProduct(product);
      setViewDialogOpen(true);
    };

    const handleChange = (e) => {
      const { name, value } = e.target;
      if (name.startsWith('nutritionalInfo.')) {
        const field = name.split('.')[1];
        setFormData({
          ...formData,
          nutritionalInfo: {
            ...formData.nutritionalInfo,
            [field]: field === 'servingSize' ? value : parseFloat(value) || 0
          }
        });
      } else {
        setFormData({ ...formData, [name]: value });
      }
    };

    const handleSubmit = async (e) => {
      e.preventDefault();
      setError('');

      try {
        if (isEditing) {
          await updateProduct(selectedProduct.id, formData);
        } else {
          await createProduct({
            ...formData,
            userId: 'admin'
          });
        }
        await loadProducts();
        handleCloseDialog();
      } catch (error) {
        console.error('Error saving product:', error);
        setError('Error al guardar el producto');
      }
    };

    const handleDelete = async (productId) => {
      if (window.confirm('¿Estás seguro de que quieres eliminar este producto?')) {
        try {
          await deleteProduct(productId);
          await loadProducts();
        } catch (error) {
          console.error('Error deleting product:', error);
          alert('Error al eliminar el producto');
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
            <Typography variant="h4">Productos</Typography>
            <Chip label={`${products.length} productos`} color="primary" size="small" sx={{ mt: 1 }} />
          </Box>
          <Button
            data-cy="new-product-button"
            variant="contained"
            startIcon={<AddIcon />}
            onClick={() => handleOpenDialog()}
          >
            Nuevo Producto
          </Button>
        </Box>

        <TableContainer component={Paper}>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell><strong>Imagen</strong></TableCell>
                <TableCell><strong>Nombre</strong></TableCell>
                <TableCell><strong>Marca</strong></TableCell>
                <TableCell><strong>Categoría</strong></TableCell>
                <TableCell><strong>Calorías</strong></TableCell>
                <TableCell><strong>Fecha</strong></TableCell>
                <TableCell align="center"><strong>Acciones</strong></TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {products.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={7} align="center">
                    <Typography variant="body2" color="textSecondary">
                      No hay productos registrados
                    </Typography>
                  </TableCell>
                </TableRow>
              ) : (
                products.map((product) => (
                  <TableRow key={product.id} hover>
                    <TableCell>
                      <Avatar src={product.imageUrl} alt={product.name} variant="rounded" />
                    </TableCell>
                    <TableCell>{product.name}</TableCell>
                    <TableCell>{product.brand}</TableCell>
                    <TableCell>{product.category}</TableCell>
                    <TableCell>{product.nutritionalInfo?.calories || 0} kcal</TableCell>
                    <TableCell>
                      {product.createdAt ? format(product.createdAt, 'dd/MM/yyyy') : 'N/A'}
                    </TableCell>
                    <TableCell align="center">
                      <IconButton
                        data-cy="view-product-button"
                        color="info"
                        size="small"
                        onClick={() => handleViewProduct(product)}
                      >
                        <VisibilityIcon />
                      </IconButton>
                      <IconButton
                        data-cy="edit-product-button"
                        color="primary"
                        size="small"
                        onClick={() => handleOpenDialog(product)}
                      >
                        <EditIcon />
                      </IconButton>
                      <IconButton
                        data-cy="delete-product-button"
                        color="error"
                        size="small"
                        onClick={() => handleDelete(product.id)}
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
        <Dialog open={dialogOpen} onClose={handleCloseDialog} maxWidth="md" fullWidth>
          <form onSubmit={handleSubmit}>
            <DialogTitle>
              {isEditing ? 'Editar Producto' : 'Nuevo Producto'}
            </DialogTitle>
            <DialogContent>
              {error && (
                <Alert severity="error" sx={{ mb: 2 }}>
                  {error}
                </Alert>
              )}
              <Grid container spacing={2} sx={{ mt: 1 }}>
                <Grid item xs={12} sm={6}>
                  <TextField
                    data-cy="barcode-input"
                    fullWidth
                    label="Código de Barras"
                    name="barcode"
                    value={formData.barcode}
                    onChange={handleChange}
                    required
                  />
                </Grid>
                <Grid item xs={12} sm={6}>
                  <TextField
                    data-cy="product-name-input"
                    fullWidth
                    label="Nombre"
                    name="name"
                    value={formData.name}
                    onChange={handleChange}
                    required
                  />
                </Grid>
                <Grid item xs={12} sm={6}>
                  <TextField
                    data-cy="product-brand-input"
                    fullWidth
                    label="Marca"
                    name="brand"
                    value={formData.brand}
                    onChange={handleChange}
                    required
                  />
                </Grid>
                <Grid item xs={12} sm={6}>
                  <TextField
                    data-cy="product-category-input"
                    fullWidth
                    label="Categoría"
                    name="category"
                    value={formData.category}
                    onChange={handleChange}
                    required
                  />
                </Grid>
                <Grid item xs={12}>
                  <TextField
                    fullWidth
                    label="URL de Imagen"
                    name="imageUrl"
                    value={formData.imageUrl}
                    onChange={handleChange}
                  />
                </Grid>
                
                <Grid item xs={12}>
                  <Typography variant="h6" sx={{ mt: 2, mb: 1 }}>
                    Información Nutricional
                  </Typography>
                </Grid>
                
                <Grid item xs={12} sm={4}>
                  <TextField
                    data-cy="product-calories-input"
                    fullWidth
                    label="Calorías (kcal)"
                    name="nutritionalInfo.calories"
                    type="number"
                    value={formData.nutritionalInfo.calories}
                    onChange={handleNutritionalChange}
                    error={!!decimalError}
                    helperText={decimalError || 'Máximo 2 decimales'}
                    inputProps={{ step: '0.01', min: 0 }}
                    required
                  />
                </Grid>
                <Grid item xs={12} sm={4}>
                  <TextField
                    fullWidth
                    label="Proteínas (g)"
                    name="nutritionalInfo.protein"
                    type="number"
                    value={formData.nutritionalInfo.protein}
                    onChange={handleNutritionalChange}
                    error={!!decimalError}
                    helperText={decimalError || 'Máximo 2 decimales'}
                    inputProps={{ step: '0.01', min: 0 }}
                    required
                  />
                </Grid>
                <Grid item xs={12} sm={4}>
                  <TextField
                    fullWidth
                    label="Carbohidratos (g)"
                    name="nutritionalInfo.carbohydrates"
                    type="number"
                    value={formData.nutritionalInfo.carbohydrates}
                    onChange={handleNutritionalChange}
                    error={!!decimalError}
                    helperText={decimalError || 'Máximo 2 decimales'}
                    inputProps={{ step: '0.01', min: 0 }}
                    required
                  />
                </Grid>
                <Grid item xs={12} sm={4}>
                  <TextField
                    fullWidth
                    label="Grasas (g)"
                    name="nutritionalInfo.fat"
                    type="number"
                    value={formData.nutritionalInfo.fat}
                    onChange={handleNutritionalChange}
                    error={!!decimalError}
                    helperText={decimalError || 'Máximo 2 decimales'}
                    inputProps={{ step: '0.01', min: 0 }}
                    required
                  />
                </Grid>
                <Grid item xs={12} sm={4}>
                  <TextField
                    fullWidth
                    label="Fibra (g)"
                    name="nutritionalInfo.fiber"
                    type="number"
                    value={formData.nutritionalInfo.fiber}
                    onChange={handleNutritionalChange}
                    error={!!decimalError}
                    helperText={decimalError || 'Máximo 2 decimales'}
                    inputProps={{ step: '0.01', min: 0 }}
                  />
                </Grid>
                <Grid item xs={12} sm={4}>
                  <TextField
                    fullWidth
                    label="Azúcar (g)"
                    name="nutritionalInfo.sugar"
                    type="number"
                    value={formData.nutritionalInfo.sugar}
                    onChange={handleNutritionalChange}
                    error={!!decimalError}
                    helperText={decimalError || 'Máximo 2 decimales'}
                    inputProps={{ step: '0.01', min: 0 }}
                  />
                </Grid>
                <Grid item xs={12} sm={6}>
                  <TextField
                    fullWidth
                    label="Sodio (mg)"
                    name="nutritionalInfo.sodium"
                    type="number"
                    value={formData.nutritionalInfo.sodium}
                    onChange={handleNutritionalChange}
                    error={!!decimalError}
                    helperText={decimalError || 'Máximo 2 decimales'}
                    inputProps={{ step: '0.01', min: 0 }}
                  />
                </Grid>
                <Grid item xs={12} sm={6}>
                  <TextField
                    fullWidth
                    label="Tamaño de Porción"
                    name="nutritionalInfo.servingSize"
                    value={formData.nutritionalInfo.servingSize}
                    onChange={handleChange}
                    required
                  />
                </Grid>
              </Grid>
            </DialogContent>
            <DialogActions>
              <Button onClick={handleCloseDialog}>Cancelar</Button>
              <Button data-cy="save-product-button" type="submit" variant="contained">
                {isEditing ? 'Actualizar' : 'Crear'}
              </Button>
            </DialogActions>
          </form>
        </Dialog>

        {/* View Dialog */}
        <Dialog open={viewDialogOpen} onClose={() => setViewDialogOpen(false)} maxWidth="sm" fullWidth>
          <DialogTitle>Detalles del Producto</DialogTitle>
          <DialogContent>
            {selectedProduct && (
              <Box>
                <Box textAlign="center" mb={2}>
                  <Avatar
                    src={selectedProduct.imageUrl}
                    alt={selectedProduct.name}
                    variant="rounded"
                    sx={{ width: 120, height: 120, margin: '0 auto' }}
                  />
                </Box>
                <Typography variant="h6">{selectedProduct.name}</Typography>
                <Typography color="textSecondary" gutterBottom>
                  {selectedProduct.brand} | {selectedProduct.category}
                </Typography>
                <Typography variant="body2" gutterBottom>
                  <strong>Código de Barras:</strong> {selectedProduct.barcode}
                </Typography>
                
                <Typography variant="h6" sx={{ mt: 2, mb: 1 }}>Información Nutricional</Typography>
                <Typography variant="body2">
                  <strong>Porción:</strong> {selectedProduct.nutritionalInfo?.servingSize}
                </Typography>
                <Typography variant="body2">
                  <strong>Calorías:</strong> {selectedProduct.nutritionalInfo?.calories} kcal
                </Typography>
                <Typography variant="body2">
                  <strong>Proteínas:</strong> {selectedProduct.nutritionalInfo?.protein}g
                </Typography>
                <Typography variant="body2">
                  <strong>Carbohidratos:</strong> {selectedProduct.nutritionalInfo?.carbohydrates}g
                </Typography>
                <Typography variant="body2">
                  <strong>Grasas:</strong> {selectedProduct.nutritionalInfo?.fat}g
                </Typography>
                <Typography variant="body2">
                  <strong>Fibra:</strong> {selectedProduct.nutritionalInfo?.fiber}g
                </Typography>
                <Typography variant="body2">
                  <strong>Azúcar:</strong> {selectedProduct.nutritionalInfo?.sugar}g
                </Typography>
                <Typography variant="body2">
                  <strong>Sodio:</strong> {selectedProduct.nutritionalInfo?.sodium}mg
                </Typography>
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
