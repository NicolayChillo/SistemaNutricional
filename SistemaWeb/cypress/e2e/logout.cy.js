describe('Logout', () => {

  before(() => {
    cy.visit('/login')

    cy.get('[data-cy="email-input"]')
      .type('admin@gmail.com')

    cy.get('[data-cy="password-input"]')
      .type('123456')

    cy.get('[data-cy="login-button"]')
      .click()
  })

  it('Debe cerrar sesión correctamente', () => {

    cy.get('[data-cy="logout-button"]')
      .first()
      .click()

    cy.url()
      .should('contain', '/login')

  })

})