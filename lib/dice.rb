# frozen_string_literal: true

require_relative 'dice_notations/dice_notation'
require_relative 'dice_notations/summed_dice_notation'
require_relative 'dice_notations/sequence_dice_notation'

class Dice
  # Factory method to create appropriate DiceNotation instance
  def self.new(name, icon = nil, name_alt = nil)
    # Heuristic: If name is just "d" + number > 10 (and not standard), use Sequence.
    # Standard exceptions: 12, 20, 100.
    # Also check for multiplier or modifier. Sequence dice usually don't have them.
    
    if name =~ /^d(\d+)$/i
      face = ::Regexp.last_match(1).to_i
      if face > 10 && ![12, 20, 100].include?(face)
        return SequenceDiceNotation.new(name, icon, name_alt)
      end
    end
    
    SummedDiceNotation.new(name, icon, name_alt)
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
      SummedDiceNotation.new('D2', 'coin', 'Coin'),
      SummedDiceNotation.new('D4', 'triangle'),
      SummedDiceNotation.new('D6', 'dice-6'),
      SummedDiceNotation.new('2D6', 'dice'),
      SummedDiceNotation.new('4D6-4', 'dice', 'JAGS'),
      SequenceDiceNotation.new('D40', 'dice'),
      SequenceDiceNotation.new('D66', 'dice'),
      SummedDiceNotation.new('D8', 'diamond'),
      SummedDiceNotation.new('D10', 'pentagon'),
      SummedDiceNotation.new('D12', 'hexagon'),
      SummedDiceNotation.new('D20', 'hexagon'),
      # FIXME: d100 should be a special case sequence notation even though it works as summed
      SummedDiceNotation.new('D100', 'percentage'),
    ]
  end
end
