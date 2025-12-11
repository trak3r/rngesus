# frozen_string_literal: true

class Tag < ApplicationRecord
  include Discard::Model

  has_many :roll_tags, dependent: :destroy
  has_many :rolls, through: :roll_tags

  validates :name, presence: true, uniqueness: true
end
