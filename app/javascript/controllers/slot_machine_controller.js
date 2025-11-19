import { Controller } from "@hotwired/stimulus"

/**
 * Slot Machine Animation Controller
 * 
 * Creates a slot machine-style spinning animation for result reveals.
 * Results scroll vertically from top to bottom, gradually slow down,
 * and lock in the final result with a bounce effect.
 * Multiple results stagger their completion for a cascading effect.
 */
export default class extends Controller {
  static targets = ["result"]
  static values = {
    finalResult: String,
    allResults: Array,
    duration: { type: Number, default: 1000 }, // Base duration: 1.2 seconds
    index: { type: Number, default: 0 } // Position in the list for staggering
  }

  connect() {
    // Start animation when controller connects (page load or Turbo Frame update)
    this.spin()
  }

  spin() {
    if (!this.hasResultTarget || !this.allResultsValue || this.allResultsValue.length === 0) {
      return
    }

    // All start at the same time, but duration increases for each subsequent result
    // This creates staggered completion while starting simultaneously
    this.startSpin()
  }

  startSpin() {
    const startTime = Date.now()
    // Add 600ms to duration for each index position for staggered completion
    // First result: 1000ms, second: 1600ms, third: 2200ms, etc.
    const duration = this.durationValue + (this.indexValue * 600)
    const results = this.allResultsValue
    const finalResult = this.finalResultValue

    // Add spinning class for visual effect (CSS controls animation speed)
    this.resultTarget.classList.add('slot-spinning')

    let currentIndex = 0

    const animate = () => {
      const elapsed = Date.now() - startTime
      const progress = Math.min(elapsed / duration, 1)

      if (progress < 1) {
        // Cycle through results for variety during spin
        currentIndex = (currentIndex + 1) % results.length
        this.resultTarget.textContent = results[currentIndex]

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
