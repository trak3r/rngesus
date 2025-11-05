class Roll < ApplicationRecord
  belongs_to :randomizer
  has_many :results
  validates :name, presence: true
  attribute :dice, :json, default: []

  def combinations
    # placeholder
    4
  end

  def results_with_placeholders
    temp = results
    while temp.size < combinations
      temp << results.build
    end
    return temp
  end
end
