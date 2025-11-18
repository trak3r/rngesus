# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_voter

  has_many :randomizers, dependent: :destroy
  validates :provider, :uid, presence: true
end
