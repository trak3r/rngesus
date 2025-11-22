# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_voter

  has_many :randomizers, dependent: :destroy
  validates :provider, :uid, presence: true
  validates :nickname, length: { maximum: 50 }, allow_blank: true

  # Returns the best display name for the user
  # Priority: nickname > name (as initials) > uid
  def display_name
    return nickname if nickname.present?
    return name_to_initials if name.present?
    uid
  end

  private

  # Converts a full name to initials (e.g., "John Doe" -> "JD")
  def name_to_initials
    return nil unless name.present?
    
    name.split(/\s+/)
        .map { |word| word[0]&.upcase }
        .compact
        .join
  end
end
