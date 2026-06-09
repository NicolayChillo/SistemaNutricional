describe('Productos', () => {
  
  beforeEach(() => {
    cy.visit('/products')
  })

  it('Debe entrar a la pagina de productos', () => {

    cy.contains('Productos')
      .should('exist')

    cy.url()
      .should('contain', '/products')

  })

  it('Debe abrir el formulario de nuevo producto', () => {

    cy.get('[data-cy="new-product-button"]')
      .click()

    cy.contains('Nuevo Producto')
      .should('exist')

  })

  it('Debe crear un producto', () => {

    cy.get('[data-cy="new-product-button"]')
      .click()

    cy.get('[data-cy="barcode-input"]')
      .type('123456789')

    cy.get('[data-cy="product-name-input"]')
      .type('Producto Cypress')

    cy.get('[data-cy="product-brand-input"]')
      .type('Marca Cypress')

    cy.get('[data-cy="product-category-input"]')
      .type('Snacks')

    cy.get('[data-cy="product-calories-input"]')
      .type('100')

    cy.get('[data-cy="save-product-button"]')
      .click()

    cy.contains('Producto Cypress')
      .should('exist')

  })

  it('Debe abrir la ventana de editar producto', () => {

    cy.get('[data-cy="edit-product-button"]')
      .first()
      .click()

    cy.contains('Editar Producto')
      .should('exist')

  })

  it('Debe editar un producto', () => {

    cy.get('[data-cy="edit-product-button"]')
      .first()
      .click()

    cy.get('[data-cy="product-name-input"]')
      .type(' Editado')

    cy.get('[data-cy="save-product-button"]')
      .click()

    cy.contains('Editado')
      .should('exist')

  })

  it('Debe visualizar un producto', () => {

    cy.get('[data-cy="view-product-button"]')
      .first()
      .click()

    cy.contains('Detalles del Producto')
      .should('exist')

  })

  it('Debe eliminar un producto', () => {

    cy.get('[data-cy="delete-product-button"]')
      .first()
      .click()

  })

})

