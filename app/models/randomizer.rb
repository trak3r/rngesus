# frozen_string_literal: true

class Randomizer < ApplicationRecord
  acts_as_votable

  belongs_to :user
  has_many :rolls, dependent: :destroy

  scope :search, ->(query) { where('name LIKE ?', "%#{query}%") if query.present? }
end
