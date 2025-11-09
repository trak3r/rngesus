class Roll < ApplicationRecord
  belongs_to :randomizer
  has_many :results

  validates :name, presence: true
  validates :dice, presence: true
  validate :dice_must_be_valid

  # FIXME: this seems sloppyh leaky abstraction
  def dice_object
    Dice.find dice
  end

  def outcome
    return nil if results.empty? || dice.nil?

    rolled = dice.roll
    # select only results whose value <= rolled
    eligible = results.select { |r| r.value <= rolled }

    # pick the result with the largest value among eligible, or nil if none
    eligible.max_by(&:value)
  end

  private

    def dice_must_be_valid
      return if Dice.find?(dice)

      errors.add(:dice, "#{dice} is not a valid die")
    end
end
