class Roll < ApplicationRecord
  belongs_to :randomizer
  has_many :results
  validates :name, presence: true
  attribute :dice, :json, default: []
end
