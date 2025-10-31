class Roll < ApplicationRecord
  belongs_to :randomizer

  validates :name, presence: true
  validates :value, presence: true
end
