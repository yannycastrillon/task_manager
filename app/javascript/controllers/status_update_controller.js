import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "statusDropdown", "statusButton", "statusBadge", "statusForm", "statusInput" ]

  connect() {
    console.log(`StatusUpdateController connected to element with ID: ${this.element}`)
    // Close dropdowns when clicking outside
    document.addEventListener('click', this.handleClickOutside.bind(this))
  }

  disconnect() {
    document.removeEventListener('click', this.handleClickOutside.bind(this))
  }

  toggle(event) {
    console.log('Toggle status dropdown')
    event.stopPropagation()
    this.statusDropdownTarget.classList.toggle('hidden')
  }

  updateStatus(event) {
    event.preventDefault()
    const status = event.currentTarget.dataset.status
    // Set the value of the hidden input
    this.statusInputTarget.value = status
    // Submit the form (Turbo will handle the request/response)
    this.statusFormTarget.requestSubmit()
    // Optionally, close the dropdown
    this.closeAll()
  }

  updateStatusBadge(field, value) {
    if (field === 'status' && this.hasStatusBadgeTarget) {
      const badgeSpan = this.statusBadgeTarget.querySelector('span')

      if (badgeSpan) {
        // Remove old color classes
        badgeSpan.className = badgeSpan.className.replace(/bg-(blue|amber|emerald|red)-500\/20/g, '')
        badgeSpan.className = badgeSpan.className.replace(/text-(blue|amber|emerald|red)-400/g, '')
        badgeSpan.className = badgeSpan.className.replace(/border-(blue|amber|emerald|red)-500\/30/g, '')
        
        // Add new color classes based on the status
        let colorClass = 'gray'
        switch(value) {
          case 'scheduled':
            colorClass = 'blue'
            break
          case 'in_progress':
            colorClass = 'amber'
            break
          case 'completed':
            colorClass = 'emerald'
            break
          case 'cancelled':
            colorClass = 'red'
            break
        }

        badgeSpan.classList.add(`bg-${colorClass}-500/20`, `text-${colorClass}-400`, `border-${colorClass}-500/30`)
        
        // Update the dot color
        const dot = badgeSpan.querySelector('div')
        if (dot) {
          dot.className = dot.className.replace(/bg-(blue|amber|emerald|red)-400/g, '')
          dot.classList.add(`bg-${colorClass}-400`)
        }

        // Update the text content (it's the last text node in the span)
        const textNodes = Array.from(badgeSpan.childNodes).filter(node => node.nodeType === Node.TEXT_NODE)
        console.log('Text nodes found:', textNodes.length)
        if (textNodes.length > 0) {
          const lastTextNode = textNodes[textNodes.length - 1]
          lastTextNode.textContent = value.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase())
        }
      }
    }
  }

  showSuccessMessage(message) {
    // Create a temporary success message
    const messageDiv = document.createElement('div')
    messageDiv.className = 'fixed top-4 right-4 bg-green-500 text-white px-4 py-2 rounded-lg shadow-lg z-50'
    messageDiv.textContent = message
    document.body.appendChild(messageDiv)
    
    // Remove after 3 seconds
    setTimeout(() => {
      document.body.removeChild(messageDiv)
    }, 3000)
  }

  showErrorMessage(message) {
    // Create a temporary error message
    const messageDiv = document.createElement('div')
    messageDiv.className = 'fixed top-4 right-4 bg-red-500 text-white px-4 py-2 rounded-lg shadow-lg z-50'
    messageDiv.textContent = message
    document.body.appendChild(messageDiv)
    
    // Remove after 3 seconds
    setTimeout(() => {
      document.body.removeChild(messageDiv)
    }, 3000)
  }

  closeAll() {
    this.statusDropdownTarget.classList.add('hidden')
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.closeAll()
    }
  }
} 