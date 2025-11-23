/**
 * Reset Form Controller
 * 
 * Purpose: Resets form fields to their default values.
 * Status: RESERVED FOR FUTURE USE
 * 
 * Planned Usage: Will be used to provide "Reset" buttons on complex forms,
 * particularly for search filters and multi-step forms.
 * 
 * Example usage (when implemented):
 *   <button data-action="click->reset-form#reset">Reset</button>
 */
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  reset() {
    this.element.reset()
  }
}