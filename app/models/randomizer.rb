# frozen_string_literal: true

class Randomizer < ApplicationRecord
  has_many :rolls, dependent: :destroy
end
