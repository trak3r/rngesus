import { Controller } from "@hotwired/stimulus"

/**
 * Slot Machine Animation Controller
 * 
 * Creates a slot machine-style spinning animation for result reveals.
 * Rapidly cycles through possible results, gradually slows down, and
 * locks in the final result with a bounce effect.
 */
export default class extends Controller {
  static targets = ["result"]
  static values = {
    finalResult: String,
    allResults: Array,
    duration: { type: Number, default: 2000 }
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
    
    const animate = () => {
      const elapsed = Date.now() - startTime
      const progress = Math.min(elapsed / duration, 1)
      
      // Easing function: starts fast, slows down exponentially
      const easeOut = 1 - Math.pow(1 - progress, 3)
      
      if (progress < 1) {
        // Still spinning - show random results
        // Frequency decreases as we approach the end
        const shouldChange = Math.random() > easeOut * 0.95
        
        if (shouldChange) {
          const randomResult = results[Math.floor(Math.random() * results.length)]
          this.resultTarget.textContent = randomResult
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
