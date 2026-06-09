describe('Dashboard', () => {

  beforeEach(() => {
    cy.visit('/login')

    cy.get('[data-cy="email-input"]').type('admin@gmail.com')
    cy.get('[data-cy="password-input"]').type('123456')
    cy.get('[data-cy="login-button"]').click()
  })

  it('Muestra el dashboard', () => {
    cy.contains('Dashboard').should('exist')
    cy.contains('Resumen general del sistema').should('exist')
  })

  it('Muestra las tarjetas de estadisticas', () => {
    cy.contains('Total Productos').should('exist')
    cy.contains('Total Recetas').should('exist')
    cy.contains('Entradas de Calendario').should('exist')
  })

  it('Muestra el panel de administracion', () => {
    cy.contains('Bienvenido al Panel de Administración').should('exist')
  })

})