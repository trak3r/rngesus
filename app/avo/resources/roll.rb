# frozen_string_literal: true

module Avo
  module Resources
    class Roll < Avo::BaseResource
      # self.includes = []
      # self.attachments = []
      # self.search = {
      #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
      # }

      def fields
        field :id, as: :id
        field :name, as: :text
        field :dice, as: :text
        field :randomizer, as: :belongs_to
        field :results, as: :has_many
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
