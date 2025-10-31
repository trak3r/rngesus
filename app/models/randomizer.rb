class Randomizer < ApplicationRecord
  validates :name, presence: true

  has_many :rolls, dependent: :destroy

  broadcasts_to ->(randomizer) { :randomizers }, inserts_by: :append
end
