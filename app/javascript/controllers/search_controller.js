import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
    static targets = ["input", "form"]

    connect() {
        console.log("Search controller connected")
    }

    submit() {
        clearTimeout(this.timeout)
        this.timeout = setTimeout(() => {
            this.formTarget.requestSubmit()
        }, 200)
    }
}
