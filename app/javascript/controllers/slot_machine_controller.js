import { Controller } from "@hotwired/stimulus"

/**
 * Slot Machine Animation Controller
 * 
 * Creates a slot machine-style spinning animation for result reveals.
 * Results scroll vertically from top to bottom, gradually slow down,
 * and lock in the final result with a bounce effect.
 */
export default class extends Controller {
  static targets = ["result"]
  static values = {
    finalResult: String,
    allResults: Array,
    duration: { type: Number, default: 1000 } // Reduced from 2000ms to 1000ms
  }

  connect() {
    // Start animation when controller connects (page load or Turbo Frame update)
    this.spin()
  }

  spin() {
    if (!this.hasResultTarget || !this.allResultsValue || this.allResultsValue.length === 0) {
      return
    }

    const startTime = Date.now()
    const duration = this.durationValue
    const results = this.allResultsValue
    const finalResult = this.finalResultValue

    // Add spinning class for visual effect
    this.resultTarget.classList.add('slot-spinning')

    let lastChangeTime = startTime
    let currentIndex = 0

    const animate = () => {
      const elapsed = Date.now() - startTime
      const progress = Math.min(elapsed / duration, 1)

      // Easing function: starts fast, slows down exponentially
      // This creates the slot machine "slowing down" effect
      const easeOut = 1 - Math.pow(1 - progress, 4)

      if (progress < 1) {
        // Calculate delay between changes - increases as we slow down
        // Starts at ~50ms, ends at ~300ms
        const changeDelay = 50 + (easeOut * 250)

        if (Date.now() - lastChangeTime > changeDelay) {
          // Cycle through results in order for smooth scrolling effect
          currentIndex = (currentIndex + 1) % results.length
          this.resultTarget.textContent = results[currentIndex]
          lastChangeTime = Date.now()
        }

        requestAnimationFrame(animate)
      } else {
        // Animation complete - show final result
        this.resultTarget.classList.remove('slot-spinning')
        this.resultTarget.classList.add('slot-reveal')
        this.resultTarget.textContent = finalResult

        // Remove reveal class after animation completes
        setTimeout(() => {
          this.resultTarget.classList.remove('slot-reveal')
        }, 500)
      }
    }

    requestAnimationFrame(animate)
  }
}
