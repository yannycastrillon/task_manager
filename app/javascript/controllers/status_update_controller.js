import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "statusDropdown", "statusButton", "statusBadge" ]

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
    const url = event.currentTarget.dataset.url

    console.log(`Updating status to: ${status} for URL: ${url}`)

    this.updateField('status', status, url, this.statusButtonTarget)
  }


  updateField(field, value, url, buttonTarget) {
    // Show loading state
    const originalContent = buttonTarget.innerHTML
    buttonTarget.innerHTML = `
      <svg class="animate-spin w-4 h-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
      <span>Updating...</span>
    `
    
    // Send PATCH request to update field
    console.log(`Sending PATCH request to update ${field} to ${value} at ${url}`)
    fetch(url, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Accept': 'application/json'
      },
      body: JSON.stringify({
        cleaning_assignment: { [field]: value }
      })
    })
    .then(response => {
      if (response.ok) {
        return response.json()
      } else if (response.status === 401) {
        // Redirect to login page for unauthorized requests
        window.location.href = '/sessions/new'
        throw new Error('Unauthorized - redirecting to login')
      } else {
        throw new Error(`Failed to update ${field}`)
      }
    })
    .then(data => {
      // Update the status badge in the DOM
      this.updateStatusBadge(field, value)
      // Show success message
      this.showSuccessMessage(`${field} updated successfully!`)
      // Reset button state
      buttonTarget.innerHTML = originalContent
    })
    .catch(error => {
      console.error(`Error updating ${field}:`, error)
      // Reset button state
      buttonTarget.innerHTML = originalContent
      this.showErrorMessage(`Failed to update ${field}. Please try again.`)
    })
    
    // Close dropdowns
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