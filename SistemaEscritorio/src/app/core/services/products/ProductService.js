import { BaseRepository } from '../../repository/BaseRepository';
import { Product } from '../../models/Product';

class ProductService {
  constructor() {
    this.repository = new BaseRepository('products');
  }

  /**
   * Obtener todos los productos
   */
  async getAllProducts() {
    const data = await this.repository.findAll({
      orderByField: 'createdAt',
      orderDirection: 'desc'
    });
    return data.map(item => new Product(item));
  }

  /**
   * Obtener un producto por ID
   */
  async getProductById(id) {
    const data = await this.repository.findById(id);
    return data ? new Product(data) : null;
  }

  /**
   * Buscar productos por nombre
   */
  async searchProducts(searchTerm) {
    // Esta es una búsqueda simple - podrías mejorarla con Algolia o Elasticsearch
    const allProducts = await this.getAllProducts();
    return allProducts.filter(product => 
      product.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      product.brand.toLowerCase().includes(searchTerm.toLowerCase()) ||
      product.barcode.includes(searchTerm)
    );
  }

  /**
   * Buscar productos por categoría
   */
  async getProductsByCategory(category) {
    const data = await this.repository.findAll({
      filters: [['category', '==', category]],
      orderByField: 'name'
    });
    return data.map(item => new Product(item));
  }

  /**
   * Crear un nuevo producto
   */
  async createProduct(productData) {
    const product = new Product(productData);
    const id = await this.repository.create(product.toJSON());
    return id;
  }

  /**
   * Actualizar un producto
   */
  async updateProduct(id, productData) {
    const product = new Product(productData);
    await this.repository.update(id, product.toJSON());
  }

  /**
   * Eliminar un producto
   */
  async deleteProduct(id) {
    await this.repository.delete(id);
  }

  /**
   * Obtener estadísticas de productos
   */
  async getProductStats() {
    const products = await this.getAllProducts();
    const categories = {};
    const brands = {};
    let totalCalories = 0;

    products.forEach(product => {
      // Contar por categoría
      categories[product.category] = (categories[product.category] || 0) + 1;
      // Contar por marca
      brands[product.brand] = (brands[product.brand] || 0) + 1;
      // Sumar calorías
      totalCalories += product.caloriesPerServing || 0;
    });

    return {
      total: products.length,
      categories,
      brands,
      averageCalories: products.length > 0 ? totalCalories / products.length : 0,
      topCategories: Object.entries(categories)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 5)
    };
  }
}

export const productService = new ProductService();
export default productService;