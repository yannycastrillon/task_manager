import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["recurringFields"]

  connect() {
    // On connect, ensure the fields are shown/hidden based on the initial checkbox state
    this.toggle()
  }

  toggle(event) {
    // If called from a checkbox event, use its checked state
    // Otherwise, find the checkbox in the DOM
    let checked
    if (event && event.target) {
      checked = event.target.checked
    } else {
      // Find the checkbox in the parent element
      const checkbox = this.element.querySelector('input[type="checkbox"][name*="is_recurring"]')
      checked = checkbox && checkbox.checked
    }
    this.recurringFieldsTarget.style.display = checked ? '' : 'none'
  }
} 