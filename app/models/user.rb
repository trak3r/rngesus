# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_voter

  has_many :randomizers, dependent: :destroy
  validates :provider, :uid, presence: true
  validates :nickname, length: { maximum: 50 }, allow_blank: true, profanity: true

  # Returns the best display name for the user
  # Priority: nickname > name (as initials) > uid
  def display_name
    return nickname if nickname.present?
    return name_to_initials if name.present?

    uid
  end

  # Check if user is admin (trak3r@gmail.com)
  def admin?
    provider == 'google_oauth2' && uid == '105389714176102520548'
  end

  private

  # Converts a full name to initials (e.g., "John Doe" -> "JD")
  def name_to_initials
    return nil if name.blank?

    name.split(/\s+/)
        .filter_map { |word| word[0]&.upcase }
        .join
  end
end
