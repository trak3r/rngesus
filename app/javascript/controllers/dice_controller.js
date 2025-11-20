import { Controller } from "@hotwired/stimulus"
import DiceBox from "@3d-dice/dice-box"

export default class extends Controller {
    static values = {
        config: Object,
        result: String,
        dice: String,
        rolled: Number,
        animate: { type: Boolean, default: true }
    }

    static box = null
    static pendingRolls = []
    static isInitializing = false

    async connect() {
        console.log("Dice controller connected", this.element)

        if (!this.constructor.box && !this.constructor.isInitializing) {
            this.constructor.isInitializing = true
            this.initBox().catch(e => console.error("Init Error:", e))
        }

        if (this.animateValue) {
            if (this.constructor.box) {
                this.roll().catch(e => console.error("Roll Error:", e))
            } else {
                console.log("Queueing roll")
                this.constructor.pendingRolls.push(this)
            }
        }
    }

    async initBox() {
        console.log("Initializing DiceBox singleton")

        if (!document.getElementById('dice-box-container')) {
            const container = document.createElement('div')
            container.id = 'dice-box-container'
            container.style.position = 'fixed'
            container.style.top = '0'
            container.style.left = '0'
            container.style.width = '100vw'
            container.style.height = '100vh'
            container.style.zIndex = '1000'
            container.style.pointerEvents = 'none'

            // Force canvas to fill container
            const style = document.createElement('style')
            style.innerHTML = `
                #dice-box-container canvas {
                    width: 100% !important;
                    height: 100% !important;
                    display: block;
                }
            `
            document.head.appendChild(style)

            document.body.appendChild(container)
        }

        try {
            const box = new DiceBox({
                container: "#dice-box-container",
                assetPath: "/assets/dice-box/",
                theme: "default",
                scale: 8, // Reduced scale to ~75% of previous
                gravity: 1,
                mass: 1,
                friction: 0.8
            })

            await box.init()
            console.log("Box initialized")
            this.constructor.box = box
            this.constructor.isInitializing = false

            // Process pending
            while (this.constructor.pendingRolls.length > 0) {
                const controller = this.constructor.pendingRolls.shift()
                controller.roll().catch(e => console.error("Pending Roll Error:", e))
                // Add small delay to stagger rolls
                await new Promise(r => setTimeout(r, 300))
            }
        } catch (error) {
            console.error("DiceBox Init Failed:", error)
            this.constructor.isInitializing = false
        }
    }

    async roll() {
        console.log("Rolling dice:", this.diceValue, "Result:", this.rolledValue)

        // Normalize dice string (e.g. "D100" -> "d100")
        let diceNotation = this.diceValue.toLowerCase()

        // Handle unsupported D100 by converting to 2d10 (percentile) or just d20 as fallback for now
        // dice-box 1.1.3 might not support d100 out of the box with default theme
        if (diceNotation.includes("d100")) {
            console.warn("D100 not fully supported, using 2d10 as visual proxy")
            // We can't easily fake 1-100 with 2d10 visually summing to it without complex logic
            // For now, let's just try to roll it as is, but lowercase might fix the "Invalid notation" error
            // If it still fails, we might need to swap to d20s
        }

        // Parse the dice string (e.g. "2d6+2")
        // Regex matches: [full, count, faces, modifier]
        const diceRegex = /(?:(\d+))?d(\d+)(?:([+-]\d+))?/i
        const match = diceNotation.match(diceRegex)

        if (!match) {
            console.error("Invalid dice format:", diceNotation)
            return
        }

        const count = parseInt(match[1] || "1", 10)
        const faces = parseInt(match[2], 10)
        const modifier = parseInt(match[3] || "0", 10)

        // Reconstruct notation to ensure count is present (e.g. "d12" -> "1d12")
        // dice-box might require the count explicitly
        const explicitNotation = `${count}d${faces}`

        // alert("Explicit Notation: " + explicitNotation)

        let targetSum = parseInt(this.rolledValue, 10)

        if (isNaN(targetSum)) {
            // If we can't parse the result, just roll random
            this.constructor.box.roll(explicitNotation, { newStartPoint: true })
            return
        }

        // Adjust target sum by removing modifier
        let sumToFind = targetSum - modifier

        // Generate individual die values that sum to `sumToFind`
        const results = this.generateDieValues(count, faces, sumToFind)

        if (results) {
            // dice-box expects an array of results matching the dice count
            // We need to construct the roll notation or object for dice-box
            // box.roll("2d6", [3, 4])
            this.constructor.box.roll(explicitNotation, results, { newStartPoint: true })
        } else {
            console.warn("Could not find matching dice values for", sumToFind)
            this.constructor.box.roll(explicitNotation, { newStartPoint: true })
        }
    }

    generateDieValues(count, faces, targetSum) {
        // Simple algorithm to find `count` integers between 1 and `faces` that sum to `targetSum`
        if (targetSum < count * 1 || targetSum > count * faces) return null

        let currentSum = 0
        const values = []

        // Initialize with 1s
        for (let i = 0; i < count; i++) {
            values[i] = 1
            currentSum += 1
        }

        // Distribute the remaining sum
        let remaining = targetSum - currentSum

        for (let i = 0; i < count; i++) {
            const add = Math.min(remaining, faces - 1)
            values[i] += add
            remaining -= add
            if (remaining === 0) break
        }

        // Shuffle the values so it doesn't look deterministic (e.g. always [6, 6, 1])
        for (let i = values.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [values[i], values[j]] = [values[j], values[i]];
        }

        return values
    }
}
