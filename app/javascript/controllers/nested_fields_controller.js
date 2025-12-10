/**
 * Nested Fields Controller
 * 
 * Purpose: Dynamically add nested form fields (e.g., results) to a form.
 * 
 * Usage:
 *   <div data-controller="nested-fields" data-nested-fields-wrapper-value="roll[results_attributes]">
 *     <template data-nested-fields-target="template">
 *       <!-- Template for new field -->
 *     </template>
 *     <div data-nested-fields-target="container">
 *       <!-- Existing fields -->
 *     </div>
 *     <button data-action="click->nested-fields#add">Add</button>
 *   </div>
 */
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "container"]
  static values = { wrapper: String }

  connect() {
    // Find the highest index used in existing fields
    this.counter = this.getNextIndex()
  }

  getNextIndex() {
    const existingFields = this.containerTarget.querySelectorAll('[data-nested-field]')
    let maxIndex = -1
    
    existingFields.forEach(field => {
      const inputs = field.querySelectorAll('input[name*="[results_attributes]"], select[name*="[results_attributes]"], textarea[name*="[results_attributes]"]')
      inputs.forEach(input => {
        const name = input.getAttribute('name')
        if (name) {
          // Extract index from name like "roll[results_attributes][0][value]"
          const match = name.match(/\[results_attributes\]\[(\d+)\]/)
          if (match) {
            const index = parseInt(match[1], 10)
            if (index > maxIndex) {
              maxIndex = index
            }
          }
        }
      })
    })
    
    // Return next available index (or 0 if no existing fields)
    return maxIndex + 1
  }

  add(event) {
    event.preventDefault()
    
    const content = this.templateTarget.innerHTML
    const newField = document.createElement('div')
    newField.setAttribute('data-nested-field', '')
    
    // Replace NEW_RECORD with the next available index
    newField.innerHTML = content.replace(/NEW_RECORD/g, this.counter)
    
    this.containerTarget.appendChild(newField)
    this.counter++
    
    // Focus on the first input in the new field
    const firstInput = newField.querySelector('input, textarea, select')
    if (firstInput) {
      requestAnimationFrame(() => firstInput.focus())
    }
  }
}
