class Result < ApplicationRecord
  belongs_to :roll

  validates :name, presence: true
  validates :value, presence: true,
    uniqueness: { scope: :roll_id,
                  message: "has already been taken for this roll" }
  validate :value_within_dice_range

  private

    def value_within_dice_range
      return if value.blank? || roll.blank?

      if value <= 0
        errors.add(:value, "must be greater than 0")
      elsif roll.dice && value > roll.dice
        errors.add(:value, "must be less than or equal to #{roll.dice}")
      end
    end
end
