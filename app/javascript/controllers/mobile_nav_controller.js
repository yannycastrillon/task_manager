import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "burger", "overlay"]
  static classes = ["open", "closed"]

  connect() {
    // Close menu when clicking outside
    document.addEventListener('click', this.handleClickOutside.bind(this))
    
    // Close menu on escape key
    document.addEventListener('keydown', this.handleEscape.bind(this))
    
    // Close menu on window resize (if switching to desktop)
    window.addEventListener('resize', this.handleResize.bind(this))
  }

  disconnect() {
    document.removeEventListener('click', this.handleClickOutside.bind(this))
    document.removeEventListener('keydown', this.handleEscape.bind(this))
    window.removeEventListener('resize', this.handleResize.bind(this))
  }

  toggle() {
    if (this.isOpen()) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.menuTarget.classList.remove('translate-x-full', 'opacity-0')
    this.menuTarget.classList.add('translate-x-0', 'opacity-100')
    this.burgerTarget.classList.add('open')
    this.overlayTarget.classList.remove('hidden')
    document.body.classList.add('overflow-hidden')
  }

  close() {
    this.menuTarget.classList.remove('translate-x-0', 'opacity-100')
    this.menuTarget.classList.add('translate-x-full', 'opacity-0')
    this.burgerTarget.classList.remove('open')
    this.overlayTarget.classList.add('hidden')
    document.body.classList.remove('overflow-hidden')
  }

  isOpen() {
    return this.menuTarget.classList.contains('translate-x-0')
  }

  handleClickOutside(event) {
    if (this.isOpen() && !this.element.contains(event.target)) {
      this.close()
    }
  }

  handleEscape(event) {
    if (event.key === 'Escape' && this.isOpen()) {
      this.close()
    }
  }

  handleResize() {
    if (window.innerWidth >= 768 && this.isOpen()) {
      this.close()
    }
  }
} 