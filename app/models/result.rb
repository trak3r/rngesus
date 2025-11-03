class Result < ApplicationRecord
  belongs_to :roll
  validates :name, presence: true
end
