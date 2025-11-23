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
            // Note: Only 'default' theme is currently available in assets
            // Additional themes would require downloading theme files to public/assets/dice-box/themes/
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
        let originalNotation = diceNotation

        // Map unsupported dice types to visual proxies
        const diceMap = {
            'd2': '1d6',      // Coin flip -> d6 proxy
            'd40': '2d20',    // D40 -> 2d20 visual proxy
            'd66': '2d6',     // Sequence notation -> 2d6
        }

        // Check if we need to map this dice type
        for (const [unsupported, proxy] of Object.entries(diceMap)) {
            if (diceNotation.includes(unsupported)) {
                console.log(`Mapping ${unsupported} to ${proxy} for visual display`)
                diceNotation = proxy
                break
            }
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
        const explicitNotation = `${count}d${faces}`

        let targetSum = parseInt(this.rolledValue, 10)

        if (isNaN(targetSum)) {
            // If we can't parse the result, just roll random
            this.constructor.box.roll(explicitNotation, { newStartPoint: true })
            return
        }

        // Special handling for D2 (coin flip)
        if (originalNotation.includes('d2')) {
            // Map result: 1 = heads (show 1-3), 2 = tails (show 4-6)
            const coinResult = targetSum === 1
                ? [1, 2, 3][Math.floor(Math.random() * 3)]
                : [4, 5, 6][Math.floor(Math.random() * 3)]
            this.constructor.box.roll('1d6', [coinResult], { newStartPoint: true })
            return
        }

        // Special handling for D100
        if (faces === 100) {
            // D100 result IS the final value (1-100)
            // Try to show it directly
            this.constructor.box.roll(explicitNotation, [targetSum], { newStartPoint: true })
            return
        }

        // Special handling for D40 and D66 (using proxies)
        if (originalNotation.includes('d40') || originalNotation.includes('d66')) {
            // For D40: result is 1-40, we're showing 2d20
            // For D66: result is sequence like "12", "34", we're showing 2d6
            // Just distribute the visual result across the proxy dice
            const results = this.generateDieValues(count, faces, targetSum)
            if (results) {
                this.constructor.box.roll(explicitNotation, results, { newStartPoint: true })
            } else {
                this.constructor.box.roll(explicitNotation, { newStartPoint: true })
            }
            return
        }

        // Standard dice: adjust target sum by removing modifier
        let sumToFind = targetSum - modifier

        // Generate individual die values that sum to `sumToFind`
        const results = this.generateDieValues(count, faces, sumToFind)

        if (results) {
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
