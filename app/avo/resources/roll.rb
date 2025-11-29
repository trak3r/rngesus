# frozen_string_literal: true

module Avo
  module Resources
    class Roll < Avo::BaseResource
      include DiscardableResource

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
        field :created_at, as: :date_time, readonly: true
        field :updated_at, as: :date_time, readonly: true
      end
    end
  end
end
