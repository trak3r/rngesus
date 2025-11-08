class Roll < ApplicationRecord
  belongs_to :randomizer
  has_many :results
  validates :name, presence: true

  def results_with_placeholders
    temp = results
    while temp.size < (dice || 2)
      temp << results.build(name: "Placeholder")
    end
    temp
  end
end
