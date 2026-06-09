describe('CRUD Calendario', () => {

  beforeEach(() => {
    cy.visit('/calendar')
  })

  it('Carga la pagina de calendario', () => {
    cy.contains('Calendario de Comidas')
    cy.get('[data-cy="new-calendar-button"]').should('exist')
  })

  it('Abre formulario de nueva entrada', () => {
    cy.get('[data-cy="new-calendar-button"]').click()

    cy.contains('Nueva Entrada')
    cy.get('[data-cy="calendar-user-select"]').should('exist')
  })

  it('Verifica campos del formulario', () => {
    cy.get('[data-cy="new-calendar-button"]').click()

    cy.get('[data-cy="calendar-user-select"]').should('exist')
    cy.get('[data-cy="calendar-recipe-select"]').should('exist')
    cy.get('[data-cy="calendar-date-input"]').should('exist')
    cy.get('[data-cy="calendar-mealtype-select"]').should('exist')
    cy.get('[data-cy="save-calendar-button"]').should('exist')
  })

  it('Abre ventana de editar entrada', () => {
    cy.get('[data-cy="edit-calendar-button"]')
      .first()
      .click()

    cy.contains('Editar Entrada')
  })

  it('Verifica boton eliminar', () => {
    cy.get('[data-cy="delete-calendar-button"]')
      .first()
      .should('exist')
  })

  it('Verifica si existen botones de editar', () => {
  cy.get('body').then(($body) => {

    if ($body.find('[data-cy="edit-calendar-button"]').length > 0) {
      cy.get('[data-cy="edit-calendar-button"]')
        .first()
        .click()

      cy.contains('Editar Entrada')
    }

  })
})

})