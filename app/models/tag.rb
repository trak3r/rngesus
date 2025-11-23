# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :randomizer_tags, dependent: :destroy
  has_many :randomizers, through: :randomizer_tags

  validates :name, presence: true, uniqueness: true
end
