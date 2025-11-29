# frozen_string_literal: true

class Roll < ApplicationRecord
  include Discard::Model

  belongs_to :randomizer
  has_many :results, -> { kept }, dependent: :destroy

  validates :name, presence: true, profanity: true
  validates :dice, presence: true
  validate :dice_must_be_valid

  def dice_object
    @dice_object = Dice.new dice
  end

  def outcome
    return nil if results.empty? || dice.nil?

    rolled = dice_object.roll
    # select only results whose value <= rolled
    eligible = results.select { |r| r.value <= rolled }

    # pick the result with the largest value among eligible, or nil if none
    [rolled, eligible.max_by(&:value)]
  end

  private

  def dice_must_be_valid
    Dice.new(dice)
  rescue StandardError => e
    errors.add(:dice, e.message)
  end
end
