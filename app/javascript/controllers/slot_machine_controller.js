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
    // Add 300ms to duration for each index position
    // First result: 1200ms, second: 1500ms, third: 1800ms, etc.
    const duration = this.durationValue + (this.indexValue * 600)
    const results = this.allResultsValue
    const finalResult = this.finalResultValue

    // Add spinning class for visual effect
    this.resultTarget.classList.add('slot-spinning')

    let lastChangeTime = startTime
    let currentIndex = 0

    const animate = () => {
      const elapsed = Date.now() - startTime
      const progress = Math.min(elapsed / duration, 1)

      // More dramatic easing function: very fast at start, very slow at end
      // Using power of 5 for even more dramatic slowdown
      const easeOut = 1 - Math.pow(1 - progress, 5)

      if (progress < 1) {
        // Calculate delay between changes - increases dramatically as we slow down
        // Starts at ~30ms (very fast), ends at ~500ms (slow tick)
        const changeDelay = 30 + (easeOut * 470)

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
