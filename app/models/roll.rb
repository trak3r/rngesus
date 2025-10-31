class Roll < ApplicationRecord
  belongs_to :randomizer
  validates :name, presence: true
end
