# frozen_string_literal: true

class Dice
  attr_reader :name, :values, :icon, :strategy

  private_class_method :new
  @all = []

  class << self
    attr_reader :all

    def register(name, values, icon, strategy = :sum)
      instance = new(name, values, icon, strategy)
      @all << instance
      instance
    end

    def find(name)
      @all.find { |dice_instance| dice_instance.name == name }
    end
  end

  # --- Public API ---

  def min
    if percentile_d100?
      1
    elsif strategy == :position
      values.map { |v| zero_based?(v) ? 0 : 1 }.join.to_i
    else
      values.sum { |v| zero_based?(v) ? 0 : 1 }
    end
  end

  def max
    if percentile_d100?
      100
    elsif strategy == :position
      values.map { |v| zero_based?(v) ? v - 1 : v }.join.to_i
    else
      values.sum { |v| zero_based?(v) ? v - 1 : v }
    end
  end

  def roll
    if strategy == :position
      digits = values.map { |v| rand(die_range(v)) }

      # Special case: D100 percentile
      if percentile_d100? && digits.all?(&:zero?)
        100
      else
        digits.join.to_i
      end
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

  def zero_based?(faces)
    faces == 10
  end

  def die_range(faces)
    zero_based?(faces) ? (0..9) : (1..faces)
  end

  def percentile_d100?
    values == [10, 10] && strategy == :position
  end
end

# --- Register Dice ---
Dice.register('Coin', 2, 'coins')
Dice.register('D4', 4, 'triangle')
Dice.register('D6', 6, 'cube')
Dice.register('2D6', [6, 6], 'cube-plus')
Dice.register('D8', 8, 'pentagon-number-8')
Dice.register('D10', 10, 'diamond')
Dice.register('D12', 12, 'clock')
Dice.register('D20', 20, 'ikosaedr')
Dice.register('D100', [10, 10], 'square-rounded-percentage', :position)
