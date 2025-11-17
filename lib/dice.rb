# frozen_string_literal: true

class Dice
  attr_reader :name,
    :icon,
    :name_alt,
    :multiplier,
    :face,
    :modifier

  def initialize(name, icon = nil, name_alt = nil)
    @name = name
    @icon = icon
    @name_alt = name_alt
    parse!
  end

  def min
    @min ||= @multiplier + @modifier
  end

  def max
    @max ||= (@multiplier * @face) + @modifier
  end

  def roll
    result = 0

    @multiplier.times do
      result += rand(1..@face) # inclusive 1..face
    end

    result += @modifier

    result
  end

  def self.from(text)
    dice_regex = /
      \b          # word boundary to avoid partial matches
      (?:\d*)    # optional multiplier
      d
      \d+         # die faces
      (?:[+-]\d+)? # optional modifier
      \b
    /ix

    matches = text.scan(dice_regex) # => ["1d6", "2d4"]

    matches.collect { |m| Dice.new(m) }
  end

  def self.predefined
    @predefined = [
      Dice.new('D2', 'coins', 'Coin'),
      Dice.new('D4', 'triangle'),
      Dice.new('D6', 'cube'),
      Dice.new('2D6', 'cube-plus'),
      Dice.new('4D6-4', 'cube-plus', 'JAGS'),
      Dice.new('D8', 'pentagon-number-8'),
      Dice.new('D10', 'diamond'),
      Dice.new('D12', 'clock'),
      Dice.new('D20', 'ikosaedr'),
      Dice.new('D100', 'square-rounded-percentage')
    ]
  end

  private

  def parse!
    if @name =~ /^
(?:(\d+))?   # multiplier (optional)
d
(\d+)        # die face
(?:([+-]\d+))?  # modifier (optional)
$/xi

      @multiplier = (::Regexp.last_match(1) || '1').to_i
      @face = ::Regexp.last_match(2).to_i
      @modifier = (::Regexp.last_match(3) || '0').to_i
    else
      raise "Could not parse #{name}"
    end
  end
end
