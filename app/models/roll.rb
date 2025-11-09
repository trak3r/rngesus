class Roll < ApplicationRecord
  belongs_to :randomizer
  has_many :results

  validates :name, presence: true
  validates :dice, presence: true

  def outcome
    return nil if results.empty? || dice.nil?

    rolled = dice.roll
    # select only results whose value <= rolled
    eligible = results.select { |r| r.value <= rolled }

    # pick the result with the largest value among eligible, or nil if none
    eligible.max_by(&:value)
  end
end
