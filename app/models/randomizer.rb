class Randomizer < ApplicationRecord
  validates :name, presence: true
  
  broadcasts_to ->(randomizer) { :randomizers }, inserts_by: :prepend
end
