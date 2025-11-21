import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = { url: String }
    static targets = ["notification"]

    async copy(event) {
        event.preventDefault()

        try {
            await navigator.clipboard.writeText(this.urlValue)
            this.showNotification()
        } catch (err) {
            console.error('Failed to copy:', err)
        }
    }

    showNotification() {
        const notification = this.notificationTarget

        // Show notification
        notification.classList.remove('hidden')
        // Force reflow to enable transition
        void notification.offsetWidth

        notification.classList.remove('opacity-0', 'pointer-events-none')
        notification.classList.add('opacity-100')

        // Hide after 2 seconds
        setTimeout(() => {
            notification.classList.remove('opacity-100')
            notification.classList.add('opacity-0', 'pointer-events-none')

            // Wait for transition to finish before hiding
            setTimeout(() => {
                notification.classList.add('hidden')
            }, 200)
        }, 2000)
    }
}
