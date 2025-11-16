# frozen_string_literal: true

class Dice
  attr_reader :name, :multipler, :face, :modifier, :icon

  def initialize(name)
    @name = name
  end
end

=begin
Dice.register('Coin', 2, 'coins')
Dice.register('D4', 4, 'triangle')
Dice.register('D6', 6, 'cube')
Dice.register('2D6', [6, 6], 'cube-plus')
Dice.register('D8', 8, 'pentagon-number-8')
Dice.register('D10', 10, '')
Dice.register('D12', 12, 'clock')
Dice.register('D20', 20, 'ikosaedr')
Dice.register('D100', [10, 10], 'square-rounded-percentage', :position)
=end
