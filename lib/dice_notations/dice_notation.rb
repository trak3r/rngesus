# frozen_string_literal: true

class DiceNotation
  attr_reader :name,
              :icon,
              :name_alt

  def initialize(name, icon = nil, name_alt = nil)
    @name = name
    @icon = icon
    @name_alt = name_alt
    parse!
  end

  def min
    raise NotImplementedError
  end

  def max
    raise NotImplementedError
  end

  def roll
    raise NotImplementedError
  end

  private

  def parse!
    raise NotImplementedError
  end
end
