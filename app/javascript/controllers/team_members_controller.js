import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["teamSelect", "userSelect"]
  static values = {
    url: String
  }

  connect() {
    this.teamSelectTarget.addEventListener("change", this.loadTeamMembers.bind(this))
  }

  async loadTeamMembers() {
    const teamId = this.teamSelectTarget.value
    if (!teamId) {
      this.userSelectTarget.innerHTML = '<option value="">Select a team first</option>'
      return
    }

    try {
      const response = await fetch(`/teams/${teamId}/members`)
      const data = await response.json()
      
      this.userSelectTarget.innerHTML = '<option value="">Select an assignee</option>'
      data.forEach(user => {
        const option = document.createElement('option')
        option.value = user.id
        option.textContent = user.full_name
        this.userSelectTarget.appendChild(option)
      })
    } catch (error) {
      console.error('Error loading team members:', error)
    }
  }
} 