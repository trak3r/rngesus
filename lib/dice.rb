# FIXME: should this be in values_objects ?
class Dice
  # Define the attributes as readable only (immutable after initialization)
  attr_reader :name, :values, :icon

  # Private initialization ensures instances are only created internally
  private_class_method :new

  # The @@all class variable holds the immutable, pre-defined instances
  @@all = []

  # Internal factory method to create and store instances
  def self.register(name, values, icon)
    instance = new(name, values, icon)
    @@all << instance
    instance
  end

  # Public method to retrieve all pre-defined instances
  def self.all
    @@all.freeze # Optional: Ensures the array of instances can't be modified externally
  end

  def self.find(name)
    # Enumerable#find iterates over the array and returns the *first*
    # element for which the block evaluates to true.
    @@all.find { |dice_instance| dice_instance.name == name }
  end

  def min
    dice.size
  end

  def max
    dice.sum
  end

  def roll
    total = 0
    values.each do |highest_face|
      total += rand(highest_face)
    end
    total
  end

  # The private constructor for internal use
  private

    def initialize(name, values, icon)
      @name = name.freeze  # Freeze string to ensure immutability
      @values = [ values ].flatten
      @icon = icon
    end
end

# --- Define the Immutable Instances ---

# Register the pre-defined dice instances
Dice.register("Coin", 2, "coins")
Dice.register("D4", 4, "triangle")
Dice.register("D6", 6, "cube")
Dice.register("2D6", [ 6, 6 ], "cube-plus")
Dice.register("D8", 8, "pentagon-number-8")
Dice.register("D10", 10, "square-rounded-percentage")
Dice.register("D12", 12, "clock")
Dice.register("D20", 20, "ikosaedr")
Dice.register("D100", 100, "trophy") # Could be useful for a percentile system
