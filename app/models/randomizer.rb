# frozen_string_literal: true

class Randomizer < ApplicationRecord
  include ImmutableAttributes

  acts_as_votable

  belongs_to :user
  has_many :rolls, dependent: :destroy
  has_many :randomizer_tags, dependent: :destroy
  has_many :tags, -> { order(:name) }, through: :randomizer_tags

  # Make slug immutable after creation
  attr_immutable :slug

  before_validation :generate_slug_if_blank

  validates :name, presence: true, profanity: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9]{5}\z/ }
  validate :maximum_tags_limit

  scope :search, ->(query) { where('randomizers.name LIKE ?', "%#{query}%") if query.present? }
  scope :newest, -> { order(created_at: :desc) }
  scope :most_liked, -> { order(cached_votes_total: :desc) }
  scope :tagged_with, lambda { |tag_names|
    return if tag_names.blank?

    tags_list = Array(tag_names).reject(&:blank?)
    return if tags_list.empty?

    # Use pluck to get IDs first to avoid GROUP BY conflicts with other scopes (like ordering)
    ids = joins(:tags)
          .where(tags: { name: tags_list })
          .group('randomizers.id')
          .having('COUNT(DISTINCT tags.id) = ?', tags_list.size)
          .pluck('randomizers.id')

    where(id: ids)
  }

  def to_param
    slug
  end

  # Returns the first tag for single-tag UI display
  def primary_tag
    tags.first
  end

  private

  def maximum_tags_limit
    return unless tags.size > 3

    errors.add(:tags, 'cannot exceed 3 tags per randomizer')
  end

  def generate_slug_if_blank
    return if slug.present?

    loop do
      self.slug = SecureRandom.alphanumeric(5)
      # Check if slug already exists
      break unless Randomizer.exists?(slug: slug)
    end
  end
end
