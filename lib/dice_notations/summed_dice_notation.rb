# frozen_string_literal: true

module DiceNotations
  class SummedDiceNotation < DiceNotation
    attr_reader :multiplier, :face, :modifier

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
        raise "Could not parse #{name} as SummedDiceNotation"
      end
    end
  end
end
