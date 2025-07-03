import { Controller } from "@hotwired/stimulus"

// Usage: data-controller="copy" data-copy-target="source" data-copy-target="tooltip" data-action="click->copy#copy"
export default class extends Controller {
  static targets = ["source", "tooltip"]

  copy(event) {
    event.preventDefault();
    const text = this.sourceTarget.innerText || this.sourceTarget.value;
    navigator.clipboard.writeText(text);
    if (this.hasTooltipTarget) {
      this.tooltipTarget.classList.remove("hidden");
      setTimeout(() => {
        this.tooltipTarget.classList.add("hidden");
      }, 1200);
    }
  }
}