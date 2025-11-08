class Roll < ApplicationRecord
  belongs_to :randomizer
  has_many :results
end
