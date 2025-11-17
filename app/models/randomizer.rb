# frozen_string_literal: true

class Randomizer < ApplicationRecord
  belongs_to :user
  has_many :rolls, dependent: :destroy
end
