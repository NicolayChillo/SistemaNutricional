
describe('Navegacion', () => {

  beforeEach(() => {
    cy.visit('/login')

    cy.get('[data-cy="email-input"]').type('admin@gmail.com')
    cy.get('[data-cy="password-input"]').type('123456')
    cy.get('[data-cy="login-button"]').click()
  })

  it('Navega a Productos', () => {
    cy.get('[data-cy="menu-products"]').click()
    cy.url().should('contain', '/products')
  })

  it('Navega a Recetas', () => {
    cy.get('[data-cy="menu-recipes"]').click()
    cy.url().should('contain', '/recipes')
  })

  it('Navega a Calendario', () => {
    cy.get('[data-cy="menu-calendar"]').click()
    cy.url().should('contain', '/calendar')
  })

  it('Cierra sesion', () => {
    cy.get('[data-cy="logout-button"]').click()
    cy.url().should('contain', '/login')
  })

})