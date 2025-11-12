# frozen_string_literal: true

class Result < ApplicationRecord
  belongs_to :roll

  validates :name, presence: true
  validates :value, presence: true,
                    uniqueness: { scope: :roll_id,
                                  message: 'has already been taken for this roll' }
  validate :value_within_dice_range

  private

  def value_within_dice_range
    return if value.blank? || roll.blank?

    if value.to_i < roll.dice_object.min
      errors.add(:value, "must be greater than or equal to #{roll.dice_object.min}")
    elsif value.to_i > roll.dice_object.max
      errors.add(:value, "must be less than or equal to #{roll.dice_object.max}")
    end
  end
end
