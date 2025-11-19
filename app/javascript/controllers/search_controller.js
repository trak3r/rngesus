import { Controller } from "@hotwired/stimulus"

/**
 * Search Controller
 * 
 * Purpose: Provides type-ahead search functionality for the randomizers index page.
 * 
 * This controller automatically submits the search form whenever the user types in the
 * search input field, creating a real-time filtering experience. The form submission is
 * debounced (delayed by 200ms) to avoid excessive requests while the user is still typing.
 * 
 * How it works:
 * 1. User types in the search input field
 * 2. The input event triggers the submit() action
 * 3. submit() debounces the request (waits 200ms after the last keystroke)
 * 4. Form is submitted via Turbo, which updates only the "randomizers" frame
 * 5. Server filters results and returns updated HTML
 * 6. Page updates without a full reload
 * 
 * Connected to: app/views/randomizers/index.html.erb
 */
export default class extends Controller {
    static targets = ["input", "form"]

    connect() {
        console.log("Search controller connected")
    }

    /**
     * Debounced form submission handler
     * 
     * Called on every input event from the search field. Clears any pending
     * submission timeout and schedules a new one. This ensures we only submit
     * the form 200ms after the user stops typing, reducing server load.
     */
    submit() {
        clearTimeout(this.timeout)
        this.timeout = setTimeout(() => {
            this.formTarget.requestSubmit()
        }, 200)
    }
}
