class Randomizer < ApplicationRecord
  has_many :rolls, dependent: :destroy
end
