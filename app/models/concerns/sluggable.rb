# frozen_string_literal: true

module Sluggable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_slug_if_blank
  end

  def generate_slug_if_blank
    return if slug.present?

    loop do
      self.slug = SecureRandom.alphanumeric(5)
      break unless self.class.exists?(slug: slug)
    end
  end
end
