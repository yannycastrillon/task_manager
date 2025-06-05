import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "input", "select", "results"]
  static values = {
    url: String
  }

  connect() {
    this.debouncedSearch = this.debounce(this.search.bind(this), 300)
  }

  search() {
    const formData = new FormData(this.formTarget)
    const queryString = new URLSearchParams(formData).toString()
    
    fetch(`${this.urlValue}?${queryString}`, {
      headers: {
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
    .then(response => response.text())
    .then(html => {
      Turbo.renderStreamMessage(html)
    })
  }

  // Debounce function to prevent too many requests
  debounce(func, wait) {
    let timeout
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout)
        func(...args)
      }
      clearTimeout(timeout)
      timeout = setTimeout(later, wait)
    }
  }
} 