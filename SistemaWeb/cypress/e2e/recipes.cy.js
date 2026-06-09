describe('CRUD Recetas', () => {

  beforeEach(() => {
    cy.visit('/recipes')
  })

  it('Carga la pagina de recetas', () => {
    cy.contains('Recetas')
    cy.get('[data-cy="new-recipe-button"]').should('exist')
  })

  it('Abre el formulario de nueva receta', () => {
    cy.get('[data-cy="new-recipe-button"]').click()

    cy.contains('Nueva Receta')
    cy.get('[data-cy="recipe-title-input"]').should('exist')
  })

  it('Permite llenar el formulario de receta', () => {
    cy.get('[data-cy="new-recipe-button"]').click()

    cy.get('[data-cy="recipe-title-input"]')
      .type('Ensalada Cesar')

    cy.get('[data-cy="recipe-description-input"]')
      .type('Receta saludable')

    cy.get('[data-cy="recipe-category-input"]')
      .type('Ensaladas')

    cy.get('[data-cy="recipe-ingredient-0-input"]')
      .type('Lechuga')

    cy.get('[data-cy="recipe-step-0-input"]')
      .type('Lavar ingredientes')

    cy.get('[data-cy="save-recipe-button"]')
      .should('exist')
  })

  it('Abre la ventana de editar receta', () => {
    cy.get('[data-cy="edit-recipe-button"]')
      .first()
      .click()

    cy.contains('Editar Receta')
  })

  it('Abre la ventana de detalles', () => {
    cy.get('[data-cy="view-recipe-button"]')
      .first()
      .click()

    cy.contains('Detalles de la Receta')
  })

  it('Muestra boton para eliminar receta', () => {
    cy.get('[data-cy="delete-recipe-button"]')
      .first()
      .should('exist')
  })

})