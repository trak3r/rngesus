class Dice
  attr_reader :name, :values, :icon, :strategy

  private_class_method :new
  @@all = []

  def self.register(name, values, icon, strategy = :sum)
    instance = new(name, values, icon, strategy)
    @@all << instance
    instance
  end

  def self.all
    @@all.freeze
  end

  def self.find(name)
    @@all.find { |dice_instance| dice_instance.name == name }
  end

  # --- Public API ---

  def min
    values.map { |v| zero_based?(v) ? 0 : 1 }.sum
  end

  def max
    if strategy == :position
      # For each die, take max possible value for this die
      max_digits = values.map { |v| zero_based?(v) ? v - 1 : v }
      max_digits.join.to_i
    else
      values.sum { |v| zero_based?(v) ? v - 1 : v }
    end
  end

  def roll
    if strategy == :position
      digits = values.map { |v| rand(die_range(v)) }
      digits.join.to_i
    else
      values.sum { |v| rand(die_range(v)) }
    end
  end

  private

  def initialize(name, values, icon, strategy)
    @name = name.freeze
    @values = [values].flatten
    @icon = icon
    @strategy = strategy
  end

  # Returns true if this die should be zero-based (d10)
  def zero_based?(faces)
    faces == 10
  end

  # Returns the correct range for a die: 0..9 for d10, 1..faces otherwise
  def die_range(faces)
    zero_based?(faces) ? (0..9) : (1..faces)
  end
end

# --- Register Dice ---
Dice.register("Coin", 2, "coins")
Dice.register("D4", 4, "triangle")
Dice.register("D6", 6, "cube")
Dice.register("2D6", [6,6], "cube-plus")
Dice.register("D8", 8, "pentagon-number-8")
Dice.register("D10", 10, "square-rounded-percentage")
Dice.register("D12", 12, "clock")
Dice.register("D20", 20, "ikosaedr")
Dice.register("D100", [10,10], "trophy", :position)

