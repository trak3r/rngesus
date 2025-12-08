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
  validate :maximum_tags_limit

  scope :search, ->(query) { where('rolls.name LIKE ?', "%#{query}%") if query.present? }
  scope :newest, -> { order(created_at: :desc) }
  scope :most_liked, -> { order(cached_votes_total: :desc) }
  scope :tagged_with, lambda { |tag_names|
    return if tag_names.blank?

    tags_list = Array(tag_names).compact_blank
    return if tags_list.empty?

    # Use pluck to get IDs first to avoid GROUP BY conflicts with other scopes (like ordering)
    ids = joins(:tags)
          .where(tags: { name: tags_list })
          .group('rolls.id')
          .having('COUNT(DISTINCT tags.id) = ?', tags_list.size)
          .pluck('rolls.id')

    where(id: ids)
  }

  def to_param
    # Use ID in Avo admin, slug everywhere else
    return id.to_s if defined?(Avo) && caller.any? { |line| line.include?('avo') }

    slug
  end

  # Returns the first tag for single-tag UI display
  def primary_tag
    tags.first
  end

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

  def maximum_tags_limit
    return unless tags.size > 3

    errors.add(:tags, 'cannot exceed 3 tags per roll')
  end

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
