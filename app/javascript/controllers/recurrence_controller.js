import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select"]

  connect() {
    this.toggle()
  }

  toggle() {
    const isRecurring = this.element.querySelector('input[type="checkbox"]').checked
    this.selectTarget.style.display = isRecurring ? "block" : "none"
  }
} 