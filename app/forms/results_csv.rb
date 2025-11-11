class ResultsCsv
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :file

  validates :file, presence: true
end

