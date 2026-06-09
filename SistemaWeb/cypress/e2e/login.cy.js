describe('Login', () => {

  beforeEach(() => {
    cy.visit('/login')
  })

  it('Muestra los elementos del formulario', () => {
    cy.get('[data-cy="email-input"]').should('exist')
    cy.get('[data-cy="password-input"]').should('exist')
    cy.get('[data-cy="login-button"]').should('exist')
  })

  it('Permite escribir email y contraseña', () => {
    cy.get('[data-cy="email-input"]')
      .type('admin@gmail.com')
      .should('have.value', 'admin@gmail.com')

    cy.get('[data-cy="password-input"]')
      .type('123456')
      .should('have.value', '123456')
  })

  it('Inicia sesión correctamente', () => {
    cy.get('[data-cy="email-input"]').type('admin@gmail.com')
    cy.get('[data-cy="password-input"]').type('123456')
    cy.get('[data-cy="login-button"]').click()

    cy.url().should('not.contain', '/login')
  })

})