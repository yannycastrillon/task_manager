import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["text", "button", "icon"]
  static values = { 
    text: String,
    feedback: String 
  }

  connect() {
    // Set default feedback message if not provided
    if (!this.hasFeedbackValue) {
      this.feedbackValue = "Copied!"
    }
  }

  copy(event) {
    console.log('Copy button clicked!') // Debug log
    
    // Prevent the event from bubbling up to parent elements (like the link)
    event.stopPropagation()
    event.preventDefault()
    
    const textToCopy = this.hasTextTarget ? this.textTarget.textContent.trim() : this.textValue
    console.log('Text to copy:', textToCopy) // Debug log
    
    if (navigator.clipboard && window.isSecureContext) {
      // Use modern clipboard API
      navigator.clipboard.writeText(textToCopy).then(() => {
        console.log('Successfully copied to clipboard!') // Debug log
        this.showFeedback()
      }).catch(err => {
        console.error('Failed to copy text: ', err)
        this.fallbackCopy(textToCopy)
      })
    } else {
      // Fallback for older browsers or non-secure contexts
      console.log('Using fallback copy method') // Debug log
      this.fallbackCopy(textToCopy)
    }
  }

  fallbackCopy(text) {
    // Create a temporary textarea element
    const textArea = document.createElement("textarea")
    textArea.value = text
    textArea.style.position = "fixed"
    textArea.style.left = "-999999px"
    textArea.style.top = "-999999px"
    document.body.appendChild(textArea)
    textArea.focus()
    textArea.select()
    
    try {
      document.execCommand('copy')
      this.showFeedback()
    } catch (err) {
      console.error('Fallback copy failed: ', err)
      // Show error feedback
      this.showFeedback("Copy failed")
    }
    
    document.body.removeChild(textArea)
  }

  showFeedback(message = null) {
    console.log('Showing feedback:', message || this.feedbackValue) // Debug log
    const feedbackText = message || this.feedbackValue
    const originalContent = this.buttonTarget.innerHTML
    
    // Update button content with feedback
    this.buttonTarget.innerHTML = `
      <svg class="w-4 h-4 text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
      </svg>
      <span class="text-green-400 text-xs">${feedbackText}</span>
    `
    
    // Change button styling
    this.buttonTarget.classList.remove("text-gray-400", "hover:text-blue-400")
    this.buttonTarget.classList.add("text-green-400")
    
    // Reset after 2 seconds
    setTimeout(() => {
      this.buttonTarget.innerHTML = originalContent
      this.buttonTarget.classList.remove("text-green-400")
      this.buttonTarget.classList.add("text-gray-400", "hover:text-blue-400")
    }, 2000)
  }
}