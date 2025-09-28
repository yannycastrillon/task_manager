import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { userRole: String, isAdmin: Boolean }

  connect() {
    this.hideNonAdminTabs()
  }

  hideNonAdminTabs() {
    // Only hide tabs if user is not an admin
    if (!this.isAdminValue) {
      // Hide admin-only navigation items in desktop menu
      const adminNavItems = document.querySelectorAll('[data-admin-only="true"]')
      adminNavItems.forEach(item => {
        item.style.display = 'none'
      })

      // Hide admin-only navigation items in mobile menu
      const mobileAdminNavItems = document.querySelectorAll('[data-mobile-admin-only="true"]')
      mobileAdminNavItems.forEach(item => {
        item.style.display = 'none'
      })

      // Hide admin-only buttons and actions throughout the app
      const adminOnlyElements = document.querySelectorAll('[data-admin-only-action="true"]')
      adminOnlyElements.forEach(element => {
        element.style.display = 'none'
      })
    }
  }
}
