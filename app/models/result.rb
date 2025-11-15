# frozen_string_literal: true

class Result < ApplicationRecord
  belongs_to :roll

  validates :name, presence: true
  validates :value, presence: true,
                    uniqueness: { scope: :roll_id }

  # removing this constraint because some tables allow
  # for bonuses e.g. shadowdark carousing p. 93
  # validate :value_within_dice_range

  private

  def value_within_dice_range
    return if value.blank? || roll.blank?

    if value.to_i < roll.dice_object.min
      errors.add(
        :value,
        :too_small,
        min: roll.dice_object.min
      )
    elsif value.to_i > roll.dice_object.max
      errors.add(
        :value,
        :too_large,
        max: roll.dice_object.max
      )
    end
  end
end
