i need to support multiple types of dice rolls.

the traditional type - where multiple dice are rolled and the results are summed - is already coded.

i need a second type where the results are considered single digits concatenated together to form a multi-number digit.

for example, a 4 and a 6 would be 46 (not added together for 10)

some examples of this type of roll are d40 (d4 and d10 and d66 (d6 and d6).

basically, any number following the "d" greater than 10 would be one of these concatenation rolls.

the common logic between these roll types should be handled by a superclass or a concern - whatever is best practices for ruby.

i'm thinking the names should be something like SummedDiceNotation and ConcatenatedDiceNotation (or ChainedDiceNotation, or SequenceDiceNotation). i defer to you to choose the best naming conventions.

so the predefined method would look something like this now:

  def self.predefined
    @predefined = [
 	  SummedDiceNotation.new('2D6', 'cube-plus'),
	  SequenceDiceNotation.new('D66', 'pentagon-number-6'),
	  
include test coverage for all the peripheral functionality (min, max, etc.)