# frozen_string_literal: true

class Randomizer < ApplicationRecord
  include ImmutableAttributes

  acts_as_votable

  belongs_to :user
  has_many :rolls, dependent: :destroy
  has_and_belongs_to_many :tags

  # Make slug immutable after creation
  attr_immutable :slug

  before_validation :generate_slug_if_blank

  validates :name, presence: true, profanity: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9]{5}\z/ }

  scope :search, ->(query) { where('name LIKE ?', "%#{query}%") if query.present? }
  scope :newest, -> { order(created_at: :desc) }
  scope :most_liked, -> { order(cached_votes_total: :desc) }
  scope :tagged_with, ->(tag_name) {
    joins(:tags).where(tags: { name: tag_name }) if tag_name.present?
  }

  def to_param
    slug
  end

  # Returns the first tag for single-tag UI display
  def primary_tag
    tags.first
  end

  private

  def generate_slug_if_blank
    return if slug.present?

    loop do
      self.slug = SecureRandom.alphanumeric(5)
      # Check if slug already exists
      break unless Randomizer.exists?(slug: slug)
    end
  end
end
