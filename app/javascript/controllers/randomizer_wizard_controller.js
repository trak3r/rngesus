import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["resultsContainer", "resultField"]

    addResult(event) {
        event.preventDefault()

        const container = this.resultsContainerTarget
        const lastField = this.resultFieldTargets[this.resultFieldTargets.length - 1]

        if (!lastField) return

        // Clone the last result field
        const newField = lastField.cloneNode(true)

        // Clear the input values
        const inputs = newField.querySelectorAll('input[type="text"], input[type="number"]')
        inputs.forEach(input => {
            input.value = ''
        })

        // Update the field indices to ensure unique names
        const timestamp = new Date().getTime()
        inputs.forEach(input => {
            const name = input.getAttribute('name')
            if (name) {
                // Replace the index with timestamp to make it unique
                const newName = name.replace(/\[results_attributes\]\[\d+\]/, `[results_attributes][${timestamp}]`)
                input.setAttribute('name', newName)
                input.setAttribute('id', input.getAttribute('id').replace(/\d+/, timestamp))
            }
        })

        // Append the new field
        container.appendChild(newField)
    }

    removeResult(event) {
        event.preventDefault()

        // Don't remove if it's the last field
        if (this.resultFieldTargets.length <= 1) {
            return
        }

        const field = event.target.closest('[data-randomizer-wizard-target="resultField"]')
        if (field) {
            field.remove()
        }
    }
}
