# frozen_string_literal: true

class Dice
  attr_reader :name, :multipler, :face, :modifier, :icon

  def initialize(name)
    @name = name

    if @name =~ /^
(?:(\d+))?   # multiplier (optional)
d
(\d+)        # die faces
(?:([+-]\d+))?  # modifier (optional)
$/x

      @multipler = (::Regexp.last_match(1) || '1').to_i
      @face = ::Regexp.last_match(2).to_i
      @modifier = (::Regexp.last_match(3) || '0').to_i
    else
      raise "Could not parse #{name}"
    end
  end

  def min
    @multipler + @modifier
  end

  def max
    (@multipler * @face) + @modifier
  end

  def roll
    result = 0

    @multipler.times do
      result += rand(@face)
    end

    result += @modifier

    result
  end
end

# Dice.register('Coin', 2, 'coins')
# Dice.register('D4', 4, 'triangle')
# Dice.register('D6', 6, 'cube')
# Dice.register('2D6', [6, 6], 'cube-plus')
# Dice.register('D8', 8, 'pentagon-number-8')
# Dice.register('D10', 10, '')
# Dice.register('D12', 12, 'clock')
# Dice.register('D20', 20, 'ikosaedr')
# Dice.register('D100', [10, 10], 'square-rounded-percentage', :position)
