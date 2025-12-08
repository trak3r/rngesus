# frozen_string_literal: true

class Roll < ApplicationRecord
  include Discard::Model

  belongs_to :randomizer, optional: true
  belongs_to :user
  
  has_many :roll_tags, dependent: :destroy
  has_many :tags, through: :roll_tags
  has_many :results, -> { kept }, dependent: :destroy, inverse_of: :roll
  
  acts_as_votable
  
  include ImmutableAttributes
  attr_immutable :slug
  
  before_validation :generate_slug_if_blank

  accepts_nested_attributes_for :results, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true, profanity: true
  validates :dice, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9]{5}\z/ }

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

  def generate_slug_if_blank
    return if slug.present?

    loop do
      self.slug = SecureRandom.alphanumeric(5)
      break unless Roll.exists?(slug: slug)
    end
  end
end
