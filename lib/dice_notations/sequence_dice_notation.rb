# frozen_string_literal: true

require_relative 'dice_notation'

class SequenceDiceNotation < DiceNotation
  attr_reader :digits

  def min
    # Concatenation of min value of each digit
    # If digit is 0 (d10), min is 0.
    # If digit is N (dN), min is 1.
    
    min_values = @digits.map do |d|
      if d == 0
        0
      else
        1
      end
    end
    min_values.join.to_i
  end

  def max
    # Concatenation of max value of each digit
    # If digit is 0 (d10), max is 9.
    # If digit is N (dN), max is N.
    
    max_values = @digits.map do |d|
      if d == 0
        9
      else
        d
      end
    end
    max_values.join.to_i
  end

  def roll
    results = @digits.map do |d|
      if d == 0
        rand(0..9)
      else
        rand(1..d)
      end
    end
    results.join.to_i
  end

  private

  def parse!
    # Expected format: dXY...
    # e.g. d66, d40
    
    if @name =~ /^d(\d+)$/i
      number_part = ::Regexp.last_match(1)
      @digits = number_part.chars.map(&:to_i)
    else
      raise "Could not parse #{name} as SequenceDiceNotation"
    end
  end
end
