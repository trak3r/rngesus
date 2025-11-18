# frozen_string_literal: true

class Randomizer < ApplicationRecord
  acts_as_votable

  belongs_to :user
  has_many :rolls, dependent: :destroy
end
