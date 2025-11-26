# frozen_string_literal: true

class Dice
  # Factory method to create appropriate DiceNotation instance
  def self.new(name, icon = nil, name_alt = nil)
    # Heuristic: If name is just "d" + number > 10 (and not standard), use Sequence.
    # Standard exceptions: 12, 20, 100.
    # Also check for multiplier or modifier. Sequence dice usually don't have them.

    if name =~ /^d(\d+)$/i
      face = ::Regexp.last_match(1).to_i
      return DiceNotations::SequenceDiceNotation.new(name, icon, name_alt) if face > 10 && [12, 20, 100].exclude?(face)
    end

    DiceNotations::SummedDiceNotation.new(name, icon, name_alt)
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
      DiceNotations::SummedDiceNotation.new('D2', 'coin', 'Coin'),
      DiceNotations::SummedDiceNotation.new('D4', 'triangle'),
      DiceNotations::SummedDiceNotation.new('D6', 'dice-6'),
      DiceNotations::SummedDiceNotation.new('2D6', 'dice'),
      DiceNotations::SummedDiceNotation.new('4D6-4', 'dice', 'JAGS'),
      DiceNotations::SequenceDiceNotation.new('D40', 'dice'),
      DiceNotations::SequenceDiceNotation.new('D66', 'dice'),
      DiceNotations::SummedDiceNotation.new('D8', 'diamond'),
      DiceNotations::SummedDiceNotation.new('D10', 'pentagon'),
      DiceNotations::SummedDiceNotation.new('D12', 'hexagon'),
      DiceNotations::SummedDiceNotation.new('D20', 'hexagon'),
      # FIXME: d100 should be a special case sequence notation even though it works as summed
      DiceNotations::SummedDiceNotation.new('D100', 'percentage')
    ]
  end
end
