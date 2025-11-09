class Roll < ApplicationRecord
  belongs_to :randomizer
  has_many :results

  validates :name, presence: true
  validates :dice, presence: true
end
