# frozen_string_literal: true

module Avo
  module Resources
    class Result < Avo::BaseResource
      self.includes = []

      def fields
        field :id, as: :id
        field :name, as: :text
        field :value, as: :number
        field :roll, as: :belongs_to
        field :discarded_at, as: :date_time, readonly: true
        field :created_at, as: :date_time, readonly: true
        field :updated_at, as: :date_time, readonly: true
      end

      # Show all records including discarded ones in Avo admin
      def query
        super.with_discarded
      end
    end
  end
end
