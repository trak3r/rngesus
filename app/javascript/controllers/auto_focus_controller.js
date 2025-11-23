/**
 * Auto Focus Controller
 * 
 * Purpose: Automatically focuses on a specified input field when the controller connects.
 * Status: RESERVED FOR FUTURE USE
 * 
 * Planned Usage: Will be used to auto-focus form inputs for better UX,
 * particularly in modals and inline editing scenarios.
 * 
 * Example usage (when implemented):
 *   <input data-controller="auto-focus" data-auto-focus-target="input" />
 */
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Try to focus immediately (useful when controller is initialized on inserted content)
    requestAnimationFrame(() => this.focusFirst());

    // Also listen for turbo:frame-load in case the frame is replaced by Turbo after connect
    this._frameLoadHandler = (event) => {
      // event.target is the turbo-frame element that just loaded
      if (!event || !event.target) return;
      const target = event.target;
      // If this controller's element is the frame that loaded (or contains the frame), focus
      if (target.id === this.element.id || this.element.contains(target)) {
        // focus on the next tick to ensure content is ready
        requestAnimationFrame(() => this.focusFirst());
      }
    };

    window.addEventListener('turbo:frame-load', this._frameLoadHandler);
  }

  disconnect() {
    if (this._frameLoadHandler) window.removeEventListener('turbo:frame-load', this._frameLoadHandler)
  }

  focusFirst() {
    const el = this.element.querySelector('input, textarea, select')
    if (el) el.focus()
  }
}
