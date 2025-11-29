# frozen_string_literal: true

module Avo
  module Resources
    class Result < Avo::BaseResource
      include DiscardableResource
      self.includes = []

      def fields
        field :id, as: :id
        field :name, as: :text
        field :value, as: :number
        field :roll, as: :belongs_to
        field :created_at, as: :date_time, readonly: true
        field :updated_at, as: :date_time, readonly: true
      end
    end
  end
end
