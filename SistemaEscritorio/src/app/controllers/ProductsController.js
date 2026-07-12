import productService from '../core/services/products/ProductService';

/**
 * Controlador de productos
 * Maneja la lógica de negocio para productos
 */
export class ProductsController {
  constructor() {
    this.productService = productService;
  }

  /**
   * Obtener todos los productos
   */
  async getAllProducts() {
    try {
      return await this.productService.getAllProducts();
    } catch (error) {
      console.error('ProductsController.getAllProducts error:', error);
      throw error;
    }
  }

  /**
   * Obtener un producto por ID
   */
  async getProductById(id) {
    try {
      if (!id) throw new Error('ID de producto requerido');
      return await this.productService.getProductById(id);
    } catch (error) {
      console.error('ProductsController.getProductById error:', error);
      throw error;
    }
  }

  /**
   * Buscar productos
   */
  async searchProducts(searchTerm) {
    try {
      if (!searchTerm || searchTerm.length < 2) {
        return await this.getAllProducts();
      }
      return await this.productService.searchProducts(searchTerm);
    } catch (error) {
      console.error('ProductsController.searchProducts error:', error);
      throw error;
    }
  }

  /**
   * Obtener productos por categoría
   */
  async getProductsByCategory(category) {
    try {
      return await this.productService.getProductsByCategory(category);
    } catch (error) {
      console.error('ProductsController.getProductsByCategory error:', error);
      throw error;
    }
  }

  /**
   * Crear un nuevo producto
   */
  async createProduct(productData) {
    try {
      // Validaciones de negocio
      if (!productData.name || !productData.barcode) {
        throw new Error('Nombre y código de barras son requeridos');
      }
      
      return await this.productService.createProduct(productData);
    } catch (error) {
      console.error('ProductsController.createProduct error:', error);
      throw error;
    }
  }

  /**
   * Actualizar un producto
   */
  async updateProduct(id, productData) {
    try {
      if (!id) throw new Error('ID de producto requerido');
      await this.productService.updateProduct(id, productData);
    } catch (error) {
      console.error('ProductsController.updateProduct error:', error);
      throw error;
    }
  }

  /**
   * Eliminar un producto
   */
  async deleteProduct(id) {
    try {
      if (!id) throw new Error('ID de producto requerido');
      await this.productService.deleteProduct(id);
    } catch (error) {
      console.error('ProductsController.deleteProduct error:', error);
      throw error;
    }
  }

  /**
   * Obtener estadísticas de productos
   */
  async getProductStats() {
    try {
      return await this.productService.getProductStats();
    } catch (error) {
      console.error('ProductsController.getProductStats error:', error);
      throw error;
    }
  }
}

export const productsController = new ProductsController();
export default productsController;