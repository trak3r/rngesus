# frozen_string_literal: true

class ResultsCsv
  include ActiveModel::Model          # gives you validations, errors, etc.
  include ActiveModel::Attributes     # lets you define typed attributes (optional)
  include ActiveModel::Conversion     # adds #to_model for form_with compatibility
  extend ActiveModel::Naming          # gives it model_name, so form_with(model: ...) works

  attr_accessor :file

  validates :file, presence: true
end
