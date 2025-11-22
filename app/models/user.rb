# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_voter

  has_many :randomizers, dependent: :destroy
  validates :provider, :uid, presence: true
  validates :nickname, length: { maximum: 50 }, allow_blank: true

  # Returns the best display name for the user
  # Priority: nickname > name > uid
  def display_name
    nickname.presence || name.presence || uid
  end
end
